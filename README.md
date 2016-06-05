## Dropbox as picture share service ##

Any file saved to `~/Pictures/Screenshots` gets renamed based on timestamp and moved to `~/Dropbox/Public/Screenshots` folder.

When the move is completed, URL for the image is copied to clipboard and image viewer is opened so you can see your image before you paste the URL to IM, e-mail, etc...

Requirements:
[dropboxd](https://www.dropbox.com/install?os=lnx) running,
[libnotify](http://ftp.gnome.org/pub/GNOME/sources/libnotify/0.7/),
[inotify-tools](https://github.com/rvoicilas/inotify-tools/wiki)

You should start the script at startup of your X session.

Installation
------------

Copy `dropbox-watch.sh` to `$PATH`, for example `~/.local/bin/dropbox-watch.sh`, copy `dropbox-watch.desktop` to `~/.config/autostart/dropbox-watch.desktop`

Modify `dropbbox-watch.sh` to contain your Dropbox user id.
