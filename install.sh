#!/bin/bash

$CURRENT_DIR='`pwd`'

if [ -f $CURRENT_DIR/pifm]; then
	echo ""
else
	echo "Grabbing pifm..."

	echo `wget http://omattos.com/pifm.tar.gz`
	echo `tar -xzf pifm.tar.gz`
	echo `rm pifm.tar.gz pifm.c PiFm.pyc sound.wav left_right.wav`
fi

echo "Installing bundle"

echo `bundle install --deployment`
