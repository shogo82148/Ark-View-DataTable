package Ark::View::DataTable;
use 5.008005;
use strict;
use warnings;
use Ark 'View';
use JSON;
our $VERSION = "0.01";

has json_driver => (
    is      => 'rw',
    isa     => 'Object',
    lazy    => 1,
    default => sub {
        my $self = shift;
        JSON->new->utf8->allow_nonref;
    },
);

has 'responseHandler' => (
    is => 'rw',
    isa => 'Str',
    default => 'google.visualization.Query.setResponse'
);

sub process {
    my ($self, $c) = @_;
    my $tqx = { map { split /:/, $_, 2} split /;/, $c->request->param('tqx') };
    my $out = $tqx->{out} || 'json';

    if($out eq 'json') {
        $self->_process_json($c, $tqx);
    } elsif($out eq 'html') {
        $self->_process_html($c, $tqx);
    } elsif($out eq 'csv') {
        $self->_process_csv($c, $tqx);
    } elsif($out eq 'tsv-excel') {
        $self->_process_tsv_excel($c, $tqx);
    } else {
        die 'unsupported out type: ' . $out;
    }
}

sub _process_json {
    my ($self, $c, $tqx) = @_;
    my $_placeholder = 'hfaeghoucyrhksfhladsoijdsflkahu2u9';
    my $payload = $self->_render_json($c, $tqx);
    my $table;

    if($payload->{table}) {
        $table = $payload->{table};
        $payload->{table} = $_placeholder;
    }
    my $data = $self->json_driver->encode($payload);
    if($table) {
        $data =~ s/"$_placeholder"/$table/;
    }

    my $responseHandler = $tqx->{responseHandler} || $self->responseHandler;
    $data = sprintf('%s(%s);', $responseHandler, $data);
    $c->response->content_type('text/javascript');
    $c->response->body( $data );
}

sub _render_json {
    my ($self, $c, $tqx) = @_;
    my $payload = {};
    $payload->{reqId} = $tqx->{reqId} if exists $tqx->{reqId};
    if($c->stash->{errors}) {
        $payload->{status} = 'error';
        $payload->{errors} = $c->stash->{errors};
        return $payload;
    } elsif($c->stash->{warnings}) {
        $payload->{status} = 'warning';
        $payload->{warnings} = $c->stash->{warnings};
    } else {
        $payload->{status} = 'ok';
    }
    $payload->{table} = $c->stash->{table}->output_javascript;
    return $payload;
}

sub _process_html {
    my ($self, $c, $tqx) = @_;
}

sub _process_csv {
    my ($self, $c, $tqx) = @_;
}

sub _process_tsv_excel {
    my ($self, $c, $tqx) = @_;
}

__PACKAGE__->meta->make_immutable;;

__END__

=encoding utf-8

=head1 NAME

Ark::View::DataTable - It's new $module

=head1 SYNOPSIS

    use Ark::View::DataTable;

=head1 DESCRIPTION

Ark::View::DataTable is ...

=head1 LICENSE

Copyright (C) Ichinose Shogo.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Ichinose Shogo E<lt>shogo82148@gmail.comE<gt>

=cut

