package Webinar::Base;

use strict;
use warnings;

use JSON;
use LWP::UserAgent;

my $HOST="https://userapi.webinar.ru/v3";

sub req
{
    my ($self, $method, $url, $content) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->agent("MyApp/0.1");

    my $req = HTTP::Request->new($method => $HOST.$url);
    $req->header("X-Auth-Token" => $self->{token});

    if ($content) {
        require URI;
        my $url = URI->new('http:');
        $url->query_form(ref($content) eq "HASH" ? %$content : @$content);
        $content = $url->query;

        # HTML/4.01 says that line breaks are represented as "CR LF" pairs (i.e., `%0D%0A')
        $content =~ s/(?<!%0D)%0A/%0D%0A/g if defined($content);

        warn $content;
        $req->header('Content-Type' => 'application/x-www-form-urlencoded');
        $req->content($content);
    }

    my $res = $ua->request($req);

    # Check the outcome of the response
    if ($res->is_success) {
        return JSON::from_json($res->content);
    }
    else {
       die $res->status_line, "\n";
    }

}

sub new
{
    my ($class, $key) = @_;
    return bless {token => $key}, $class;
}

1;
