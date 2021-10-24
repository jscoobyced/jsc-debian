#!/bin/bash

install_repo() {
  echo "Installing $1 repository."
  ALREADY=$(add-apt-repository -L | grep -i $2 | wc -l)

  if [ "0" = "${ALREADY}" ]; then
    curl -fsSL $3 | gpg --dearmor | tee /usr/share/keyrings/$2.gpg > /dev/null
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/$2.gpg] $4" | tee /etc/apt/sources.list.d/$2.list
    echo ""
    echo "##########################################################################"
    echo "# You will need to run:"
    echo "# sudo apt update && sudo apt install $5"
    echo "# in order to install $1"
    echo "##########################################################################"
    echo ""
  else
    echo "Already setup."
  fi
}

ALREADY=$(ls /etc/apt/sources.list.d/brave* | grep -v "cannot access")
if [ "" = "${ALREADY}" ]; then
    install_repo "Brave Browser" "brave-browser" "https://brave-browser-apt-release.s3.brave.com/brave-core.asc" "https://brave-browser-apt-release.s3.brave.com/ stable main" "brave-browser"
fi

ALREADY=$(ls /etc/apt/sources.list.d/spotify* | grep -v "cannot access")
if [ "" = "${ALREADY}" ]; then
    install_repo "Spotify" "spotify" "https://download.spotify.com/debian/pubkey_0D811D58.gpg" "http://repository.spotify.com stable non-free" "spotify-client"

fi

echo "Installation complete."