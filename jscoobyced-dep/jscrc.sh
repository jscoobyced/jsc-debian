#!/bin/sh

SUDOUSER=$(who | cut -d" " -f1)
echo "Running for user ${SUDOUSER}"
