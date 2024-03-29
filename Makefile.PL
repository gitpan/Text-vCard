
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.013.
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Edit and create vCards (RFC 2426)",
  "AUTHOR" => "Leo Lapworth, Eric Johnson (kablamo)",
  "BUILD_REQUIRES" => {},
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
    "MIME::Base64" => "3.07",
    "MIME::QuotedPrint" => "3.07",
    "Moo" => 0,
    "Moo::Role" => 0,
    "Path::Tiny" => 0,
    "Text::Wrap" => 0,
    "Text::vFile::asData" => "0.07",
    "URI" => 0,
    "Unicode::LineBreak" => 0,
    "base" => 0,
    "strict" => 0,
    "vars" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Data::Dumper" => 0,
    "Directory::Scratch" => 0,
    "Test::More" => 0,
    "Test::Most" => 0,
    "lib" => 0
  },
  "VERSION" => "3.06",
  "test" => {
    "TESTS" => "t/*.t t/text/vcard/node/*.t t/vcard/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Data::Dumper" => 0,
  "Directory::Scratch" => 0,
  "Encode" => 0,
  "MIME::Base64" => "3.07",
  "MIME::QuotedPrint" => "3.07",
  "Moo" => 0,
  "Moo::Role" => 0,
  "Path::Tiny" => 0,
  "Test::More" => 0,
  "Test::Most" => 0,
  "Text::Wrap" => 0,
  "Text::vFile::asData" => "0.07",
  "URI" => 0,
  "Unicode::LineBreak" => 0,
  "base" => 0,
  "lib" => 0,
  "strict" => 0,
  "vars" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



