package Web::Machine::I18N::en;
BEGIN {
  $Web::Machine::I18N::en::AUTHORITY = 'cpan:STEVAN';
}
# ABSTRACT: The English support for I18N-ed HTTP information
$Web::Machine::I18N::en::VERSION = '0.15';
use strict;
use warnings;

use parent 'Web::Machine::I18N';

our %Lexicon = (
    100 => 'Continue',
    101 => 'Switching Protocols',
    200 => 'OK',
    201 => 'Created',
    202 => 'Accepted',
    203 => 'Non-Authoritative Information',
    204 => 'No Content',
    205 => 'Reset Content',
    206 => 'Partial Content',
    300 => 'Multiple Choices',
    301 => 'Moved Permanently',
    302 => 'Found',
    303 => 'See Other',
    304 => 'Not Modified',
    305 => 'Use Proxy',
    307 => 'Temporary Redirect',
    400 => 'Bad Request',
    401 => 'Unauthorized',
    402 => 'Payment Required',
    403 => 'Forbidden',
    404 => 'Not Found',
    405 => 'Method Not Allowed',
    406 => 'Not Acceptable',
    407 => 'Proxy Authentication Required',
    408 => 'Request Time-out',
    409 => 'Conflict',
    410 => 'Gone',
    411 => 'Length Required',
    412 => 'Precondition Failed',
    413 => 'Request Entity Too Large',
    414 => 'Request-URI Too Large',
    415 => 'Unsupported Media Type',
    416 => 'Requested range not satisfiable',
    417 => 'Expectation Failed',
    418 => "I'm a teapot",
    500 => 'Internal Server Error',
    501 => 'Not Implemented',
    502 => 'Bad Gateway',
    503 => 'Service Unavailable',
    504 => 'Gateway Time-out',
    505 => 'HTTP Version not supported',
);

1;

__END__

=pod

=head1 NAME

Web::Machine::I18N::en - The English support for I18N-ed HTTP information

=head1 VERSION

version 0.15

=head1 SYNOPSIS

  use Web::Machine::I18N;

  my $lang = Web::Machine::I18N->get_handle('en');

=head1 SEE ALSO

L<Web::Machine::I18N>

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
