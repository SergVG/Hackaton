#!/usr/bin/perl

 use Webinar::Organization;
 my $API_KEY="d512e159cd8e9b42c636692bc498b6aa";

 my $org = Webinar::Organization->new($API_KEY);

use Data::Dumper;
 print Dumper($org->members());
print $org->getIdByEmail('sergvg@gmail.com');