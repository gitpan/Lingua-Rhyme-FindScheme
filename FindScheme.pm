package Lingua::Rhyme::FindScheme;
use Lingua::Rhyme;

our $VERSION = 0.02;
use warnings;
use strict;

=head1 NAME

Lingua::Rhyme::FindScheme - find rhyme schemes in text.

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

	my $i=0;
	foreach my $scheme ( Lingua::Rhyme::FindScheme::endings(@shakespeare_sonnet_ii) ){
		warn "Line ",$i+1," ... $scheme ... $shakespeare_sonnet_ii[$i]\n";
		++$i;
	}

	__END__


=head1 PREREQUISITES

	Lingua::Rhyme


=head1 DESCRIPTION

This is the first version of a module which will grow with my needs.

All requests/suggestions much appreciated.


=head1 FUNCTIONS

=head2 &list_couplets

Accepts an array of text, and returns a reference to a hash where keys and values are numbers of couplets.
NB: the line number index begins at zero.

=cut

sub list_couplets { my @text = @_;
	my $i = 0;
	my %scheme;

	foreach my $line (@text){
		++$i;
		$line =~ m/([\w']+)[^\w]+$/;
		my $word = $1;
		my $j = 0;
		foreach my $check_line (@text){
			++$j;
			next if $i == $j;
			$check_line =~ m/([\w']+)[^\w]+$/;
			my $check_word = $1;
			if ( Lingua::Rhyme::simplematch($word,$check_word) ){
				$scheme{$i} = $j unless exists $scheme{$j} and $scheme{$j} == $i;
			}
		}
	}

	return \%scheme;
}



=head1 &endings (@text)

Accepts an array of text, and scans it for a scheme of rhymes at line ends, returning an array of the scheme.

=cut

sub endings { my @text = @_;
	my $i = -1;
	my @scheme;						# return array
	my @schememap = ('A'..'Z');		# what to name rhymes
	my $schememapi = 0; 			# index to current pos in schememap

	LINE:
	foreach my $line (@text){
		++$i;
		next LINE if defined $scheme[$i];
		$line =~ m/([\w']+)[^\w]*$/;
		my $word = $1;
		my $j = -1;
		# Find all rhymes for $word in the text
		XCHECK:
		foreach my $check_line (@text){
			++$j;
			next XCHECK if $i == $j;
			next XCHECK if defined $scheme[$j];
			$check_line =~ m/([\w']+)[^\w]*$/;
			my $check_word = $1;
			if ( Lingua::Rhyme::matchall($word,$check_word) ){
				$scheme[$i] = $schememap[$schememapi];
				$scheme[$j] = $scheme[$i];
			}
		}
		# Didn't find a rhyme
		$scheme[$i] = $schememap[$schememapi] if not defined $scheme[$i];
		$schememapi++;
	}

	return @scheme;
}



1;
__END__

=head1 SEE ALSO

L<Lingua::Rhyme>;
perl(1).

=head1 AUTHOR

Lee Goddard <lgoddard@cpan.org>

=head1 COPYRIGHT

Copyright (C) Lee Goddard, 30/05/2001 ff.

This is free software, and can be used/modified under the same terms as Perl itself.

=cut
