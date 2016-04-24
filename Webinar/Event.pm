package Webinar::Event;

use strict;
use warnings;

use base 'Webinar::Base';
use Data::Dumper;

sub list
{
    my ($self, %params) = @_;
    $self->req('GET','/organization/events/schedule');
}

sub participations
{
    my ($self, $eventId) = @_;
    $self->req('GET', "/events/$eventId/participations");
}

sub event_session_participations
{
    my ($self, $eventSessionId) = @_;
    $self->req('GET', "/eventsessions/$eventSessionId/participations");
}

sub invite
{
    my ($self, $eventId, $email) = @_;
    $self->req('POST', '/events/'.$eventId.'/invite', {eventId => $eventId,  
                    isAutoEnter => 'true', sendEmail => 'true', 
                    'users[0][email]' => $email});
}

sub get_user_webinars
{
    my ($self, $userId) = @_;

    return [] unless defined $userId;

    my %list = map { $_->{id} => $_ }  @{$self->list()};

    my %events;
    my @result;

    foreach my $e (values %list) {
        foreach my $es (@{$e->{eventSessions}}) {
            foreach my $p (@{ $self->event_session_participations( $es->{id} ) }) {
                if ($p->{userId} eq $userId) {
                    next if exists $events{ $p->{eventId} };
                    $events{ $p->{eventId} } = 1;

                    push @result, $list{ $p->{eventId} };
                }
            }
        }
    }
    
    return (\@result);
}

1;
