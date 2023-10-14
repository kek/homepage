#!/bin/sh

git clone https://github.com/elixir-lang/elixir
cd elixir
git fetch --all
git checkout master
git pull
git checkout v1.9.1
make clean test
sudo make install

# mix local.hex
# mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
