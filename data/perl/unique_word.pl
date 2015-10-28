#!/usr/bin/env perl
use strict;
use warnings;

my $f1 = 'en_US.news.txt';
my $f2 = 'en_US.twitter.txt';

my $f1_words = {};
my $f2_words = {};

open (F1, $f1) or die "can't open: $f1 :$!";
open (F2, $f2) or die "can't open: $f2 :$!";

while (<F1>) {
      for (words($_)) {
	  $f1_words->{$_}++;
      }
}

while (<F2>) {
      for (words($_)) {
	  $f2_words->{$_}++;
      }
}

for (sort {$f1_words->{$b} <=> $f1_words->{$a}} keys %$f1_words) {
    next if $f2_words->{$_};
    print "$f1 contains the word: $_ - ", $f1_words->{$_}, " times and $f2 doesn't have the word at all\n";
    last;
}

for (sort {$f2_words->{$b} <=> $f2_words->{$a}} keys %$f2_words) {
    next if $f1_words->{$_};
    print "$f2 contains the word: $_ - ", $f2_words->{$_}, " times and $f1 doesn't have the word at all\n";
    last;
}

exit;

sub words {
    my $line = shift;
       $line =~ s/[\cM\n\r]+//g;
       $line = lc($line);
       $line =~ s/\d+//g;
       $line =~ s/[^\w\s]+//g;
       $line =~ s/\s+/ /g;
       $line =~ s/^\s+//;
       $line =~ s/\s+$//;

split / /, $line
}
