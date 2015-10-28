#!perl
use strict;
use warnings;

use constant DAT_DIR => 'csv/';
use constant OUT_DIR  => 'idx/';

use Text::CSV;
my $csv = Text::CSV->new();

my @files;
{
  opendir (DAT, DAT_DIR) or die "can't open: ", DAT_DIR, ":$!";
    @files = map DAT_DIR. $_, grep /\.csv$/, readdir(DAT);
}

# generate wordlist
my %words;
my %twitter;
my %blogs;
my %news;

for (@files) {
    open (my $fh, '<', $_) or die "can't open: $_: $!";
    while (my $row = $csv->getline($fh)) {
	  $words{$_}++ for (@$row);
	  if (/twitter/) {
	     $twitter{$_}++ for (@$row);
	  }elsif (/news/) {
	     $news{$_}++ for (@$row);
	  }else{
	     $blogs{$_}++ for (@$row);
	  }
    }
    warn "finished: $_\n";
}

my @words = sort keys %words;

open (WLIST, '>', OUT_DIR . 'wordlist.txt') or die "can't generate wordlist.txt: $!";
print WLIST map "$_\n", @words;

open (BLOGS, '>', OUT_DIR .'blogs_wordlist.txt') or die "can't generate blogs_wordlist.txt: $!";
print BLOGS map "$_\n", sort keys %blogs;

open (TWITTER, '>', OUT_DIR .'twitter_wordlist.txt') or die "can't generate twitter_wordlist.txt: $!";
print TWITTER map "$_\n", sort keys %twitter;

open (NEWS, '>', OUT_DIR .'news_wordlist.txt') or die "can't generate news_wordlist.txt: $!";
print NEWS map "$_\n", sort keys %news;

