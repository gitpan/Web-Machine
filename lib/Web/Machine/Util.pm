package Web::Machine::Util;
# ABSTRACT: General Utility module

use strict;
use warnings;

use Carp         qw[ confess ];
use Scalar::Util qw[ blessed ];
use List::Util   qw[ first ];

use HTTP::Headers::ActionPack;

use Sub::Exporter -setup => {
    exports => [qw[
        first
        pair_key
        pair_value
        bind_path
        create_date
        create_header
        inflate_headers
    ]]
};

sub pair_key   { ( keys   %{ $_[0] } )[0] }
sub pair_value { ( values %{ $_[0] } )[0] }

{
    my $ACTION_PACK = HTTP::Headers::ActionPack->new;
    sub create_header   { $ACTION_PACK->create( @_ ) }
    sub create_date     { $ACTION_PACK->create( 'DateHeader' => shift ) }
    sub inflate_headers { $ACTION_PACK->inflate( @_ ) }
}

sub bind_path {
    my ($spec, $path) = @_;
    my @parts = split /\// => $path;
    my @spec  = split /\// => $spec;

    my @results;
    foreach my $i ( 0 .. $#spec ) {
        if ( $spec[ $i ] =~ /^\*$/ ) {
            push @results => @parts[ $i .. $#parts ];
            last;
        }
        elsif ( $spec[ $i ] =~ /^\:/ ) {
            return unless defined $parts[ $i ];
            push @results => $parts[ $i ];
        }
        elsif ( $spec[ $i ] =~ /^\?\:/ ) {
            push @results => $parts[ $i ] if defined $parts[ $i ];
        }
        else {
            return unless defined $parts[ $i ];
            return unless $spec[$i] eq $parts[$i];
        }
    }

    wantarray
        ? @results
        : (scalar @results == 1)
            ? $results[0]
            : @results;
}

1;



=pod

=head1 NAME

Web::Machine::Util - General Utility module

=head1 VERSION

version 0.02

=head1 SYNOPSIS

  use Web::Machine::Util;

=head1 DESCRIPTION

This is just a basic utility module used internally by
L<Web::Machine>. There is no real user servicable parts
in here.

=head1 FUNCTIONS

=over 4

=item C<first>

This is imported from L<List::Util> and passed on here
for export.

=item C<pair_key>

=item C<pair_value>

These two functions are used for fetching the key
and value out of a pair in the L<Web::Machine> internals.
We represent a pair simply as a HASH ref with one key.

=item C<inflate_headers( $request )>

This will call C<inflate> on an instance of L<HTTP::Headers::ActionPack>.

=item C<create_headers( @args )>

This will call C<create> on an instance of L<HTTP::Headers::ActionPack>.

=item C<create_date( $date_string | $time_peice )>

Given either a C<$date_string> or an instance of L<Time::Piece>,
this will inflate it into a L<HTTP::Headers::ActionPack::DateHeader>
object, suitable for use in the FSM.

=item C<bind_path( $path_spec, $path )>

Given a C<$path_spec> (described below) and a C<$path>, this will
either bind the path to the spec and return and array of bound
values, or it will return nothing. Returning nothing indicates
that no match was found. Additionally, if this function is called
in scalar context, and there is only one match, it will return
that item. Otherwise it will return the array as normal. This all
makes it easy to use the following idiom:

  if ( my $id = bind_path( '/:id', $request->path_info ) ) {
      # handle the case with an ID here
  }
  else {
      # handle other cases here
  }

The C<$path_spec> follows a pretty standard convention. Literal
path parts must match corresponding literal. Variable path parts
are prefixed by a colon and are captured for returning later.
And lastly the "splat" operator (C<*>) is supported and causes
all the rest of the path segements to be returned. Below are a
few examples of this:

  spec                  path             result
  ------------------------------------------------------------
  /test/:foo/:bar       /test/1/2        ( 1, 2 )
  /test/*               /test/1/2/3      ( 1, 2, 3 )
  /user/:id/:action     /user/1/edit     ( 1, 'edit' )
  /:id                  /201             ( 201 )

This function is kept deliberately simple and it is expected
that the user will use C<my> in the array form to assign
multiple variables, like this:

  my ( $foo, $bar ) = bind_path( '/test/:foo/:bar', $path );

In the future we might add a C<bind_path_hash> function which
captures the variable names as well, but to be honest, if you
feel you need that, you likely want one of the many excellent
path dispatching modules available on CPAN.

=back

=head1 AUTHOR

Stevan Little <stevan.little@iinteractive.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

