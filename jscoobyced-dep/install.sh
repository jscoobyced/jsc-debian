#!/bin/sh

./jscrc.sh

echo "Updating locale to 'en_US'"
ALREADY=$(grep "en_US.UTF-8" /etc/locale.gen | grep "#" | wc -l)
if [ "0" != "${ALREADY}" ]; then
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
  dpkg-reconfigure --frontend=noninteractive locales
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
else
  echo "Already setup."
fi

echo "Installation complete."