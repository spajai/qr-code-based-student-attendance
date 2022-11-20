package QRAttendance::Utils;

use QRAttendance::Policy;

use File::Spec::Functions;
use QRAttendance::Logger;
use Moose::Util;
use Email::Valid;
use MIME::Base64 qw(decode_base64);
use POSIX;
use String::Validator::Password;
use File::Compare;
use File::Path qw(make_path remove_tree);
use JSON::XS;
use Config::Any;
use File::Spec;
use Path::Class;
use File::Basename qw(fileparse);
use File::Spec::Functions;
use POSIX;


#crypt
use Data::GUID; #TODO remove
use Crypt::PRNG;
use Digest::SHA;

#----------------------------------------------------------------------------------#
# custom module                                       #
#----------------------------------------------------------------------------------#

sub get_current_module_methods {
    my ($self, $caller, $skip_private) = (@_);
    $skip_private //= 0;
    #remove these methods
    my @skip_method_map = qw(/new DESTROY meta BUILD BUILDARGS BEGIN/);

    my $meta = Moose::Util::find_meta($caller);
    my $remove = [$meta->get_attribute_list, @skip_method_map]; 
    my $method_names = $self->array_minus( [$meta->get_method_list],$remove);

    #for custom manipulation
    my @methods;
    foreach my $name (@$method_names) {
        next if ($skip_private && $name =~ /^_/); #remove private methods can be done in caller module as well
        push @methods, $name;
    }

    return \@methods;
}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#used in all code
sub logger {
    my ($self) = @_;

    my $logger =  AudioCast::Logger->global(); #much faster than new

    return $logger;
}


#----------------------------------------------------------------------------------#
# validate password policy it will not check with database
#----------------------------------------------------------------------------------#
sub validate_password {
    my ($self, $password, $cnf_password) = @_;

    if (not defined $password || not defined $cnf_password) {
        return (0, 'Password not provided to validaed');
    }

    if ($password ne $cnf_password) {
        return (0, 'Confirm password do not match with Password');
    }

    my $pass_policy = $self->fetch_all_config->{'server_config'}->{password_policy};

    my $validator = String::Validator::Password->new(%{$pass_policy});

    my $valid  = 0;
    my $errstr = undef;

    if ($validator->IsNot_Valid($password, $cnf_password)) {
        $errstr = $validator->errstr();
    }
    else {
        $valid = 1;
    }

    return ($valid, $errstr);
}

#----------------------------------------------------------------------------------#
# validate email address
#----------------------------------------------------------------------------------#
sub validate_email {
    my ($self, $email) = @_;

    my $valid = Email::Valid->address($email) // 0;

    return $valid;
}
#----------------------------------------------------------------------------------#
# get asset path
#----------------------------------------------------------------------------------#
sub create_upload_asset {
    my ($self, $params) = @_;

    my $upload           = $params->{upload}; #upload object
    my $destination_dir  = $params->{destination_dir};
    my $calculate_sha    = $params->{calculate_sha} // 1;
    my $upload_param_name = $params->{upload_param_name} // 'file';
    my $response = {result => 0};
    unless($upload && ref($upload->{$upload_param_name}) eq 'Catalyst::Request::Upload') {
        $self->logger->error("Upload object for file key is not provided or is not a Catalyst::Request::Upload object");
        return $response;
    }

    my $filename         = $params->{filename} // $upload->{$upload_param_name}->filename;
    my $input_file_name  = $filename;
    my $append_random    = $params->{append_random} // 0;

    if($append_random) {
       my ($name, $path, $suffix) =  $self->file_parse($filename, qr/\.[^.]*/);
        $filename = $name . '_' . time . $suffix;
    }

    $upload = $upload->{$upload_param_name}; #make sure this key is a Catalyst::Request::Upload object

    $self->create_directory($destination_dir);

    my $file_path = $self->cat_file($destination_dir, $filename);

    if( !(-e -z -f -w $file_path)) {
        my $result = $upload->copy_to($file_path);

        if($result) {

            $response = {
                result  => $result ? 1 : 0,
                metadata => {
                    directory     => $destination_dir,
                    filename      => $filename,
                    size          => $upload->size,
                    type          => $upload->type,
                    headers       => [$upload->headers->flatten],
                    path          => $file_path,
                    original_name => $input_file_name
                },
            };

            if ($calculate_sha) {
                my $sha = Digest::SHA->new('sha256');
                $sha->addfile($file_path);
                $response->{digest} = $sha->digest;
                $response->{b64_digest} = $sha->b64digest;
            }
        }
    }

    return $response;
}
#----------------------------------------------------------------------------------#
# get asset path
#----------------------------------------------------------------------------------#
sub create_asset {
    my ($self, $file_data, $ext, $type) = @_;

    my ($asset_dir, $suffix_dir) = $self->get_asset_dir_path($type, 'current_dir');

    croak "Create asset error extension or data not provided" unless ($ext || $file_data);
    croak "Config Directory not configured for the $type" unless ($asset_dir || $type || -d $asset_dir);

    my $filename = $self->generate_unique_string(15);    #param => length

    $filename = "$filename.$ext";

    my $file_path = $self->cat_file($asset_dir, $suffix_dir, $filename);
    unless (-f $file_path) {
        try {
            my $decoded_data = decode_base64($file_data);
            open my $fh, '>', $file_path or die $!;
            binmode $fh;
            print $fh $decoded_data;
            close $fh;
            $self->logger->info("asset $type created successfully path $file_path");
        } catch {
            $self->logger->error("Asset file creation $type failed: ".$_);
            croak "Asset file creation $type failed: ".$_;
        };
    }
    else {
        $self->logger->warn("Asset file for $type already exist at $file_path");
    }

    return {FilePath => $file_path, FileName => $filename};

}
#----------------------------------------------------------------------------------#
# get_asset_dir_path
#type key should match the keys under conf
#key current_dir or old_dir
# asset_dir => {logo => { current_dir => '', old_dir => [], },
# avatar =>{current_dir => '', old_dir => [],},},
# favicon => {current_dir => '', old_dir => [],},
# event_prompt_audio => {current_dir => '', old_dir => [],},
#----------------------------------------------------------------------------------#
sub get_asset_dir_path {
    my ($self, $type, $key, $append) = @_;

    my $asset_dir = $self->fetch_all_config->{'server_config'}->{asset_dir}->{$type};

    return defined $key ? ($asset_dir->{$key},  $asset_dir->{suffix_dir}) : $asset_dir;
}


