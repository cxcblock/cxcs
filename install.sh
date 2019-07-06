#!/bin/bash


basepath=$(cd `dirname $0`; pwd)

cd $basepath

if [ "$(uname)" == "Linux" ]  && [ "$(uname -m)" == 'x86_64' ]; then

	if [ -d "/usr/lib64" ];then
		sudo cp -rf Linux/lib/* /usr/lib64/
	fi

	if [ -d "/usr/lib" ];then
		sudo cp -rf Linux/lib/* /usr/lib/
	fi

	sudo chmod +x Linux/cxcsi
	sudo chmod +x Linux/cxcsz
	sudo cp -f Linux/{cxcsi,cxcsz} /usr/local/bin/

	if [ -f "/usr/lib/libboost_system.so.1.54.0" ]; then

	echo "Install  for linux successful."

	else

	echo "Install  for linux fail."
    
    fi
elif [ "$(uname)" == "Darwin" ]; then

	sudo cp -f MacOs/{cxcsz,cxcsi} /usr/local/bin/

	sudo chmod +x /usr/local/bin/cxcsz
	sudo chmod +x /usr/local/bin/cxcsi

	if [ -f "/usr/local/bin/cxcsz" ] && [ -f "/usr/local/bin/cxcsi" ]; then

	echo "Install for macosx successful."

	else

	echo "Install for macosx fail."

	fi
else

	echo "cxc does not support your system."

fi

