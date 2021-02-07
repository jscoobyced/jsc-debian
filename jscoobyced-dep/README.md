# JScoobyCed Debian dependencies #

This is a meta-package with the dependencies I usually install on a new machine
To build the debian package:
- increase the revision, minor or major version in the `.env` file

```
MAJOR=1
MINOR=0
REVISION=0
```
- run `./build.sh`

This will generate `jscoobyced-dep_1.0-0.deb`.

To install:
- `sudo dpkg -i jscoobyced-dep_1.0-0.deb`  

To modify:
- Add the dependencies in the `build.sh` script (the line `Depends`)

Enjoy!