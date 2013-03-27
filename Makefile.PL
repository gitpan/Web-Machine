
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "A Perl port of Webmachine",
  "AUTHOR" => "Stevan Little <stevan.little\@iinteractive.com>",
  "BUILD_REQUIRES" => {
    "FindBin" => 0,
    "HTTP::Message::PSGI" => 0,
    "HTTP::Request" => 0,
    "HTTP::Request::Common" => 0,
    "HTTP::Response" => 0,
    "MIME::Base64" => 0,
    "Net::HTTP" => 0,
    "Plack::Runner" => 0,
    "Plack::Test" => 0,
    "Test::Fatal" => "0.003",
    "Test::More" => "0.88",
    "Test::NoWarnings" => 0,
    "base" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Web-Machine",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Web::Machine",
  "PREREQ_PM" => {
    "B" => 0,
    "Carp" => 0,
    "Data::Dumper" => 0,
    "HTTP::Headers::ActionPack" => "0.04",
    "HTTP::Status" => 0,
    "Hash::MultiValue" => 0,
    "IO::Handle::Util" => 0,
    "List::Util" => 0,
    "Locale::Maketext" => 0,
    "Plack::Component" => 0,
    "Plack::Request" => 0,
    "Plack::Response" => 0,
    "Plack::Util" => 0,
    "Scalar::Util" => 0,
    "Sub::Exporter" => 0,
    "Try::Tiny" => 0,
    "parent" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.09",
  "test" => {
    "TESTS" => "t/*.t t/600-yapc-talk-examples/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



