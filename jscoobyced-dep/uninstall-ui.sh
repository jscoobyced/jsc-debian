#!/bin/bash

check_and_delete() {
  if [ -f $1 ]; then
    if [ "Y" == "$2" ]; then
      echo rm -Rf $1 >> /tmp/jscoobyced.txt
    else
      echo check_and_delete $1 >> /tmp/jscoobyced.txt
    fi
  fi
}

do_uninstall() {
    echo "Removing Brave Browser repository."
    check_and_delete /etc/apt/sources.list.d/brave-browser.list
    check_and_delete /usr/share/keyrings/brave-browser.gpg
    check_and_delete /etc/apt/trusted.gpg.d/brave-browser-release.gpg

    echo "Removing Spotify repository."
    check_and_delete /etc/apt/sources.list.d/spotify.list
    check_and_delete /usr/share/keyrings/spotify.gpg
    check_and_delete /etc/apt/trusted.gpg.d/spotify-*.gpg
}

echo "Uninstallation complete."