
BEGIN {
  unless ($ENV{AUTHOR_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for testing by the author');
  }
}

use strict;
use warnings;
use Test::More;

# generated by Dist::Zilla::Plugin::Test::PodSpelling 2.004003
eval "use Test::Spelling 0.12; use Pod::Wordlist::hanekomu; 1" or die $@;


add_stopwords(<DATA>);
all_pod_files_spelling_ok( qw( bin lib  ) );
__DATA__
Andreas
Axel
Charset
ETag
Encodings
Erlang
Fayland
Gratz
Hartzell
JS
JavaScript
Luehrs
Marienborg
Oschwald
RESTful
Raynham
Rolsky
Sibley
Stevan
WebDAV
Webmachine
arity
charsets
fREW
webmachine
Little
stevan
Infinity
Interactive
Inc
lib
Web
Machine
Resource
Util
BodyEncoding
FSM
I18N
en
ContentNegotiation
Manual
States
