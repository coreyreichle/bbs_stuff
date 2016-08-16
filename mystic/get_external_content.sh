#!/bin/bash

# Archive off files
cp /mystic/news/weather.txt /mystic/files/ny/buffalo/weather/`date +%Y-%m-%d`-weather.txt
cp /mystic/news/*.txt /mystic/files/ny/buffalo/news/
mv /mystic/files/ny/buffalo/news/ap.txt /mystic/files/ny/buffalo/news/`date +%Y-%m-%d`-ap.txt
rm /mystic/files/ny/buffalo/news/weather.txt
rm /mystic/news/*.txt

# Grab WIVB's feed, and do some text cleanup to make it prettified
/home/pi/bin/wivb_feed.pl ; sed -i 's/\\x{\S*}//g' /mystic/news/*.txt ; sed -i '/^$/N;/^\n$/D' /mystic/news/*.txt

# Grab the top news page from AP wire
/usr/bin/links2 -dump "http://customwire.ap.org/dynamic/fronts/HOME?SITE=AP&SECTION=HOME" | sed -n '42,$p' > /mystic/news/ap.txt

# Just in case, add the mystic pipe command for pausing at the end of it, in case someone does "continuous"
echo "|PA" >> /mystic/news/ap.txt

# Grab local weather forecast
/usr/bin/links2 -dump "http://forecast.weather.gov/MapClick.php?lat=42.8798&lon=-78.8143&unit=0&lg=english&FcstType=text&TextType=1" > /mystic/news/weather.txt
echo "|PA" >> /mystic/news/weather.txt

# Grab NOAA Space weather reports
cd /mystic/files/noaa
wget -Atxt -nd -r -l1  http://services.swpc.noaa.gov/text/

# Update uploaded files
cd /mystic
/mystic/mutil uploader.ini
