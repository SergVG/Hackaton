#!/usr/bin/perl

# Basic Telegram Bot implementation using WWW::Telegram::BotAPI
use strict;
use warnings;
use WWW::Telegram::BotAPI;
use Webinar::Organization;
my $API_KEY="d512e159cd8e9b42c636692bc498b6aa";
use Data::Dumper;

my $api = WWW::Telegram::BotAPI->new (
    token => (shift or die "ERROR: a token is required!\n")
);
my $emails={};

# Bump up the timeout when Mojo::UserAgent is used (LWP::UserAgent uses 180s by default)
$api->agent->can ("inactivity_timeout") and $api->agent->inactivity_timeout (45);

my $me = $api->getMe or die;
my ($offset, $updates) = 0;

# The commands that this bot supports.
my $pic_id; # file_id of the last sent picture
my $commands = {
    "start"    => "Hello! Сообщите свой email: /mail",
    # Example demonstrating the use of parameters in a command.
    "email"      => \&email,
    "analize"	=> \&analize,
    # Example showing how to use the result of an API call.
    "whoami"   => sub {
	#print Dumper($_[0]);
        sprintf "Hello %s, I am %s! How are you?", shift->{from}{username}, $me->{result}{username}
    },
    # Internal target called when a photo is received.
    "_photo" => sub { $pic_id = shift->{photo}[0]{file_id} },
    # Internal target used to handle unknown commands.
    "_unknown" => "Unknown command :("
};

printf "Hello! I am %s. Starting...\n", $me->{result}{username};

while (1) {
    $updates = $api->getUpdates ({
        timeout => 30, # Use long polling
        $offset ? (offset => $offset) : ()
    });
#	for (keys %$chats){
#		$api->sendMessage({chat_id=>$_,
#			text=>'Ты здесь?'});
#}
    unless ($updates and ref $updates eq "HASH" and $updates->{ok}) {
        warn "WARNING: getUpdates returned a false value - trying again...";
        next;
    }
    for my $u (@{$updates->{result}}) {
        $offset = $u->{update_id} + 1 if $u->{update_id} >= $offset;
	#$chats->{$u->{message}{chat}{id}}=1;
        if (my $text = $u->{message}{text}) { # Text message
            printf "Incoming text message from \@%s\n", $u->{message}{from}{username};
            printf "Text: %s\n", $text;
            next if $text !~ m!^/!; # Not a command
            my ($cmd, @params) = split / /, $text;
            my $res = $commands->{substr ($cmd, 1)} || $commands->{_unknown};
            # Pass to the subroutine the message object, and the parameters passed to the cmd.
            $res = $res->($u->{message}, @params) if ref $res eq "CODE";
            next unless $res;
            my $method = ref $res && $res->{method} ? delete $res->{method} : "sendMessage";
            $api->$method ({
                chat_id => $u->{message}{chat}{id},
                ref $res ? %$res : ( text => $res )
            });
            print "Reply sent.\n";
        } elsif ($u->{message}{photo}) {
            print "Incoming picture...\n";
            $commands->{_photo}->($u->{message}) if ref $commands->{_photo} eq "CODE";
        }
        # TODO: other message types...
    }
}

sub _sendTextMessage {
    $api->sendMessage ({
        chat_id => shift->{message}{chat}{id},
        %{+shift}
    })
}


sub email { $emails->{shift->{from}{id}}=$_[1]; "$_[0] OK" }
sub analize { 

my $msg=shift;	
if (!exists $emails->{$msg->{from}{id}}){
"Введите ваш email с помощью команды /email"
} else {
  my $email=$emails->{$msg->{from}{id}};

 my $org = Webinar::Organization->new($API_KEY);

 return "Вы (${email}) не зарегистрированы как участник" unless  (defined $org->getIdByEmail($email));
#Здесь нужно проанализировать что смотрел юзер и дать рекомендации что ещё посмотреть
 
}
}
