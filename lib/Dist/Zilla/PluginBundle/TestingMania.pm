package Dist::Zilla::PluginBundle::TestingMania;
# ABSTRACT: test your dist with every testing plugin conceivable
use strict;
use warnings;
use 5.010001; # We use the smart match operator
# VERSION

use Dist::Zilla::Plugin::Test::CPAN::Changes    qw();
use Dist::Zilla::Plugin::CompileTests           qw();
use Dist::Zilla::Plugin::ConsistentVersionTest  qw();
use Dist::Zilla::Plugin::CriticTests            qw();
use Dist::Zilla::Plugin::DistManifestTests      qw();
use Dist::Zilla::Plugin::EOLTests               qw();
use Dist::Zilla::Plugin::HasVersionTests        qw();
use Dist::Zilla::Plugin::KwaliteeTests          qw();
use Dist::Zilla::Plugin::MetaTests              qw();
use Dist::Zilla::Plugin::MinimumVersionTests    qw();
use Dist::Zilla::Plugin::NoTabsTests            qw();
use Dist::Zilla::Plugin::PodCoverageTests       qw();
use Dist::Zilla::Plugin::PodSyntaxTests         qw();
use Dist::Zilla::Plugin::PortabilityTests       qw();
use Dist::Zilla::Plugin::SynopsisTests          qw();
use Dist::Zilla::Plugin::UnusedVarsTests        qw();
use Dist::Zilla::Plugin::Test::Pod::LinkCheck   qw();
use Dist::Zilla::Plugin::Test::CPAN::Meta::JSON qw();

=head1 DESCRIPTION

This plugin bundle collects all the testing plugins for L<Dist::Zilla> which
exist (and are not deprecated). This is for the most paranoid people who
want to test their dist seven ways to Sunday.

Simply add the following near the end of F<dist.ini>:

    [@TestingMania]

It includes the most recent version (as of release time) of the following
plugins, in their default configuration. Note that not all the plugins
are actually I<used> by default.

=head2 Testing plugins

=over 4

=item *

L<Dist::Zilla::Plugin::CompileTests>, which performs tests to syntax check your
dist.

=item *

L<Dist::Zilla::Plugin::ConsistentVersionTest>, which tests that all modules in
the dist have the same version. See L<Test::ConsistentVersion> for details. This
is not enabled by default; see L</"Adding Tests">.

=item *

L<Dist::Zilla::Plugin::CriticTests>, which checks your code against best practices.
See L<Perl::Critic> for details.

=item *

L<Dist::Zilla::Plugin::DistManifestTests>, which tests F<MANIFEST> for correctness.
See L<Test::DistManifest> for details.

=item *

L<Dist::Zilla::Plugin::EOLTests>, which ensures the correct line endings are used
(and also checks for trailing whitespace). See L<Test::EOL> for details.

=item *

L<Dist::Zilla::Plugin::HasVersionTests>, which tests that your dist has version
numbers. See L<Test::HasVersion> for what that means.

=item *

L<Dist::Zilla::Plugin::KwaliteeTests>, which performs some basic kwalitee checks.
I<Kwalitee> is an automatically-measurable guage of how good your software is. It
bears only a B<superficial> resemblance to the human-measurable guage of actual
quality. See L<Test::Kwalitee> for a description of the tests.

=item *

L<Dist::Zilla::Plugin::MetaTests>, which performs some extra tests on F<META.yml>.
See L<Test::CPAN::Meta> for what that means.

=item *

L<Dist::Zilla::Plugin::Test::CPAN::Meta::JSON>, which performs some extra tests
on F<META.json>, if it exists. See L<Test::CPAN::Meta::JSON> for what that means.

=item *

L<Dist::Zilla::Plugin::MinimumVersionTests>, which tests for the minimum required
version of perl. See L<Test::MinimumVersion> for details, including limitations.

=item *

L<Dist::Zilla::Plugin::NoTabsTests>, which ensures you don't use I<The Evil Character>.
See L<Test::NoTabs> for details. If you wish to exclude this plugin, see L</"Excluding Tests">.

