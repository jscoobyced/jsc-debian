#!/bin/bash

SUDOUSER=$(who | cut -d" " -f1)
echo "Running for user ${SUDOUSER}"

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

ALREADY=$(which docker)
if [ "" = "${ALREADY}" ]; then
  install_repo "Docker" "docker" "https://download.docker.com/linux/ubuntu/gpg" "https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" "docker-ce"
  groupadd docker
  usermod -aG docker ${SUDOUSER}
fi

if [ ! -f /home/${SUDOUSER}/bin/docker-credential-secretservice ]; then
  pushd /tmp
  wget https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-secretservice-v0.6.3-amd64.tar.gz
  tar -zxf docker-credential-secretservice-v0.6.3-amd64.tar.gz
  mkdir -p /home/${SUDOUSER}/bin/
  mkdir -p /home/${SUDOUSER}/.docker
  cp docker-credential-secretservice /home/${SUDOUSER}/bin/
  chmod u+x /home/${SUDOUSER}/bin/docker-credential-secretservice
  echo "{\"credsStore\": \"secretservice\"}" > /home/${SUDOUSER}/.docker/config.json
  chown -Rf ${SUDOUSER}:${SUDOUSER} /home/${SUDOUSER}/bin/
  chown -Rf ${SUDOUSER}:${SUDOUSER} /home/${SUDOUSER}/.docker
  popd
fi

ALREADY=$(which code)
  if [ "" = "${ALREADY}" ]; then
  install_repo "Visual Studio Code" "microsoft" "https://packages.microsoft.com/keys/microsoft.asc" "https://packages.microsoft.com/repos/vscode stable main" "vscode"
fi

echo "Installation complete."