#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub get_user_allowed_perm_list {
    my ($self, $permission) = @_;

    my $allowed_perm_list =  $self->get_permission_menu($permission);
    #remove the SYSTEM ADMIN
    # since we dont want to associate these permission with any other org
    $allowed_perm_list = $self->array_minus($allowed_perm_list,[qw/SYSTEM ADMIN/] );
    return $allowed_perm_list;
}


#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub create_directory {
    my ($self, $dir) = @_;

    my $result = 0;
    if (! -d $dir) {
        my @created = make_path($dir, { verbose => 1, mode => 0711});
        if(scalar @created)  {
            $self->logger->info("Directory ['$dir'] created");
            $result = 1;
        }
    } else {
        $result = 1;
        $self->logger->warn("Directory ['$dir'] already exists");
    }

    return $result;
}
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub compare_file {
    my ($self, $file1, $file2) = @_;

    foreach my $file ($file1, $file2) {
        if (!(-r -e -s -f $file)) {
            $self->logger->warn("File $file is not readable / empty / or not a plain file ");
            return 0;
        }
    }

    # if (compare($FILENAME_1, $FILENAME_2) = = 0) { # they're equal }
    # if (compare(*FH1, *FH2) = = 0) { # they're equal }
    # if (compare($fh1, $fh2) = = 0) { # they're equal }

    if (compare($file1, $file2) == 0) {
        return 1;
    }
    else {
        return 0;
    }

}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#

sub delete_files {
    my ($self, $file_list) = @_;

    if(ref($file_list) ne 'ARRAY') {
        $file_list = [$file_list];
    }

    my $count;
    unless (($count = unlink(@$file_list)) == @$file_list) {
        $self->logger->warn("could only delete $count of " . (@$file_list) . " files");
    }

    return 1;
}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub get_permission_menu {
    my ($self, $permission) = @_;

    my $per_lv_map = {
        'SYSTEM'   => [qw/SYSTEM ADMIN OWNER MANAGER EMPLOYEE GUEST/],
        'ADMIN'    => [qw/OWNER MANAGER EMPLOYEE GUEST/],
        'OWNER'    => [qw/MANAGER EMPLOYEE GUEST/],
        'MANAGER'  => [qw/EMPLOYEE GUEST/],
        'EMPLOYEE' => [],
        'GUEST'    => []
    };

    return $permission ? $per_lv_map->{uc($permission)} : $per_lv_map;

}

#----------------------------------------------------------------------------------#
# get generate_unique_string 
#----------------------------------------------------------------------------------#
sub generate_unique_string {
    my ($self, $length) = @_;

    my $rand = join('', map { ('a' .. 'z')[rand(26)] } 1 .. $length // 10);

    return $rand;
}

#----------------------------------------------------------------------------------#
# validate data keys needed
#----------------------------------------------------------------------------------#
sub validate {
    my ($self, $data, $keys) = @_;

    my $valid = 1;
    my $missing;
    foreach (@{$keys}) {
        if (defined $data->{$_} && ref($data->{$_}) eq 'ARRAY') {
            if (scalar @{$data->{$_}} < 1) {
                push(@$missing, $_);
                $valid = 0;
            }
        }
        if (not defined $data->{$_}) {
            push(@$missing, $_);
            $valid = 0;
        }
        if (defined $data->{$_} && $data->{$_} =~ /^\s*$/) {
            push(@$missing, $_);
            $valid = 0;
        }
    }
    my $missing_str = join ', ', map qq/'$_'/, @$missing;

    return wantarray ? ($valid, $missing, $missing_str) : $valid;
}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub array_minus {
    my ($self, $arr1, $arr2) = @_;

    return unless (defined $arr1 && scalar @$arr1);
    return unless (defined $arr2 && scalar @$arr2);

    my %e = map { $_ => undef } @{$arr2};
    return [grep(!exists($e{$_}), @{$arr1})];
}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub enc_json {
    my ($self, $data) = @_;

    return JSON::XS->new->utf8->encode($data);
}
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub dcd_json {
    my ($self, $data) = @_;

    return JSON::XS->new->utf8->allow_nonref->decode($data);
}


#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#where to find conf directory
sub get_project_root_directory {
    my ($self) = @_;

    # my $project_root_dir = $dir->subdir( __FILE__ )->parent;
    my $file = file(__FILE__);
    #lib/Utils/__FILE__ purely depend on where this file is located (__FILE__)
    # Audiocat/../../../
    return $file->dir->parent->parent;
}
