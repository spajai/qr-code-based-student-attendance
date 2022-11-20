use strict;
use warnings;

use QRAttendance;

my $app = QRAttendance->apply_default_middlewares(QRAttendance->psgi_app);
$app;

