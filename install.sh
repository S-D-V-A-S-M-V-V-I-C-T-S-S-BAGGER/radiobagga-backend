#!/bin/bash

echo "Resolving dependencies..."

git clone https://github.com/markondej/fm_transmitter ./remove_me_later
cd remove_me_later || echo "Error while cloning repository, please check your git install"

echo "Building dependencies..."
make
mv ./fm_transmitter ../fm_transmitter
cd ../
rm -r ./remove_me_later

echo "Installing gem bundle"

bundle install --deployment

echo "============================="
echo "BE SURE TO POPULATE .ENV FILE"
echo "============================="

cp .env.example .env
