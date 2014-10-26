package Web::Machine::Util::BodyEncoding;
# ABSTRACT: Module to handle body encoding

use strict;
use warnings;

use Web::Machine::Util qw[ first pair_key ];

use Sub::Exporter -setup => {
    exports => [qw[
        encode_body_if_set
        encode_body
    ]]
};

sub encode_body_if_set {
    my ($resource, $response, $metadata) = @_;
    encode_body( $resource, $response, $metadata ) if $response->body;
}

sub encode_body {
    my ($resource, $response, $metadata) = @_;

    my $chosen_encoding = $metadata->{'Content-Encoding'};
    my $encoder         = $resource->encodings_provided->{ $chosen_encoding };

    my $chosen_charset  = $metadata->{'Charset'};
    my $charsetter      = $resource->charsets_provided
                        && (first { $_ && $chosen_charset && pair_key( $_ ) eq $chosen_charset } @{ $resource->charsets_provided })
                        || sub { $_[1] };
    # TODO:
    # Make this support the other
    # body types that Plack supports
    # (arrays, code refs, etc).
    # - SL
    $response->body([
        $resource->$encoder(
            $resource->$charsetter(
                $response->body
            )
        )
    ]);

    $response->header( 'Content-Length' => length join "" => @{ $response->body } );
}


1;



=pod

=head1 NAME

Web::Machine::Util::BodyEncoding - Module to handle body encoding

=head1 VERSION

version 0.01

=head1 SYNOPSIS

  use Web::Machine::Util::BodyEncoding;

=head1 DESCRIPTION

This handles the body encoding.

=head1 FUNCTIONS

=over 4

=item C<encode_body_if_set ( $resource, $response, $metadata )>

If the C<$response> has a body, this will call C<encode_body>.

=item C<encode_body ( $resource, $response, $metadata )>

This will find the right encoding (from the 'Content-Encoding' entry
in the C<$metadata> HASH ref) adnd the right charset (from the 'Charset'
entry in the C<$metadata> HASH ref), then find the right transformers
in the C<$resource>. After that it will attempt to convert the charset
and encode the body of the C<$response>. Once completed it will set
the C<Content-Length> header in the response as well.

B<NOTE:> At the moment we do not correctly handle all the various
body types that L<Plack> supports, and we really on handle the case
where the body is a simple string. We plan to add more support onto this
later.

=back

=head1 AUTHOR

Stevan Little <stevan.little@iinteractive.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

