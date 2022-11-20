package QRAttendance::Response;

use strict;
use warnings;
use utf8;

use Exporter 'import';
our @EXPORT_OK = qw/ %SERVER_RESPONSE /;

our %SERVER_RESPONSE = (

    body_decode_error => {
        throw => {
            code      => 500,
            message   => 'Error while decoding body data',
            i18n_code => 'status.body_decode_error',
        },
    },
    required_param_missing => {
        throw => {
            code      => 400,
            message   => 'Required parameters missing',
            i18n_code => 'status.required_param_missing'
        },
    },
    invalid_email => {
        throw => {
            code      => 400,
            message   => 'Invalid email provided',
            i18n_code => 'status.invalid_email'
        },
    },
    password_policy_mismatch => {
        throw => {
            code      => 400,
            message   => 'Password do not match the policy',
            i18n_code => 'status.password_policy_mismatch'
        },
    },
    internal_server_error => {
        throw => {
            code      => 500,
            message   => 'Internal Server Error',
            i18n_code => 'status.internal_server_error'
        },
    },
    email_missing => {
        throw => {
            code      => 400,
            message   => 'Bad Request email id missing',
            i18n_code => 'status.email_missing'
        },
    },
    token_expired => {
        throw => {
            code      => 400,
            message   => 'Token Expired',
            i18n_code => 'status.token_expired'
        },
    },
    invalid_token => {
        throw => {
            code       => 200,
            is_invalid => 1,
            message    => 'Invalid or Expired Token used',
            i18n_code  => 'status.invalid_token'
        },
    },
    already_activated => {
        throw => {
            code      => 409,
            message   => 'Account already activated',
            i18n_code => 'status.already_activated'
        },
    },
    activated => {
        throw => {
            code      => 200,
            message   => 'Account activated successfully',
            i18n_code => 'status.activated'
        },
    },
    activation_failed => {
        throw => {
            code      => 400,
            message   => 'Account activation failed',
            i18n_code => 'status.activation_failed'
        },
    },
    error => {
        throw => {
            code      => 500,
            message   => 'Internal Server Error',
            i18n_code => 'status.error'
        },
    },
    user_name_password_missing => {
        throw => {
            code      => 400,
            message   => 'Credentials Missing',
            i18n_code => 'status.user_name_password_missing'
        },
    },
    data_base_error => {
        throw => {
            code      => 500,
            message   => 'Internal Server error database fault',
            i18n_code => 'status.data_base_error'
        },
    },
    invalid_credentials => {
        throw => {
            code      => 401,
            message   => 'Credentials Mismatch',
            i18n_code => 'status.invalid_credentials'
        },
    },
    pending_account => {
        throw => {
            code       => 406,
            is_pending => 1,
            message    => 'Account is still pending for verification',
            i18n_code  => 'status.pending_account'
        },
    },
    password_reset_email_sent => {
        throw => {
            code      => 200,
            message   => 'Reset password link sent on Email',
            i18n_code => 'status.password_reset_email_sent'
        },
    },
    unauthorized => {
        throw => {
            code      => 401,
            message   => 'Unauthorized',
            i18n_code => 'status.unauthorized'
        },
    },
    forbidden => {
        throw => {
            code      => 403,
            message   => 'forbidden',
            i18n_code => 'status.forbidden'
        },
    },
    token_missing => {
        throw => {
            code      => 400,
            message   => 'Token missing from request',
            i18n_code => 'status.token_missing'
        },

    },
    invalid_or_expired_reset_token => {
        throw => {
            code      => 400,
            message   => 'Token used is inavlid or expired',
            i18n_code => 'status.invalid_or_expired_reset_token'
        },

    },
    user_register_succesfully => {
        throw => {
            code      => 200,
            message   => 'user registered successfully',
            i18n_code => 'status.user_register_succesfully'
        },

    },
    user_already_exist => {
        throw => {
            code      => 409,
            message   => 'User already exists',
            i18n_code => 'status.user_already_exist'
        },

    },
    deleted_user => {
        throw => {
            code      => 409,
            message   => 'User deleted',
            i18n_code => 'status.deleted_user'
        },
    },
    deleted_user_login => {
        throw => {
            code      => 403,
            message   => 'Forbidden',
            i18n_code => 'status.deleted_user_login'
        },
    },
    email_already_exist => {
        throw => {
            code      => 409,
            message   => 'Email Already exist',
            i18n_code => 'status.email_already_exist'
        },
    },
    bad_request => {
        throw => {
            code      => 400,
            message   => 'Bad Request Invalid method',
            i18n_code => 'status.bad_request'
        }
    },
    user_does_not_exist => {
        throw => {
            code      => 400,
            message   => 'User does not exists',
            i18n_code => 'status.user_does_not_exist'
        }
    },
    password_and_cnf_password_mismatch => {
        throw => {
            code      => 400,
            message   => 'Password and Confirm Password Mismatch',
            i18n_code => 'status.password_and_cnf_password_mismatch'
        }
    },
    password_update_success => {
        throw => {
            code      => 200,
            message   => 'Password updated successfully',
            i18n_code => 'status.password_update_success'
        }
    },
    lecture_already_scheduled => {
        throw => {
            code      => 200,
            message   => 'Skipping lecture_already scheduled',
            i18n_code => 'status.lecture_already_scheduled'
        }
    },
    lecture_success => {
        throw => {
            code      => 200,
            message   => 'Success lecture scheduled kindly Note the qr code and information for future reference',
            i18n_code => 'status.lecture_success'
        }
    },
    attendance_marked_or_invalid => {
        throw => {
            code      => 200,
            message   => 'Skipped/Error see information for issue',
            i18n_code => 'status.attendance_marked_or_invalid'
        }
    },
    mark_present_success => {
        throw => {
            code      => 200,
            message   => 'Success Marked present Note the id and information for future reference',
            i18n_code => 'status.mark_present_success'
        }
    },
);

