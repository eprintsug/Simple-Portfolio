# Add the new field
push @{$c->{fields}->{eprint}},
{
    name => 'repository_records',
    type => 'itemref',
    datasetid => 'archive',
    multiple => 1,
    render_value => 'render_repository_records',
};

# The items which display the portfolio deposit workflow stage
$c->{portfolio}->{item_types} = ['portfolio'];

# Renderer for the portfolio field - displays each item in a bullet point list
$c->{render_repository_records} = sub
{
    my( $session, $field, $value ) = @_;

    my $dataset = $session->dataset( "eprint" );

    my $ul = $session->make_element( "ul", class => "repository_records_citations" );
    foreach my $id ( @{$value} )
    {
        my $li = $session->make_element( "li" );

        my $eprint = $dataset->dataobj( $id );
        $li->appendChild( $eprint->render_citation_link );

        $ul->appendChild( $li );
    }
    return $ul;
};
