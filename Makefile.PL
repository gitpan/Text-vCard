
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "a package to edit and create a single vCard (RFC 2426)",
  "AUTHOR" => "Leo Lapworth",
  "BUILD_REQUIRES" => {
    "Data::Dumper" => 0,
    "Digest" => 0,
    "Test::More" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Text-vCard",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Text::vCard",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Encode" => 0,
    "File::Slurp" => "9999.04",
    "MIME::Base64" => "3.07",
    "MIME::QuotedPrint" => "3.07",
    "Text::vFile::asData" => "0.07",
    "base" => 0,
    "strict" => 0,
    "vars" => 0,
    "warnings" => 0
  },
  "VERSION" => "2.13",
  "test" => {
    "TESTS" => "t/*.t"
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



