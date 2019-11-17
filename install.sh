#!/bin/bash

$CURRENT_DIR='`pwd`'

if [ -f $CURRENT_DIR/fm_transmitter]; then
  echo ""
else
  echo "Resolving dependencies..."

  echo `git clone https://github.com/markondej/fm_transmitter`
  cd fm_transmitter

  echo "Building dependencies..."
  echo `make`
  cd ../
fi

echo "Installing gem bundle"

echo `bundle install --deployment`
