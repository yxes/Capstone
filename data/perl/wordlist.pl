#!/usr/bin/env perl
use strict;
use warnings;

use constant FILES => qw/blogs news twitter/;

for my $file (&FILES) {
    my %words;
    open (D, '<', 'csv/'.$file.'_unigram.csv') or die "can't read: csv/$file","_unigram.csv: $!";
    open (W, '>', 'csv/'. $file. '_wordlist.csv') or die "can't create: csv/$file", "_wordlist.csv: $!";
       $words{$_}++ for (map {chomp; split /,/} <D>);
       for (sort keys %words) {
	   print W "$_\n";
       }
}
