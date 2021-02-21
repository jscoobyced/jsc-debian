#!/bin/sh

chmod +x /opt/replace-me/bin/hello-world
update-alternatives --install /usr/bin/hello-world helloworld /opt/replace-me/bin/hello-world 100

echo "Installation complete."