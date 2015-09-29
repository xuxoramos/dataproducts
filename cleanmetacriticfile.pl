use strict;
use warnings;
     
use Path::Tiny qw(path);
     
my $filename = 'metacriticdata-ps3.txt';
     
my $file = path($filename);
     
my $data = $file->slurp_utf8;

$data =~ s/^[0-9]*\.$//g;

$file->spew_utf8( $data );