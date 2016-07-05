#!/bin/bash

/usr/bin/telnet kc2ugv-9.coreyreichle.com 25 << _EOF

ehlo localhost
auth login
cram_hash_for_user_here
cram_has_for_password_here
mail from: kc2ugv@kc2ugv-9.coreyreichle.com
rcpt to: weather@kc2ugv-9.coreyreichle.com
data
Subject: `/bin/date +"%d %B %Y"` 7 Day Outlook 

`/usr/bin/links2 -dump "http://forecast.weather.gov/MapClick.php?lat=42.8798&lon=-78.8143&unit=0&lg=english&FcstType=text&TextType=1"`
.
quit
_EOF
