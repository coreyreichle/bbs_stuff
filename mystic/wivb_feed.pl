#!/usr/bin/perl -w

#use strict;
use utf8;
use XML::Feed;
use HTML::Strip;
use Encode;
use Text::Wrap;
 

$Text::Wrap::columns = 70;

# This is the configuration section.
my $feed_url = "http://wivb.com/feed";

### Do not edit anything past this line, dragons be lurking...
# No, seriously, you shouldn't have to edit anything past here.  It will "just work(TM)
 
my $feed = XML::Feed->parse(URI->new($feed_url)) or die XML::Feed->errstr;
my $loop =0;
my $menu= "/mystic/menus/news.mnu";

open (MENU, "> $menu") || die "problem opening menu file $menu\n";
print MENU "WNY News Stories


00010000000000000000
5

|DFnewshdr
|CR|09Command |08-> |09

0
0



";
	
	foreach my $entry ($feed->entries) {
#Ok, so you might need to do some editing here, to grab to correct part of the RSS feed you want in the body of the email.	  
		my $url = $entry->link;
		my $title= $entry->title;
		my $newsfile = "/mystic/news/" . $title . ".txt";
		my $truntitle = substr($title, 0, 35);
		open (FILE,, '>:encoding(US-ASCII)', "$newsfile") || die "problem opening $newsfile\n";
		foreach my $body ($entry->content) {
			my $text = $body->body;
			my $hr = HTML::Strip->new();
			my $clean = $hr->parse ( $text ) ."\n";
			;$clean =~ wrap('', '',$clean);
	  		print FILE wrap('', '', $clean);
			print FILE "\n###\n" . $entry->link . "\n";
			print FILE "|PA";
			print MENU "|09(|10$loop|09) |03$truntitle


$loop

10000000000000000000
0
0
0
$loop


0
0
0
0
0
0
0
0
0
0
1
GD

/mystic/news/$title.txt
0


";
		}
		close FILE;
		$loop++;
		if ($loop >9) {
			print MENU "|09(|10A|09) |03AP Top Stories


A

10000000000000000000
0
0
0
10


0
0
0
0
0
0
0
0
0
0
1
GD

/mystic/news/ap.txt
0


|09(|10W|09) |03Weather


W

10000000000000000000
0
0
0
11


0
0
0
0
0
0
0
0
0
0
1
GD

/mystic/news/weather.txt
0





LINEFEED

10000000000000000000
0
0
0
12


0
0
0
0
0
0
0
0
0
0
0
|09(|10Q|09) |03Quit to Main Menu
|07Quit to Main Menu
|15Quit to Main Menu
Q

10000000000000000000
0
0
0
13


0
0
0
0
0
0
0
0
0
0
1
GO

main
0

";
			close MENU;
			die "Finished run\n";
		}
}
