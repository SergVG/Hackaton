package Webinar::Organization;

use strict;
use warnings;

use strict;
use warnings;

use base 'Webinar::Base';

sub members
{
    my ($self, $uid) = @_;
    $self->req('GET','/organization/members');
}



1;
