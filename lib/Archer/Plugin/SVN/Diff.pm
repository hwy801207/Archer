package Archer::Plugin::SVN::Diff;

use strict;
use warnings;
use base qw( Archer::Plugin::SVN );
use SVN::Agent;

sub run {
    my ($self, $context, $args) = @_;

    $ENV{LANG} = 'C';

    my $path = $self->{config}->{path}
        || File::Spec->catfile($context->{config}->{global}->{work_dir}, $context->{project});
    $path = $self->templatize($path);

    my $rev = `svn info $path`;
    $rev = $1 if $rev =~ /Revision: (\d+)/;

    my $svn = SVN::Agent->load({ path => $path });
    print eval { $svn->diff("-r$rev:HEAD") };
}

1;
__END__

=head1 NAME

Archer::Plugin::SVN::Diff - svn diff

=head1 SYNOPSIS

  - module: SVN::Diff
    config:
      path: "[% work_dir %]/[% project %]"

=head1 DESCRIPTION

Execute svn diff.

=head1 CONFIG

=head2 path

Svn working directory path.Default is [% work_dir %]/[% project %].

=head1 AUTHORS

Gosuke Miyashita

=head1 SEE ALSO

L<SVN::Agent>

=cut
