#!/bin/sh
# A script that watches ~/Pictures/Screenshots dir, and any new file is added there, it
# is renamed so it would contain filename modify timestamp (uses safe
# characters not to require urlencode) and moved to dropbox dir. Additionally
# dropbox url is copied to clipboard and image viewer is opened to show that
# screenshot.
#
# Author: Elan Ruusamäe <glen@delfi.ee>
# Date: 2012-11-09

watchdir=$HOME/Pictures/Screenshots
# i'd use xdg-open here, but somewhy in GNOME 3.4 it opens dir containing the image
viewer=gpicview

# Config
dropdir=$HOME/Dropbox/Public
dropuser=YOUR_DROPBOX_NUMERIC_USER_ID
dropurl=https://dl.dropbox.com/u/$dropuser/ss

if [ ! -d $dropdir ]; then
	echo >&2 "Dropbox dir $dropdir missing!"
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
	filename=$(date -d "$mtime" '+%Y-%m-%d_%H.%M.%S').png

	url="$dropurl/$filename"

	mv "$file" "$dropdir/$filename"

	$viewer "$dropdir/$filename" &

	# Copy URL to clipboard and notify the user
	echo -n "$url" | xclip -selection c
	notify-send --hint=int:transient:1 "Screenshot Uploaded" "Copied URL to clipboard:\n$url"
done
