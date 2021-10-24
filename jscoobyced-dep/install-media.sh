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

pip3 install --upgrade youtube-dl

echo "Installation complete."