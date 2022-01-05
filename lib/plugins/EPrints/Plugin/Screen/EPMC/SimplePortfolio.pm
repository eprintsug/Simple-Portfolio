package EPrints::Plugin::Screen::EPMC::SimplePortfolio;

@ISA = ( 'EPrints::Plugin::Screen::EPMC' );

use strict;
# Make the plug-in
sub new
{
    my( $class, %params ) = @_;

    my $self = $class->SUPER::new( %params );

    $self->{actions} = [qw( enable disable )];
    $self->{disable} = 0; # always enabled, even in lib/plugins

    $self->{package_name} = 'simple_portfolio';

    return $self;
}

=item $screen->action_enable( [ SKIP_RELOAD ] )

Enable the L<EPrints::DataObj::EPM> for the current repository.

If SKIP_RELOAD is true will not reload the repository configuration.

=cut

sub action_enable
{
    my( $self, $skip_reload ) = @_;

    $self->SUPER::action_enable( $skip_reload );
    my $repo = $self->{repository};

    # Add new EPrint type
    my $namedset = EPrints::NamedSet->new( "eprint",
        repository => $repo
    );
    $namedset->add_option( "portfolio", $self->{package_name} );

    # Update the deposit workflow with a new stage
    my $filename = $repo->config( "config_path" )."/workflows/eprint/default.xml";
    my $insert = EPrints::XML::parse_xml( $repo->config( "lib_path" )."/workflows/eprint/simple_portfolio.xml" );
    EPrints::XML::add_to_xml( $filename, $insert->documentElement(), $self->{package_name} );

    $self->reload_config if !$skip_reload;
}

=item $screen->action_disable( [ SKIP_RELOAD ] )

Disable the L<EPrints::DataObj::EPM> for the current repository.

If SKIP_RELOAD is true will not reload the repository configuration.

=cut

sub action_disable
{
    my( $self, $skip_reload ) = @_;

    $self->SUPER::action_disable( $skip_reload );
    my $repo = $self->{repository};

    # Remove new EPrint type
    my $namedset = EPrints::NamedSet->new( "eprint",
        repository => $repo
    );

    $namedset->remove_option( "portfolio", $self->{package_name} );
   
    my $filename = $repo->config( "config_path" )."/workflows/eprint/default.xml";
    EPrints::XML::remove_package_from_xml( $filename, $self->{package_name} );

    $self->reload_config if !$skip_reload;
}
