#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from https://github.com/scala/scala/releases"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/scala-$VERSION
JAVA_PREFIX=/opt/wandbox/openjdk-jdk8u121-b13/jvm/openjdk-1.8.0-internal

# get sources

cd ~/
git clone --depth 1 --branch v$VERSION https://github.com/scala/scala.git
cd scala

# build

~/sbt compile
~/sbt dist/mkPack

rm -r $PREFIX || true
if compare_version "$VERSION" "<" "2.12.0"; then
  cp -r build-sbt/pack $PREFIX
else
  cp -r build/pack $PREFIX
fi

cp $BASE_DIR/resources/run-scalac.sh.in $PREFIX/bin/run-scalac.sh
sed -i "s#@java_prefix@#$JAVA_PREFIX#g" $PREFIX/bin/run-scalac.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-scalac.sh
chmod +x $PREFIX/bin/run-scalac.sh

cp $BASE_DIR/resources/run-scala.sh.in $PREFIX/bin/run-scala.sh
sed -i "s#@java_prefix@#$JAVA_PREFIX#g" $PREFIX/bin/run-scala.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-scala.sh
chmod +x $PREFIX/bin/run-scala.sh

rm -r ~/scala
