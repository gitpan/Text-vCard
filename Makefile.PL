use ExtUtils::MakeMaker;

my $VERSION = '0.8';

my $ABSTRACT = "Module for parsing and creating vCard (RFC 2426) address";

WriteMakefile(
    'NAME'		=> 'Text::vCard',
	'ABSTRACT'	=> $ABSTRACT,
	'AUTHOR'	=> 'Leo Lapworth',
    'VERSION'	=> $VERSION, # finds $VERSION
    'PREREQ_PM'		=> {
    	'Text::vFile' => '',
    	'Test::More' => '0.1',
    }, 
);
