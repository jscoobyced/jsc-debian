#!/bin/bash

SUDOUSER=$(who | cut -d" " -f1)
echo "Running for user ${SUDOUSER}"

echo "Removing Docker repository and configuration."
rm -f /etc/apt/sources.list.d/docker.list
rm -f /usr/share/keyrings/docker.gpg
if [ "" != "${SUDOUSER}" ] && [ "root" != "${SUDOUSER}" ]; then
  rm -Rf /home/${SUDOUSER}/.docker
  rm -f /home/${SUDOUSER}/bin/docker-credential-secretservice
fi

echo "Removing Visual Studio Code repository."
rm -f /etc/apt/sources.list.d/microsoft.list
rm -f /etc/apt/sources.list.d/vscode.list
rm -f /usr/share/keyrings/microsoft.gpg
rm -f /etc/apt/trusted.gpg.d/microsoft.gpg
rm -f /etc/apt/trusted.gpg.d/nodejs.gpg
rm -f /etc/apt/trusted.gpg.d/yarn.gpg

echo "Restauring ~/.bashrc"
USERHOMEDIR=$(getent passwd ${SUDOUSER} | cut -f6 -d:)
cp "${USERHOMEDIR}/.bashrc" "${USERHOMEDIR}/.bashrc.old"
cp "${USERHOMEDIR}/.bashrc.bak" "${USERHOMEDIR}/.bashrc"

echo "Uninstallation complete."