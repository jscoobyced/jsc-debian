#!/bin/bash

source ./deps.sh

ALREADY=$(ls /etc/apt/sources.list.d/brave* | grep -v "cannot access")
if [ "" = "${ALREADY}" ]; then
    install_repo "Brave Browser" "brave-browser" "https://brave-browser-apt-release.s3.brave.com/brave-core.asc" "https://brave-browser-apt-release.s3.brave.com/ stable main" "brave-browser"
fi

ALREADY=$(ls /etc/apt/sources.list.d/spotify* | grep -v "cannot access")
if [ "" = "${ALREADY}" ]; then
    install_repo "Spotify" "spotify" "https://download.spotify.com/debian/pubkey_0D811D58.gpg" "http://repository.spotify.com stable non-free" "spotify-client"

fi

echo "Installation complete."