=item *

L<Dist::Zilla::Plugin::PodCoverageTests>, which checks that you have Pod
documentation for the things you should have it for. See L<Test::Pod::Coverage>
for what that means.

=begin hide

=item *

L<Dist::Zilla::Plugin::PodLinkTests>, which tests links in your Pod for invalid
links, or links which return a 404 (Not Found) error when you release your
dist. Note that smokers won't check for 404s to save hammering the network.
See L<Test::Pod::LinkCheck> and L<Test::Pod::No404s> for details.

=end hide

=item *

L<Dist::Zilla::Plugin::PodSyntaxTests>, which checks that your Pod is well-formed.
See L<Test::Pod> and L<perlpod> for details.

=item *

L<Dist::Zilla::Plugin::PortabilityTests>, which performs some basic tests to
ensure portability of file names. See L<Test::Portability::Files> for what
that means.

=item *

L<Dist::Zilla::Plugin::SynopsisTests>, which does syntax checking on the code
from your SYNOPSIS section. See L<Test::Synopsis> for details and limitations.

=item *

L<Dist::Zilla::Plugin::UnusedVarsTests>, which checks your dist for unused
variables. See L<Test::Vars> for details.

=item *

L<Dist::Zilla::Plugin::Test::CPAN::Changes>, which checks your changelog for
conformance with L<CPAN::Changes::Spec>. See L<Test::CPAN::Changes> for details.

Set C<changelog> in F<dist.ini> if you don't use F<Changes>:

    [@TestingMania]
    changelog = CHANGELOG

=back

=head2 Excluding Tests

To exclude a testing plugin, give a comma-separated list in F<dist.ini>:

    [@TestingMania]
    skip = EOLTests,NoTabsTests

=head2 Adding Tests

This pluginbundle may have prerequisites for some testing plugins that aren't
enabled by default. This option allows you to turn them on. Attempting to add
plugins which are not listed above will have I<no effect>.

To enable a testing plugin, give a comma-separated list in F<dist.ini>:

    [@TestingMania]
    add = ApacheTest,PodSpellingTests

Currently there are no plugins which aren't enabled by default.

=cut

use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy';

sub configure {
    my $self = shift;

    my %plugins = (
        'Test::CPAN::Changes'   => { changelog => ($self->payload->{changelog} || 'Changes') },
        'Test::CPAN::Meta::JSON'=> 1,
        'Test::Pod::LinkCheck'  => 1,
        CompileTests            => 1,
        ConsistentVersionTest   => 1,
        CriticTests             => 1,
        DistManifestTests       => 1,
        EOLTests                => 1,
        HasVersionTests         => 1,
        KwaliteeTests           => 1,
        MetaTests               => 1,
        MinimumVersionTests     => 1,
        NoTabsTests             => 1,
        PodCoverageTests        => 1,
        PodSyntaxTests          => 1,
        PortabilityTests        => 1,
        SynopsisTests           => 1,
        UnusedVarsTests         => 1,
    );
    my @include = ();

    my @skip = $self->payload->{skip} ? split(/, ?/, $self->payload->{skip}) : ();
    SKIP: foreach my $plugin (keys %plugins) {
        next SKIP if (              # Skip...
            $plugin ~~ @skip or     # plugins they asked to skip
            $plugin ~~ @include or  # plugins we already included
            !$plugins{$plugin}      # plugins in the list, but which we don't want to add
        );
        push(@include, ref $plugins{$plugin}
            ? [ $plugin => $plugins{$plugin} ]
            : $plugin);
    }

    my @add = $self->payload->{add} ? split(/, ?/, $self->payload->{add}) : ();
    ADD: foreach my $plugin (@add) {
        next ADD unless $plugin ~~ %plugins; # Skip the plugin unless it is in the list of actual testing plugins
        push(@include, $plugin) unless ($plugin ~~ @include or $plugin ~~ @skip);
    }

    $self->add_plugins(@include);
}

__PACKAGE__->meta->make_immutable();

no Moose;

=for Pod::Coverage configure
