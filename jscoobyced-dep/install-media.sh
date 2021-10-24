#!/bin/sh

source deps.sh

install_repo "Brave Browser" "brave-browser" "https://brave-browser-apt-release.s3.brave.com/brave-core.asc" "https://brave-browser-apt-release.s3.brave.com/ stable main" "brave-browser"

install_repo "Spotify" "spotify" "https://download.spotify.com/debian/pubkey_0D811D58.gpg" "http://repository.spotify.com stable non-free" "spotify-client"

echo "Installation complete."