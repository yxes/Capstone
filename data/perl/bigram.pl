#!/usr/bin/env perl
use strict;
use warnings;

# BIGRAM - given two words most popular next word

# TRIGRAM HASH with three words and counts
# convert back to BIGRAM array with highest counts

use constant TEST => 0; # set to one to test
use constant FILES => qw/blogs news twitter/;

use lib 'lib';
use BadWords;

my $bw = BadWords->new();

for my $file (&FILES) {
    my %trigram;

    open (D, '<', 'en_US.'.$file.'.txt') or die "can't create: en_US.$file.txt: $!";

    my $output_file = 'csv/'.$file.'_bigram' . (TEST ? '.tst' : '.csv');

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
	       while ($line[2]) {
		     my $base = join '::', @line[0..1]; # base is a unique combo
		     $trigram{$base}->{$line[2]}++;
		     warn "$base -> $line[2]" if TEST;
		     shift(@line);
	       }
	       warn "line: $.\n" unless $. % 1000;
	       last if TEST && $. > $tc;
         }

	 # convert back to bigram
	 my %bigram;
	 #   XXX: I want to choose the most prevelant word in cases of a tie (load word count?)
	 for my $base (keys %trigram) {
	     my $suggest;
	     my $count = 0;
	     for (keys %{$trigram{$base}}) {
		 next unless $trigram{$base}->{$_} > $count;
		 $count = $trigram{$base}->{$_};
		 $suggest = $_;
	     }
	     $bigram{$base .'::'. $suggest} = $count;
         }

	 for (sort {$bigram{$a} <=> $bigram{$b}} keys %bigram) {
	     next if $bigram{$_} < 2;
	     #print W join ',', split(/::/, $_), $bigram{$_}, "\n";
	     print W join(',', split(/::/, $_)), "\n";
	 }
}