1;

__END__
my %StatusCode = (
    100 => 'Continue',
    101 => 'Switching Protocols',
    102 => 'Processing',                      # RFC 2518: WebDAV
    103 => 'Early Hints',                     # RFC 8297: Indicating Hints
#   104 .. 199
    200 => 'OK',
    201 => 'Created',
    202 => 'Accepted',
    203 => 'Non-Authoritative Information',
    204 => 'No Content',
    205 => 'Reset Content',
    206 => 'Partial Content',                 # RFC 7233: Range Requests
    207 => 'Multi-Status',                    # RFC 4918: WebDAV
    208 => 'Already Reported',                # RFC 5842: WebDAV bindings
#   209 .. 225
    226 => 'IM used',                         # RFC 3229: Delta encoding
#   227 .. 299
    300 => 'Multiple Choices',
    301 => 'Moved Permanently',
    302 => 'Found',
    303 => 'See Other',
    304 => 'Not Modified',                    # RFC 7232: Conditional Request
    305 => 'Use Proxy',
    307 => 'Temporary Redirect',
    308 => 'Permanent Redirect',              # RFC 7528: Permanent Redirect
#   309 .. 399
    400 => 'Bad Request',
    401 => 'Unauthorized',                    # RFC 7235: Authentication
    402 => 'Payment Required',
    403 => 'Forbidden',
    404 => 'Not Found',
    405 => 'Method Not Allowed',
    406 => 'Not Acceptable',
    407 => 'Proxy Authentication Required',   # RFC 7235: Authentication
    408 => 'Request Timeout',
    409 => 'Conflict',
    410 => 'Gone',
    411 => 'Length Required',
    412 => 'Precondition Failed',             # RFC 7232: Conditional Request
    413 => 'Request Entity Too Large',
    414 => 'Request-URI Too Large',
    415 => 'Unsupported Media Type',
    416 => 'Request Range Not Satisfiable',   # RFC 7233: Range Requests
    417 => 'Expectation Failed',
#   418 .. 420
    421 => 'Misdirected Request',             # RFC 7540: HTTP/2
    422 => 'Unprocessable Entity',            # RFC 4918: WebDAV
    423 => 'Locked',                          # RFC 4918: WebDAV
    424 => 'Failed Dependency',               # RFC 4918: WebDAV
#   425
    426 => 'Upgrade Required',
#   427
    428 => 'Precondition Required',           # RFC 6585: Additional Codes
    429 => 'Too Many Requests',               # RFC 6585: Additional Codes
#   430
    431 => 'Request Header Fields Too Large', # RFC 6585: Additional Codes
#   432 .. 450
    451 => 'Unavailable For Legal Reasons',   # RFC 7724: Legal Obstacles
#   452 .. 499
    500 => 'Internal Server Error',
    501 => 'Not Implemented',
    502 => 'Bad Gateway',
    503 => 'Service Unavailable',
    504 => 'Gateway Timeout',
    505 => 'HTTP Version Not Supported',
    506 => 'Variant Also Negotiates',         # RFC 2295: Transparant Ngttn
    507 => 'Insufficient Storage',            # RFC 4918: WebDAV
    508 => 'Loop Detected',                   # RFC 5842: WebDAV bindings
#   509
    510 => 'Not Extended',                    # RFC 2774: Extension Framework
    511 => 'Network Authentication Required', # RFC 6585: Additional Codes
);