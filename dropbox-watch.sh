#!/bin/sh
# A script that watches ~/Pictures/Screenshots dir, and any new file is added there, it
# is renamed so it would contain filename modify timestamp (uses safe
# characters not to require urlencode) and moved to dropbox dir. Additionally
# dropbox url is copied to clipboard and image viewer is opened to show that
# screenshot.
#
# Author: Elan Ruusamäe <glen@delfi.ee>
# Date: 2012-11-09
# Updated: 2014-07-22 (test all tools, more filename filters)

watchdir=$HOME/Pictures/Screenshots
viewer=xdg-open

# Config
dropdir=$HOME/Dropbox/Public/ss
dropuser=YOUR_DROPBOX_NUMERIC_USER_ID
dropurl=https://dl.dropboxusercontent.com/u/$dropuser/ss

if [ ! -d $dropdir ]; then
	echo >&2 "Dropbox dir $dropdir missing!"
	exit 1
fi

if [ ! -d $watchdir ]; then
	echo >&2 "Watch dir $watchdir missing!"
	exit 1
fi

if ! which $viewer 2>/dev/null; then
	echo >&2 "Can't find viewer: $viewer"
	exit 1
fi

if ! which inotifywait 2>/dev/null; then
	echo >&2 "Can't find tool: inotifywait, install inotify-tools"
	exit 1
fi

if ! which notify-send 2>/dev/null; then
	echo >&2 "Can't find tool: notify-send, install libnotify"
	exit 1
fi

if ! which xclip 2>/dev/null; then
	echo >&2 "Can't find tool: xclip, install xclip"
	exit 1
fi

inotifywait -m -e moved_to -e close_write $watchdir | while read path change filename; do
	case "$change" in
	CREATE|MOVED_TO|*CLOSE_WRITE*)
		file=$path/$filename
		;;
	*)
		continue
	esac

	# reformat filename so it woult be nice url
	mtime=$(stat -c "%y" "$file")
	# Strip 'Screenshot - 04062013 - 11:30:49 AM.png'
	# strip 'Screenshot - 14.01.2013 - 15:04:02', and leave everything else part of the filename
	fn=$(echo "$filename" | sed -e 's,^Screenshot - [ .:0-9-]*[AP]M,,')
	# Strip 'Screenshot from 2013-02-13 23:49:07'
	# Strip 'Screenshot - 30.05.2013 - 11:48:58.png'
	fn=$(echo "$fn" | sed -re 's,^Screenshot( from)? [ .:0-9-]*,,')

	# sanitize exts
	fn=$(echo "$fn" | sed -re 's/\.?(jpe?g|png)$//' -e 'y/ /_/')
	filename=$(date -d "$mtime" '+%Y-%m-%d_%H.%M.%S')${fn:+-$fn}.png

	# bugfixes
	fn=$(echo "$fn" | sed -re 's/\.png\.png$/.png/')

	url="$dropurl/$filename"

	mv "$file" "$dropdir/$filename"

	$viewer "$dropdir/$filename" &

	# Copy URL to clipboard and notify the user
	echo -n "$url" | xclip -selection c
	notify-send --hint=int:transient:1 "Screenshot Uploaded" "Copied URL to clipboard:\n$url"
done
