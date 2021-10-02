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
  DC_VERSION="v0.6.4"
  wget https://github.com/docker/docker-credential-helpers/releases/download/${DC_VERSION}/docker-credential-secretservice-${DC_VERSION}-amd64.tar.gz
  tar -zxf docker-credential-secretservice-${DC_VERSION}-amd64.tar.gz
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

ALREADY=$(which node)
  if [ "" = "${ALREADY}" ]; then
  install_repo "Node JS" "nodejs" "https://deb.nodesource.com/gpgkey/nodesource.gpg.key" "https://deb.nodesource.com/node_14.x hirsute main" "nodejs"
fi

ALREADY=$(which yarn)
  if [ "" = "${ALREADY}" ]; then
  install_repo "Yarn" "yarn" "https://dl.yarnpkg.com/debian/pubkey.gpg" "https://dl.yarnpkg.com/debian stable main" "yarn"
fi

echo "Installing Git prompt"

USERHOMEDIR=$(getent passwd ${SUDOUSER} | cut -f6 -d:)
cp "${USERHOMEDIR}/.bashrc" "${USERHOMEDIR}/.bashrc.bak"
cat <<EOT >> "${USERHOMEDIR}/.bashrc"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]\$(parse_git_branch " \(\%s\)")\[\033[00m\] \$ '
EOT

source "${USERHOMEDIR}/.bashrc"

echo "Installation complete."
