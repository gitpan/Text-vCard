use ExtUtils::MakeMaker;

my $VERSION = '1.2';

my $ABSTRACT = "Module for parsing and creating vCards (RFC 2426) address";

WriteMakefile(
 	'NAME'		=> 'Text::vCard',
	'ABSTRACT'	=> $ABSTRACT,
	'AUTHOR'	=> 'Leo Lapworth',
	'VERSION'	=> $VERSION, # finds $VERSION
	'PREREQ_PM'		=> {
    	'Text::vFile::asData' => '0.01',
    	'Test::More' => '0.1',
    }, 
);
