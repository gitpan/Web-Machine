package Web::Machine::I18N;
BEGIN {
  $Web::Machine::I18N::AUTHORITY = 'cpan:STEVAN';
}
{
  $Web::Machine::I18N::VERSION = '0.09';
}
# ABSTRACT: The I18N support for HTTP information

use strict;
use warnings;

use parent 'Locale::Maketext';

1;

__END__

=pod

=head1 NAME

Web::Machine::I18N - The I18N support for HTTP information

=head1 VERSION

version 0.09

=head1 SYNOPSIS

  use Web::Machine::I18N;

=head1 DESCRIPTION

This is basic support for internationalization of HTTP
information. Currently it just provides response bodies
for HTTP errors.

=head1 AUTHOR

Stevan Little <stevan.little@iinteractive.com>

=head1 CONTRIBUTORS

=over 4

=item *

Andrew Nelson <anelson@cpan.org>

=item *

Dave Rolsky <autarch@urth.org>

=item *

Fayland Lam <fayland@gmail.com>

=item *

Gregory Oschwald <goschwald@maxmind.com>

=item *

Jesse Luehrs <doy@tozt.net>

=item *

John SJ Anderson <genehack@genehack.org>

=item *

Olaf Alders <olaf@wundersolutions.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
