package Webinar::Contacts;

use strict;
use warnings;

use base 'Webinar::Base';
use URI;

sub search
{
    my ($self, %params) = @_;

    my $uri = URI->new("");

    $uri->path("/contacts/search");

    $uri->query_form(
                        map { ('userIds[]' => $_) } @{$params{contactIds} // []},
                        map { ('contactIds[]' => $_) } @{$params{contactIds} // []},
                    );

    $self->req('GET', $uri->as_string);
}

sub getIdByEmail{
    my ($self, $email) =@_;
    my $u;
    
    for $u (@{$self->search}){
	    return $u->{userId} if ($u->{email} eq $email);
    }

    return undef;
}

sub create
{
    my ($self, $uid, %params) = @_;
    $self->req('POST','/users/'.$uid.'/contacts', \%params);
}


sub update
{
    my ($self, $contactId, %params) = @_;
    $self->req('PUT', "/contacts/$contactId", \%params);
}

sub delete
{

}


sub get
{

}


1;
