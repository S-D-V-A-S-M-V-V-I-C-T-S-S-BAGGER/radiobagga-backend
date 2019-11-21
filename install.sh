#!/bin/bash

echo "Resolving dependencies..."

FILE=/usr/bin/sox
if test -f "$FILE"; then
    echo "SoX already installed, moving on..."
else
    sudo apt update
    sudo apt install sox -y
fi

git clone https://github.com/markondej/fm_transmitter ./temp_clone
cd temp_clone || echo "Error while cloning repository, please check your git install"

echo "Building dependencies..."
make
mv ./fm_transmitter ../fm_transmitter
cd ../
rm -rf ./temp_clone

echo "Installing gem bundle"

bundle install --deployment

echo "============================="
echo "BE SURE TO POPULATE .ENV FILE"
echo "============================="

cp .env.example .env
mkdir uploads
