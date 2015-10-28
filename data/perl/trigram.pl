#!/usr/bin/env perl
use strict;
use warnings;

# TRIGRAM - given three words most popular next word

# QUADGRAM HASH with four words and counts
# convert back to TRIGRAM array with highest counts

use constant TEST => 0; # set to one to test
use constant FILES => qw/blogs news twitter/;

use lib 'lib';
use BadWords;

my $bw = BadWords->new();

for my $file (&FILES) {
    my %quadgram;

    open (D, '<', 'en_US.'.$file.'.txt') or die "can't create: en_US.$file.txt: $!";

    my $output_file = 'csv/'.$file.'_trigram' . (TEST ? '.tst' : '.csv');

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
	       while ($line[3]) {
		     my $base = join '::', @line[0..2]; # base is a unique combo
		     $quadgram{$base}->{$line[3]}++;
		     warn "$base -> $line[3]" if TEST;
		     shift(@line);
	       }
	       warn "line: $.\n" unless $. % 1000;
	       last if TEST && $. > $tc;
         }

	 # convert back to trigram
	 my %trigram;
	 #   XXX: I want to choose the most prevelant word in cases of a tie (load word count?)
	 for my $base (keys %quadgram) {
	     my $suggest;
	     my $count = 0;
	     for (keys %{$quadgram{$base}}) {
		 next unless $quadgram{$base}->{$_} > $count;
		 $count = $quadgram{$base}->{$_};
		 $suggest = $_;
	     }
	     $trigram{$base .'::'. $suggest} = $count;
         }

	 for (sort {$trigram{$a} <=> $trigram{$b}} keys %trigram) {
	     next if $trigram{$_} < 2;
	     # print W join ',', split(/::/, $_), $trigram{$_}, "\n";
	     print W join(',', split(/::/, $_)), "\n";
	 }
}
