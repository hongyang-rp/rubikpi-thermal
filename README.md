# install
```shell
DESTDIR=/your/custom/path make install
```
# build deb binary packages
```
fakeroot debian/rules binary
```
or
```shell
make deb
```
# build deb source packages
```shell
make source
```
