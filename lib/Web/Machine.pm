package Web::Machine;
BEGIN {
  $Web::Machine::AUTHORITY = 'cpan:STEVAN';
}
{
  $Web::Machine::VERSION = '0.07';
}
# ABSTRACT: A Perl port of WebMachine

use strict;
use warnings;

use Carp         qw[ confess ];
use Scalar::Util qw[ blessed ];

use Plack::Request;
use Plack::Response;

use Web::Machine::Util qw[ inflate_headers ];
use Web::Machine::FSM;

use parent 'Plack::Component';

sub new {
    my ($class, %args) = @_;

    (exists $args{'resource'}
        && (not blessed $args{'resource'})
            && $args{'resource'}->isa('Web::Machine::Resource'))
                || confess 'You must pass in a resource for this Web::Machine';

    $class->SUPER::new( \%args );
}

sub inflate_request {
    my ($self, $env) = @_;
    inflate_headers( Plack::Request->new( $env ) );
}

sub create_fsm {
    my $self = shift;
    Web::Machine::FSM->new( tracing => $self->{'tracing'} )
}

sub create_resource {
    my ($self, $request) = @_;
    $self->{'resource'}->new(
        request  => $request,
        response => $request->new_response,
        @{ $self->{'resource_args'} || [] },
    );
}

sub finalize_response {
    my ($self, $response) = @_;
    $response->finalize;
}

sub call {
    my ($self, $env) = @_;

    my $request  = $self->inflate_request( $env );
    my $resource = $self->create_resource( $request );
    my $fsm      = $self->create_fsm;

    if ($self->{'streaming'}) {
        return sub {
            my $responder = shift;

            my $response = $self->finalize_response( $fsm->run( $resource ) );

            if (my $cb = $env->{'web.machine.streaming_push'}) {
                pop @$response;
                my $writer = $responder->($response);
                $cb->($writer);
            }
            else {
                $responder->($response);
            }
        }
    }
    else {
        my $response = $self->finalize_response( $fsm->run( $resource ) );

        if ($env->{'web.machine.streaming_push'}) {
            die "Can't do a streaming push response "
              . "unless the 'streaming' option was set";
        }
        else {
            return $response;
        }
    }
}

1;

__END__

=pod

=head1 NAME

Web::Machine - A Perl port of WebMachine

=head1 VERSION

version 0.07

=head1 SYNOPSIS

  use strict;
  use warnings;

  use Web::Machine;

  {
      package HelloWorld::Resource;
      use strict;
      use warnings;

      use parent 'Web::Machine::Resource';

      sub content_types_provided { [{ 'text/html' => 'to_html' }] }

      sub to_html {
          q{<html>
              <head>
                  <title>Hello World Resource</title>
              </head>
              <body>
                  <h1>Hello World</h1>
              </body>
           </html>}
      }
  }

  Web::Machine->new( resource => 'HelloWorld::Resource' )->to_app;

=head1 DESCRIPTION

This is a port of L<Webmachine|https://github.com/basho/webmachine>,
actually it is much closer to L<the ruby version|https://github.com/seancribbs/webmachine-ruby>, with
a little bit of L<the javascript version|https://github.com/tautologistics/nodemachine>
and even some of L<the python version|https://github.com/davisp/pywebmachine>
thrown in for good measure.

It runs atop L<Plack>, but since it really handles the whole HTTP
transaction, it is not appropriate to use most middleware modules.
(NOTE: I will write more about this in the future.)

=head1 CAVEAT

This module is extremely young and it is a port of an pretty young (June 2011)
module in another language (ruby), which itself is a port of a still kind of
young module (March 2009) in yet another language (erlang). But that all said,
it really seems like a sane idea and so I stole it and ported it to Perl.

=head1 METHODS

NOTE: This module is a L<Plack::Component> subclass and so follows the interface
set forward by that module.

=over 4

=item C<< new( resource => $resource_classname, ?resource_args => $arg_list, ?tracing => 1|0, ?streaming => 1|0 ) >>

The constructor expects to get a C<$resource_classname>, which it will use to
create an instance of the resource class. If that class requires any additional
arguments, they can be specified with the C<resource_args> parameter. It can
also take an optional C<tracing> parameter which it will pass onto the
L<Web::Machine::FSM>, and an optional C<streaming> parameter, which if true
will run the request in a L<PSGI> streaming response, which can be useful if
you need to run your content generation asynchronously.

=item C<inflate_request( $env )>

This takes a raw PSGI C<$env> and inflates it into a L<Plack::Request> instance.
By default this also uses L<HTTP::Headers::ActionPack> to inflate the headers
of the request to be complex objects.

=item C<create_fsm>

This will create the L<Web::Machine::FSM> object to run. It will get passed
the value of the C<tracing> constructor parameter.

=item C<create_resource( $request )>

This will create the L<Web::Machine::Resource> instance using the class specified
in the C<resource> constructor parameter. It will pass in the C<$request> object
and call C<new_response> on the C<$request> object to get a L<Plack::Response>
instance.

=item C<finalize_response( $response )>

Given a C<$response> which is a L<Plack::Response> object, this will finalize
it and return a raw PSGI response.

=item C<call( $env )>

This is the C<call> method overridden from the L<Plack::Component> superclass.

=back

=head1 DEBUGGING

If you set the C<WM_DEBUG> environment variable to C<1> we will print
out information about the path taken through the state machine to STDERR.

=head1 SEE ALSO

=over 4

=item Original Erlang - L<https://github.com/basho/webmachine>

=item Ruby port - L<https://github.com/seancribbs/webmachine-ruby>

=item Node JS port - L<https://github.com/tautologistics/nodemachine>

=item Python port - L<https://github.com/davisp/pywebmachine>

=back

=head1 AUTHOR

Stevan Little <stevan.little@iinteractive.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
