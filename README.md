# NAME

Ark::View::DataTable - Ark View for Data::Google::Visualization::DataTable

# SYNOPSIS

    use Ark 'Controller';
    use Ark::View::DataTable;
    use Data::Google::Visualization::DataTable;
    sub gvis :Local {
        my ($self, $c) = @_;

        # Create new DataTable
        my $datatable = Data::Google::Visualization::DataTable->new();
        $datatable->add_columns(
            { id => 'x',   label => "X", type => 'number' },
            { id => 'y',   label => "Y", type => 'number' },
        );
        $datatable->add_rows(
            map { [$_, sin(2*3.1415926535*$_/500)] } 1..1000,
        );

        # Render DataTable using Ark::View::DataTable
        $c->stash->{table} = $datatable;
        $c->forward( $c->view( 'DataTable' ) );
    }

# DESCRIPTION

Ark::View::DataTable is an Ark View for Data::Google::Visualization::DataTable.
It supports Chart Tools Datasource Protocol (V0.6).

# SEE ALSO

- [Data::Google::Visualization::DataTable](https://metacpan.org/pod/Data::Google::Visualization::DataTable)
- [Chart Tools Datasource Protocol](https://developers.google.com/chart/interactive/docs/dev/implementing\_data\_source)

# LICENSE

Copyright (C) Ichinose Shogo.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Ichinose Shogo <shogo82148@gmail.com>
