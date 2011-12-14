#!/bin/sh

# Install dependencies
sudo apt-get install git libssl-dev libcairo2-dev libgif-dev libjpeg8-dev optipng pngcrush pngquant

# Install Node.js v0.4
cd ~
git clone git://github.com/joyent/node
cd node
git checkout v0.6
make distclean # Only necessary if you've compiled from the same checkout before
mkdir ~/.local # If it doesn't already exist
./configure --prefix=~/.local
make
make install

# Set up path for locally installed node modules
export PATH=~/.local/bin:${PATH}
# Optionally
# echo "export PATH=~/.local/bin:$PATH" >> ~/.bashrc
