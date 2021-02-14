#!/bin/bash

echo "Removing Brave Browser repository."
rm -f /etc/apt/sources.list.d/brave-browser.list
rm -f /usr/share/keyrings/brave-browser.gpg
rm -f /etc/apt/trusted.gpg.d/brave-browser-release.gpg

echo "Removing Spotify repository."
rm -f /etc/apt/sources.list.d/spotify.list
rm -f /usr/share/keyrings/spotify.gpg
rm -f /etc/apt/trusted.gpg.d/spotify-*.gpg

echo "Removing custom scripts"
rm -f /usr/local/bin/clippng

echo "Uninstallation complete."