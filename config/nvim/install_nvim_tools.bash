#!/bin/bash

if ! which nvim > /dev/null
then
	echo "Error: nvim not found."
	exit 1
fi

sudo apt-get install -y npm

sudo npm install n -g

sudo n stable
