package Web::Machine::Util::BodyEncoding;
BEGIN {
  $Web::Machine::Util::BodyEncoding::AUTHORITY = 'cpan:STEVAN';
}
# ABSTRACT: Module to handle body encoding
$Web::Machine::Util::BodyEncoding::VERSION = '0.15';
use strict;
use warnings;

use Scalar::Util qw/ weaken isweak /;
use Encode ();
use Web::Machine::Util qw[ first pair_key pair_value ];

use Sub::Exporter -setup => {
    exports => [qw[
        encode_body_if_set
        encode_body
    ]]
};

sub encode_body_if_set {
    my ($resource, $response) = @_;
    encode_body( $resource, $response ) if $response->body;
}

sub encode_body {
    my ($resource, $response) = @_;

    my $metadata        = $resource->request->env->{'web.machine.context'};
    my $chosen_encoding = $metadata->{'Content-Encoding'};
    my $encoder         = $resource->encodings_provided->{ $chosen_encoding };

    my $chosen_charset = $metadata->{'Charset'};
    my $charsetter;
    if ( $chosen_charset && $resource->charsets_provided ) {
        my $match =             first {
                my $name = $_ && ref $_ ? pair_key($_) : $_;
                $name && $name eq $chosen_charset;
            }
            @{ $resource->charsets_provided };

        $charsetter
            = ref $match
            ? pair_value($match)
            : sub { Encode::encode( $match, $_[1] ) };
    }

    $charsetter ||= sub { $_[1] };

    push @{ $resource->request->env->{'web.machine.content_filters'} ||= [] },
        sub {
            my $chunk = shift;
            weaken $resource unless isweak $resource;
            return unless defined $chunk;
            return $resource->$encoder($resource->$charsetter($chunk));
        };
}


1;

__END__

=pod

=head1 NAME

Web::Machine::Util::BodyEncoding - Module to handle body encoding

=head1 VERSION

version 0.15

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
in the C<$metadata> HASH ref) and the right charset (from the 'Charset'
entry in the C<$metadata> HASH ref), then find the right transformers
in the C<$resource>. After that it will attempt to convert the charset
and encode the body of the C<$response>. Once completed it will set
the C<Content-Length> header in the response as well.

B<CAVEAT:> Note that currently this subroutine doesn't do anything when the
body is returned as a CODE ref. This is a bug to be remedied in the future.

=back

=head1 AUTHOR

Stevan Little <stevan.little@iinteractive.com>

=head1 CONTRIBUTORS

=over 4

=item *

Andreas Marienborg <andreas.marienborg@gmail.com>

=item *

Andrew Nelson <anelson@cpan.org>

=item *

Arthur Axel 'fREW' Schmidt <frioux@gmail.com>

=item *

Carlos Fernando Avila Gratz <cafe@q1software.com>

=item *

Dave Rolsky <autarch@urth.org>

=item *

Fayland Lam <fayland@gmail.com>

=item *

George Hartzell <hartzell@alerce.com>

=item *

Gregory Oschwald <goschwald@maxmind.com>

=item *

Jesse Luehrs <doy@tozt.net>

=item *

John SJ Anderson <genehack@genehack.org>

=item *

Mike Raynham <enquiries@mikeraynham.co.uk>

=item *

Mike Raynham <mike.raynham@spareroom.co.uk>

=item *

Olaf Alders <olaf@wundersolutions.com>

=item *

Thomas Sibley <tsibley@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Infinity Interactive, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
