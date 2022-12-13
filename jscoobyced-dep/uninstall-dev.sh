#!/bin/bash

SUDOUSER=$(who | grep -v pts | tail -n 1 | cut -d" " -f1)
USERHOMEDIR=$(getent passwd ${SUDOUSER} | cut -f6 -d:)
JSC_CONTINUE="N"

echo "Running for user ${SUDOUSER} with home directory ${USERHOMEDIR}."
echo "Some files will be deleted in the home directory."
read -p "Do you want to continue? [y/N] " JSC_CONTINUE_PROMPT

if [ "y" == "${JSC_CONTINUE_PROMPT}" ] || [ "Y" == "${JSC_CONTINUE_PROMPT}" ]; then
  JSC_CONTINUE="Y"
fi

check_and_delete() {
  if [ -f $1 ]; then
    if [ "Y" == "$2" ]; then
      if [ -d "$1" ]; then
        echo rm -Rf $1 >> /tmp/jscoobyced.txt
      fi
    else
      if [ -f "$1" ]; then
        echo rm -f $1 >> /tmp/jscoobyced.txt
      fi
    fi
  fi
}

do_uninstall() {
  echo "Removing Docker repository and configuration."
  check_and_delete /etc/apt/sources.list.d/docker.list
  check_and_delete /usr/share/keyrings/docker.gpg
  if [ "" != "${SUDOUSER}" ] && [ "root" != "${SUDOUSER}" ]; then
    check_and_delete ${USERHOMEDIR}/.docker Y
    check_and_delete ${USERHOMEDIR}/bin/docker-credential-secretservice
  fi

  echo "Removing Visual Studio Code repository."
  check_and_delete /etc/apt/sources.list.d/microsoft.list
  check_and_delete /etc/apt/sources.list.d/vscode.list
  check_and_delete /usr/share/keyrings/microsoft.gpg
  check_and_delete /etc/apt/trusted.gpg.d/microsoft.gpg
  check_and_delete /etc/apt/trusted.gpg.d/nodejs.gpg
  check_and_delete /etc/apt/trusted.gpg.d/yarn.gpg

  echo "Restauring ~/.bashrc"
  if [ -f "${USERHOMEDIR}/.bashrc.bak" ]; then
    cp "${USERHOMEDIR}/.bashrc" "${USERHOMEDIR}/.bashrc.old"
    cp "${USERHOMEDIR}/.bashrc.bak" "${USERHOMEDIR}/.bashrc"
  fi

  echo "Uninstalling cloud tools"
  check_and_delete /usr/local/bin/aws
  check_and_delete /usr/local/bin/aws_completer
  check_and_delete /usr/local/aws-cli
  check_and_delete ${USERHOMEDIR}/bin/kubectl
  check_and_delete ${USERHOMEDIR}/bin/eksctl
}

if [ "Y" == "${JSC_CONTINUE}" ]; then
  do_uninstall
  echo "Action that would have been executed:"
  cat /tmp/jscoobyced.txt
fi

echo "Uninstallation complete."