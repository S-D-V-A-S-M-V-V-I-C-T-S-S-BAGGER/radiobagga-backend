#!/bin/bash

echo "Resolving dependencies..."

FILE=/usr/bin/sox
if test -f "$FILE"; then
    echo "SoX already installed, moving on..."
else
    sudo apt update
    sudo apt install sox libsox-fmt-mp3 libsndfile1-dev -y
fi

git clone https://github.com/ChristopheJacquet/PiFmRds.git ./temp_clone
cd temp_clone/src || echo "Error while cloning repository, please check your git install"

echo "Building dependencies..."
make clean
make
mv ./pi_fm_rds ../../pi_fm_rds
cd ../../
rm -rf ./temp_clone

echo "Installing gem bundle"

bundle install --deployment

echo "============================="
echo "BE SURE TO POPULATE .ENV FILE"
echo "============================="

cp .env.example .env
mkdir uploads
