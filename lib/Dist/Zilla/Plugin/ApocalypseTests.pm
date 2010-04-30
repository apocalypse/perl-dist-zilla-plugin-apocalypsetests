package Dist::Zilla::Plugin::ApocalypseTests;
use strict; use warnings;
our $VERSION = '0.01';

use Moose;
extends	'Dist::Zilla::Plugin::InlineFiles';
with	'Dist::Zilla::Role::FileMunger';

# -- attributes

has allow => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_allow',
);

has deny => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_deny',
);

# -- public methods

# called by the filemunger role
sub munge_file {
	my ($self, $file) = @_;

	return unless $file->name eq 't/apocalypse.t';

	# replace strings in the file
	my $content = $file->content;
	my( $allow, $deny );
	if ( $self->has_allow ) {
		$allow = "allow => '" . $self->allow . "',\n";
	} else {
		$allow = '';
	}
	$content =~ s/ALLOW/$allow/;

	if ( $self->has_deny ) {
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

=head1 NAME

Dist::Zilla::Plugin::ApocalypseTests - Creates the Test::Apocalypse testfile for Dist::Zilla

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing
the following files:

=over 4

=item * t/apocalypse.t - Runs the dist through Test::Apocalypse

For more information on what the test does, please look at L<Test::Apocalypse>.

	# In your dist.ini:
	[ApocalypseTests]

=back

This plugin accepts the following options:

=over 4

=item * allow

This option will be passed directly to L<Test::Apocalypse> to control which sub-tests you want to run.

=item * deny

This option will be passed directly to L<Test::Apocalypse> to control which sub-tests you want to run.

=back

=head1 SEE ALSO

L<Dist::Zilla>

L<Test::Apocalypse>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc Dist::Zilla::Plugin::ApocalypseTests

=head2 Websites

=over 4

=item * Search CPAN

L<http://search.cpan.org/dist/Dist-Zilla-Plugin-ApocalypseTests>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dist-Zilla-Plugin-ApocalypseTests>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Dist-Zilla-Plugin-ApocalypseTests>

=item * CPAN Forum

L<http://cpanforum.com/dist/Dist-Zilla-Plugin-ApocalypseTests>

=item * RT: CPAN's Request Tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dist-Zilla-Plugin-ApocalypseTests>

=item * CPANTS Kwalitee

L<http://cpants.perl.org/dist/overview/Dist-Zilla-Plugin-ApocalypseTests>

=item * CPAN Testers Results

L<http://cpantesters.org/distro/D/Dist-Zilla-Plugin-ApocalypseTests.html>

=item * CPAN Testers Matrix

L<http://matrix.cpantesters.org/?dist=Dist-Zilla-Plugin-ApocalypseTests>

=item * Git Source Code Repository

L<http://github.com/apocalypse/perl-dist-zilla-plugin-apocalypsetests>

=back

=head2 Bugs

Please report any bugs or feature requests to C<bug-dist-zilla-plugin-apocalypsetests at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dist-Zilla-Plugin-ApocalypseTests>.  I will be
notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

Props goes out to JQUELIN for writing the L<Dist::Zilla::Plugin::CompileTests> which was the base for this module.

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included with this module.

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
