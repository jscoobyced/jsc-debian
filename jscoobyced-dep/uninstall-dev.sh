#!/bin/bash

echo "Removing Docker and repository."
sudo rm /etc/apt/sources.list.d/docker.list
rm -f /usr/share/keyrings/docker.gpg

echo "Uninstallation complete."