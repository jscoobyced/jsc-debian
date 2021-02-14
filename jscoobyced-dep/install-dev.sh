#!/bin/sh

SUDOUSER=$(who | cut -d" " -f1)
echo "Running for user ${SUDOUSER}"

echo "Installing Docker repository."
ALREADY=$(add-apt-repository -L | grep -i docker | wc -l)

if [ "0" = "${ALREADY}" ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | tee /usr/share/keyrings/docker.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
  groupadd docker
  usermod -aG docker ${SUDOUSER}
  echo "##########################################################################"
  echo "# You will need to run:                                                  #"
  echo "# sudo apt update && sudo apt install docker-ce                          #"
  echo "# in order to install Docker                                             #"
  echo "##########################################################################"
else
  echo "Already setup."
fi

echo "Installation complete."