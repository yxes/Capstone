#!/usr/bin/env perl
use strict;
use warnings;

# UNIGRAM - given one word most popular next word

# BIGRAM HASH with two words and counts
# convert back to UNIGRAM array with highest counts

use constant TEST => 0; # set to one to test
#use constant FILES => qw/blogs news twitter/;
use constant FILES => qw/blogs twitter/;

use lib 'lib';
use BadWords;

my $bw = BadWords->new();

for my $file (&FILES) {
    my %bigram;

    open (D, '<', 'en_US.'.$file.'.txt') or die "can't create: en_US.$file.txt: $!";

    my $output_file = 'csv/'.$file.'_unigram' . (TEST ? '.tst' : '.csv');

    open (W, '>', $output_file) or die "can't create: $output_file: $!";

         my $tc = 1000; # only go through this many lines - only for testing
         while (<D>) {
               chomp;
               s/[\cM\n\r]+//g;
               my $line = lc($_);
	          $line =~ s/\d+//g;
                  if ($file eq 'twitter') {
                     $line =~ s/[^\w\s'#]+//g;
                     $line =~ s/##+/#/g;
                     $line =~ s/[^\b]#//g;
                     $line =~ s/#\W//g;
                  }else{
                     $line =~ s/[^\w\s']+//g;
                  }
                  $line =~ s/''+/'/g;
                  $line =~ s/\s'\s/ /g;
                  $line =~ s/_//g;
                  $line =~ s/\s+/ /g;
                  $line =~ s/^\s+//;
                  $line =~ s/\s+$//;

		  $bw->rm(\$line);

                  $line =~ s/\s+/ /g;
                  $line =~ s/^\s+//;
                  $line =~ s/\s+$//;

	       my @line = split / /, $line;
	       while ($line[1]) {
		     $bigram{$line[0]}->{$line[1]}++;
		     warn "$line[0] -> $line[1]" if TEST;
		     shift(@line);
	       }
	       warn "line: $.\n" unless $. % 1000;
	       last if TEST && $. > $tc;
         }

	 # convert back to unigram
	 my %unigram;
	 #   XXX: I want to choose the most prevelant word in cases of a tie (load word count?)
	 for my $base (keys %bigram) {
	     my $suggest;
	     my $count = 0;
	     for (keys %{$bigram{$base}}) {
		 next unless $bigram{$base}->{$_} > $count;
		 $count = $bigram{$base}->{$_};
		 $suggest = $_;
	     }
	     $unigram{$base .'::'.$suggest} = $count;
         }

	 for (sort {$unigram{$a} <=> $unigram{$b}} keys %unigram) {
	     #print W join ',', split(/::/, $_), $unigram{$_}, "\n";
	     print W join(',', split(/::/, $_)), "\n";
	 }
}
