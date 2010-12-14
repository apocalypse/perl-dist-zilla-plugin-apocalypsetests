package Dist::Zilla::Plugin::ApocalypseTests;

# ABSTRACT: Creates the Test::Apocalypse testfile for Dist::Zilla

use Moose 1.03;

extends 'Dist::Zilla::Plugin::InlineFiles' => { -version => '2.101170' };
with 'Dist::Zilla::Role::FileMunger' => { -version => '2.101170' };

=attr allow

This option will be passed directly to L<Test::Apocalypse> to control which sub-tests you want to run.

The default is nothing.

=cut

has allow => (
	is => 'ro',
	isa => 'Str',
	predicate => '_has_allow',
);

=attr deny

This option will be passed directly to L<Test::Apocalypse> to control which sub-tests you want to run.

The default is nothing.

=cut

has deny => (
	is => 'ro',
	isa => 'Str',
	predicate => '_has_deny',
);

sub munge_file {
	my ($self, $file) = @_;

	return unless $file->name eq 't/apocalypse.t';

	# replace strings in the file
	my $content = $file->content;
	my( $allow, $deny );
	if ( $self->_has_allow ) {
		$allow = "allow => '" . $self->allow . "',\n";
	} else {
		$allow = '';
	}
	$content =~ s/ALLOW/$allow/;

	if ( $self->_has_deny ) {
		$deny = "deny => '" . $self->deny . "',\n";
	} else {
		$deny = '';
	}
	$content =~ s/DENY/$deny/;

	$file->content( $content );
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

=pod

=for Pod::Coverage munge_file

=for stopwords dist

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing
the following files:

=over 4

=item * t/apocalypse.t - Runs the dist through Test::Apocalypse

For more information on what the test does, please look at L<Test::Apocalypse>.

	# In your dist.ini:
	[ApocalypseTests]

=back

=head1 SEE ALSO
Dist::Zilla
Test::Apocalypse

=cut

__DATA__
___[ t/apocalypse.t ]___
#!perl
use strict; use warnings;

use Test::More;
eval "use Test::Apocalypse 0.10";
if ( $@ ) {
	plan skip_all => 'Test::Apocalypse required for validating the distribution';
} else {
	# hack for Kwalitee ( zany require format so DZP::AutoPrereq will not pick it up )
	require 'Test/NoWarnings.pm'; require 'Test/Pod.pm'; require 'Test/Pod/Coverage.pm';

	is_apocalypse_here( {
		ALLOWDENY
	} );
}
