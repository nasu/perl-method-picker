#!/usr/bin/env perl
use strict;
use Class::Inspector;
use Path::Class;
use Getopt::Long;
local $\ = "\n";

my $file = $ARGV[0];
require $file or die 'cannot require';
my $package = sub {
    my ($file) = @_;
    my $fh = file($file)->openr;
    while (my $l = <$fh>) {
        if ($l =~ /^\s*package\s+([^;]+);\s*$/) {
            $fh->close;
            return $1;
        }
    }
    $fh->close;
}->($file) or die 'not found package name';

my %MODE = +(
    public  => 0,
    private => 0,
    full    => 1,
);
GetOptions
    public  => \$MODE{public},
    private => \$MODE{private},
    full    => \$MODE{full},
;

for my $info (@{ Class::Inspector->methods($package, +{reverse %MODE}->{1}) }) {
    print $info;
}
