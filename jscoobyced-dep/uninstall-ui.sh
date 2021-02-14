#!/bin/bash

echo "Removing Brave Browser repository."
rm -f /etc/apt/sources.list.d/brave-browser.list
rm -f /usr/share/keyrings/brave-browser.gpg

echo "Uninstallation complete."