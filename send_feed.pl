#!/usr/bin/perl -w

#use strict;
use utf8;
use XML::Feed;
use HTML::Strip;
use Net::SMTP;
use Encode;

# This is the configuration section.
my $feed_url = "http://yourfeedurl.here";
my $mail_user = "your_user";
my $mail_password = "your_password";
my $mail_server = "your_server";
my $distro = "the_name_of_your_distro";

### Do not edit anything past this line, dragons be lurking...
# No, seriously, you shouldn't have to edit anything past here.  It will "just work(TM)
 
my $feed = XML::Feed->parse(URI->new($feed_url)) or die XML::Feed->errstr;
my $smtp = Net::SMTP->new(
	Host => "$mail_server",
	Hello => 'localhost',
);

$smtp->auth("$mail_user", "$mail_password");
	
	foreach my $entry ($feed->entries) {
		$smtp->mail("$mail_user\@$mail_server");
		$smtp->recipient("$distro\@$mail_server");
		$smtp->data;
		$smtp->datasend("To: $distro\@$mail_server\n");
		$smtp->datasend("From: $mail_user\@$mail_server\n");
		$smtp->datasend("Content-Type: text/html \n");
		$smtp->datasend("Subject: " . $entry->title ."\n");
		# line break to separate headers from message body
		$smtp->datasend("\n");
#Ok, so you might need to do some editing here, to grab to correct part of the RSS feed you want in the body of the email.	  
		my $url = $entry->link;
		foreach my $body ($entry->content) {
			my $text = $body->body;
			my $hr = HTML::Strip->new();
			my $clean = $hr->parse ( $text ) ."\n";
			$clean =~ s/\x{2019}/'/g;
	  		$smtp->datasend ( encode("ISO-8859-1",$clean) );
		}
		$smtp->datasend ("\n###\n");
		$smtp->datasend ($entry->link."\n");
		$smtp->dataend();
		sleep 1;
}
	$smtp->quit;
