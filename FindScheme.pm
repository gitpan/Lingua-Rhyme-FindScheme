package Lingua::Rhyme::FindScheme;
use Lingua::Rhyme;

our $VERSION = 0.01;
our $chat = 0;

=head1 NAME

Lingua::Rhyme::FindScheme - find rhyme schemes in poetry

=head1 SYNOPSIS

	use Lingua::Rhyme::FindScheme;

	my @shakespeare_sonnet_ii =  (
		"When forty winters shall beseige thy brow,",
		"And dig deep trenches in thy beauty's field,",
		"Thy youth's proud livery, so gazed on now,",
		"Will be a tatter'd weed, of small worth held:",
		"Then being ask'd where all thy beauty lies,",
		"Where all the treasure of thy lusty days,",
		"To say, within thine own deep-sunken eyes,",
		"Were an all-eating shame and thriftless praise.",
		"How much more praise deserved thy beauty's use,",
		"If thou couldst answer 'This fair child of mine",
		"Shall sum my count and make my old excuse,'",
		"Proving his beauty by succession thine!",
		"  This were to be new made when thou art old,",
		"  And see thy blood warm when thou feel'st it cold."
	);

	my %scheme = %{Lingua::Rhyme::FindScheme::list_couplets (@shakespeare_sonnet_ii)};

	foreach (sort {$a <=> $b} keys %scheme){
		warn "Scheme $_ = $scheme{$_}\n";
	}

	__END__


=head1 DESCRIPTION

This is the first version of a module which will grow with my needs.

All requests/suggestions much appreciated.


=head1 PREREQUISITES

	Lingua::Rhyme


=head1 FUNCTIONS

=head2 &list_couplets

Accepts an array of text, and returns a reference to a hash where keys and values are numbers of couplets.
NB: the line number index begins at zero.

=cut

sub list_couplets { my @text = @_;
	my $check_text = '';
	my $done_text  = '';
	my $i;
	my %scheme;

	foreach my $line (@text){
		++$i;
		$line =~ m/([\w']+)[^\w]+$/;
		my $word = $1;
		my $j =0;
		foreach my $check_line (@text){
			++$j;
			next if $i == $j;
			$check_line =~ m/([\w']+)[^\w]+$/;
			my $check_word = $1;
			if ( Lingua::Rhyme::simplematch($word,$check_word) ){
				#warn "Lines $i and $j rhyme\n";
				#warn "Lookup Word >$word< matches check_word  >$check_word< ";
				#warn "\t$line\n\t$check_line\n\n";
				$scheme{$i} = $j unless exists $scheme{$j} and $scheme{$j} == $i;
			}
		}
	}

	return \%scheme;
}


1;
__END__

=head1 SEE ALSO

L<Lingua::Rhyme>;
perl(1).

=head1 COPYRIGHT

Copyright (C) Lee Goddard, 30/05/2001 ff.

This is free software, and can be used/modified under the same terms as Perl itself.

=cut
