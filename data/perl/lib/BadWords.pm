package BadWords;

use Moose;
use namespace::autoclean;

has 'bad_file' => (is => 'rw', isa => 'Str', default => sub { 'badwords.txt' });

has 'words' => ( is => 'rw', isa => 'ArrayRef', lazy => 1, builder => '_build_words' );

sub _build_words {
    my $self = shift;
    open (WORDS, '<', $self->bad_file) or die "can't open, ", $self->bad_file, ": $!";
    chomp(my @words = <WORDS>);
\@words
}

sub rm {
    my $self = shift;
    my $line = shift;

    $$line =~ s/\b\w*fuck\w*\b/ /g;
    for (@{$self->words}) {
	$$line =~ s/^$_\s//;
	$$line =~ s/\s$_$//g;
	$$line =~ s/^$_$//;
	$$line =~ s/\s$_\s/ /g;
     }
}

1;
