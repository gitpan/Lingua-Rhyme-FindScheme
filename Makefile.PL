use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Lingua::Rhyme::FindScheme',
    'VERSION_FROM'	=> 'FindScheme.pm',
    'PREREQ_PM'		=> {Lingua::Rhyme=>0.07},
);
