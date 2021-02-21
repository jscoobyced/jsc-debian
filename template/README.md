# Template DEB package #

This is a template you can copy and use to create a `.deb` package.
To build the debian package:
- increase the revision, minor or major version in the `.env` file

```
MAJOR=1
MINOR=0
REVISION=0
```
- You can edit any other information in the `.env` file to give a name to your package and put some description, dependencies that will be automatically installed if missing.
Example of dependencies (with minimum version if needed):
```
PKGDEPENDS="apt-transport-https, ca-certificates, curl, software-properties-common, kazam (>= 1.4.5)"
```
- Place any file to distribute in the `package` directory. THey will be copied to the `/opt/package-name/` directory preserving the structure.
- Update the `./install.sh` with any installation script
- Then run `./build.sh`

This will generate `replace-me_1.0-0.deb`.

To install:
- `sudo dpkg -i replace-me_1.0-0.deb`  

Enjoy!