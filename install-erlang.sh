#!/bin/sh
sudo apt-get update
sudo apt-get install wget
sudo apt-get install libssl-dev
sudo apt-get install ncurses-dev
wget http://www.erlang.org/download/otp_src_20.0.tar.gz
tar -xzvf otp_src_20.0.tar.gz
cd otp_src_20.0/
./configure
make
sudo make install
cd ..
rm otp_src_20.0.tar.gz
