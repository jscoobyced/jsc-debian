#!/bin/bash

SUDOUSER=$(who | grep -v pts | tail -n 1 | cut -d" " -f1)
echo "Running for user ${SUDOUSER}"

KUBECTL_VERSION="1.24.7/2022-10-31"
DOCKER_COMPOSE_VERSION="v2.14.0"

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

ALREADY=$(ls /etc/apt/sources.list.d/docker* | grep -v "cannot access")
if [ "" = "${ALREADY}" ]; then
  install_repo "Docker" "docker" "https://download.docker.com/linux/ubuntu/gpg" "https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" "docker-ce"
  groupadd docker
  usermod -aG docker ${SUDOUSER}
fi

if [ ! -f /home/${SUDOUSER}/bin/docker-credential-secretservice ]; then
  pushd /tmp
  DC_VERSION="v0.7.0"
  wget -q -O docker-credential-secretservice "https://github.com/docker/docker-credential-helpers/releases/download/${DC_VERSION}/docker-credential-secretservice-${DC_VERSION}.linux-amd64"
  mkdir -p /home/${SUDOUSER}/bin/
  mkdir -p /home/${SUDOUSER}/.docker
  cp docker-credential-secretservice /home/${SUDOUSER}/bin/
  chmod u+x /home/${SUDOUSER}/bin/docker-credential-secretservice
  echo "{\"credsStore\": \"secretservice\"}" > /home/${SUDOUSER}/.docker/config.json
  chown -Rf ${SUDOUSER}:${SUDOUSER} /home/${SUDOUSER}/bin/
  chown -Rf ${SUDOUSER}:${SUDOUSER} /home/${SUDOUSER}/.docker
  popd
fi

echo "Installing docker-compose"

curl -L --silent "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

ALREADY=$(ls /etc/apt/sources.list.d/microsoft* | grep -v "cannot access")
  if [ "" = "${ALREADY}" ]; then
  install_repo "Visual Studio Code" "microsoft" "https://packages.microsoft.com/keys/microsoft.asc" "https://packages.microsoft.com/repos/vscode stable main" "code"
  mv /usr/share/keyrings/packages.microsoft.gpg /tmp/
  install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
fi

ALREADY=$(ls /etc/apt/sources.list.d/node* | grep -v "cannot access")
  if [ "" = "${ALREADY}" ]; then
  install_repo "Node JS" "nodejs" "https://deb.nodesource.com/gpgkey/nodesource.gpg.key" "https://deb.nodesource.com/node_14.x hirsute main" "nodejs"
fi

ALREADY=$(ls /etc/apt/sources.list.d/yarn* | grep -v "cannot access")
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

echo "Installing kubectl"

rm -f /tmp/kubectl
curl --silent -o /tmp/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
curl --silent -o /tmp/kubectl.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256
openssl sha1 -sha256 /tmp/kubectl | awk '{print $2" kubectl"}' > /tmp/kubectl.sha256.ori
SHADIFF=$(diff /tmp/kubectl.sha256.ori /tmp/kubectl.sha256 | wc -l)
if [ "${SHADIFF}" == "0" ];
then
  chmod +x /tmp/kubectl
  mv /tmp/kubectl ${USERHOMEDIR}/bin/kubectl
fi
rm /tmp/kubectl*

echo "Installing AWS eksctl"

rm -f /tmp/eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
chmod u+x /tmp/eksctl
mv /tmp/eksctl ${USERHOMEDIR}/bin/eksctl

echo "Installing AWS CLI version 2"

pushd /tmp
rm -Rf aws
curl --silent "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -qq awscliv2.zip
./aws/install
popd

ALREADY=$(ls /etc/apt/sources.list.d/terraform* | grep -v "cannot access")
  if [ "" = "${ALREADY}" ]; then
  install_repo "Terraform client" "terraform" "https://apt.releases.hashicorp.com/gpg" "https://apt.releases.hashicorp.com $(lsb_release -cs) main" "terraform"
fi

echo "If you want to install all the new dev tools, run:"
echo ""
echo "##########################################################################"
echo ""
echo "sudo apt install docker-ce code nodejs yarn terraform"
echo ""
echo "##########################################################################"
echo "Installation complete."
