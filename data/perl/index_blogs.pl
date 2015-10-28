#!perl
use strict;
use warnings;

use constant DAT_DIR => 'csv/';
use constant OUT_DIR  => 'idx/';

use Text::CSV;
my $csv = Text::CSV->new();

my %words;
{
  open (WRDS, '<', OUT_DIR . 'blogs_wordlist.txt') or die "can't read: ", OUT_DIR, "blogs_wordlist.txt: $!";
  while (<WRDS>) {
	chomp;
	$words{$_} = $.;
  }
}

my @files;
{
  opendir (DAT, DAT_DIR) or die "can't open: ", DAT_DIR, ":$!";
    @files = grep /\.csv$/, grep !/wordlist/, grep /blogs/, readdir(DAT);
}

for (@files) {
    warn "file: ", $_;
    open (my $in, '<', DAT_DIR . $_) or die "can't open: ", DAT_DIR, "$_: $!";
    open (my $out, '>', OUT_DIR. $_) or die "can't create: ", OUT_DIR, "$_: $!";

    my @lines;
    while (my $row = $csv->getline($in)) {
	  my @entries = map $words{$_}, @$row;
	  push (@lines, join (",", @entries), "\n");
    }

    print $out reverse @lines;
    warn "finished: $_\n";
}
