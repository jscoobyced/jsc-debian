#!/bin/sh

SUDOUSER=$(who | cut -d" " -f1)
echo "Running for user ${SUDOUSER}"

echo "Updating locale to 'en_US'"
ALREADY=$(grep "en_US.UTF-8" /etc/locale.gen | grep "#" | wc -l)
if [ "0" != "${ALREADY}" ]; then
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
  dpkg-reconfigure --frontend=noninteractive locales
else
  echo "Already setup."
fi

update-locale LANG="en_US.UTF-8"
update-locale LC_NUMERIC="en_US.UTF-8"
update-locale LC_TIME="en_US.UTF-8"
update-locale LC_MONETARY="en_US.UTF-8"
update-locale LC_PAPER="en_US.UTF-8"
update-locale LC_NAME="en_US.UTF-8"
update-locale LC_ADDRESS="en_US.UTF-8"
update-locale LC_TELEPHONE="en_US.UTF-8"
update-locale LC_MEASUREMENT="en_US.UTF-8"
update-locale LC_IDENTIFICATION="en_US.UTF-8"

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

echo "Installation complete."