package Webinar::Organization;

use strict;
use warnings;

use base 'Webinar::Base';

sub members
{
    my ($self, $uid) = @_;
    $self->req('GET','/organization/members');
}

sub getIdByEmail{
    my ($self, $email) =@_;
    my $u;
    for $u (@{$self->members}){
	return $u->{id} if ($u->{email} eq $email);
    }
    return undef;
}

1;
