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

echo "Uninstallation complete."