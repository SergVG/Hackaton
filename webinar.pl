#!/usr/bin/perl

use strict;
use warnings;

use Webinar::Organization;
my $API_KEY="d512e159cd8e9b42c636692bc498b6aa";

my $org = Webinar::Organization->new($API_KEY);

$org->members();

use Webinar::Contacts;

my $c = Webinar::Contacts->new($API_KEY);

$c->search();

#$c->create(315467, userId => 315467, email => 'dj.outline@gmail.com');

$c->update(130380,company => "google.com");

use Webinar::Event;

my $e = Webinar::Event->new($API_KEY);

use Data::Dumper;
use YAML;

#Получаем список вебинаров юзера
my $list =  $e->get_user_webinars(315467);

my @viewed;

foreach my $ev (@$list) {
    foreach my $es (@{$ev->{eventSessions}}) {
        push @viewed, eventSessin_to_words($es);
    }
}

use Bag::Similarity::Cosine;


sub eventSessin_to_words
{
    my ($es) = @_;
    my @texts;

    push @texts, $es->{description};
    push @texts, $es->{name};

    return map {split /\s+/} @texts;
}

1;
