push @{$c->{fields}->{eprint}},
{
    name => 'repository_records',
    type => 'itemref',
    datasetid => 'archive',
    multiple => 1,
    render_value => 'render_repository_records',
},
