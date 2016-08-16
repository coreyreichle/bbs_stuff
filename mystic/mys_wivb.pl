#!/usr/bin/perl -w

#use strict;
use utf8;
use XML::Feed;
use HTML::Strip;
use Encode;
use Text::Wrap;
 

$Text::Wrap::columns = 60;

# This is the configuration section.
my $feed_url = "http://wivb.com/feed";

### Do not edit anything past this line, dragons be lurking...
# No, seriously, you shouldn't have to edit anything past here.  It will "just work(TM)
 
my $feed = XML::Feed->parse(URI->new($feed_url)) or die XML::Feed->errstr;

	foreach my $entry ($feed->entries) {
#Ok, so you might need to do some editing here, to grab to correct part of the RSS feed you want in the body of the email.	  
		my $url = $entry->link;
		my $newsfile = "/mystic/news/" .$entry->title . ".txt";
		open (FILE, "> $newsfile") || die "problem opening $newsfile\n";
		foreach my $body ($entry->content) {
			my $text = $body->body;
			my $hr = HTML::Strip->new();
			my $clean = $hr->parse ( $text ) ."\n";
			$clean =~ wrap('', '',$clean);
	  		print FILE $clean;
			print FILE "\n###\n" . $entry->link . "\n";
		}
		close FILE;
}
