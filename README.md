# Dropbox as Picture Share Service

Any file saved to `~/Pictures/Screenshots` gets renamed based on timestamp and moved to `~/Dropbox/Public/Screenshots` folder.

When the move is completed, URL for the image is copied to clipboard and image viewer is opened so you can see your image before you paste the URL to IM, e-mail, etc...

Requirements:
- [dropboxd](https://www.dropbox.com/install?os=lnx) running,
- [libnotify](http://ftp.gnome.org/pub/GNOME/sources/libnotify/0.7/),
- [inotify-tools](https://github.com/rvoicilas/inotify-tools/wiki)

You should start the script at startup of your X session.

# Stopped working after March 15, 2017

Dropbox Public Folders Will Soon Become Private Folders for Basic Users

According to the [announcement](https://www.dropbox.com/help/files-folders/public-folder), free accounts have until March 15 to update their links, while the lights will go out for paid accounts on September 1.

- https://news.ycombinator.com/item?id=13190802
- https://hardware.slashdot.org/story/16/12/16/2111220/dropbox-kills-public-folders-users-rebel
- http://gadgets.ndtv.com/apps/news/dropbox-public-folders-will-soon-become-private-folders-for-basic-users-1638697

# Installation

Copy `dropbox-watch.sh` to `$PATH`, for example `~/.local/bin/dropbox-watch.sh`, copy `dropbox-watch.desktop` to `~/.config/autostart/dropbox-watch.desktop`

Modify `dropbbox-watch.sh` to contain your Dropbox user id.
