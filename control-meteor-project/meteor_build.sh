#!/bin/sh
PATHM=$1
PATHN=$2

if ! [ -d $PATHN ]; then
	echo 'created directory'
	mkdir $PATHN
fi
if [ -d $PATHN/bundle ]; then
	cd $PATHN/bundle && rm -rf [!./start.sh]* server star.json
fi
cd $PATHM
export LC_ALL=C
meteor build bundle
cd ./bundle
mv * bundle.tar.gz
cp -a bundle.tar.gz $PATHN/
cd ../ && rm -r bundle
cd $PATHN && tar -xzf bundle.tar.gz
cd ./bundle/programs/server && sudo npm install
npm install
rm $PATHN/bundle.tar.gz
