#!/bin/sh

version=22.0.7
sudo apt-get update
sudo apt-get install wget
sudo apt-get install libssl-dev
sudo apt-get install ncurses-dev
wget http://www.erlang.org/download/otp_src_${version}.tar.gz
tar -xzvf otp_src_${version}.tar.gz
cd otp_src_${version}/ || exit
./configure
make
sudo make install
cd ..
rm otp_src_${version}.tar.gz
