#!/bin/sh

git clone https://github.com/elixir-lang/elixir
cd elixir
make clean test

# mix local.hex
# mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
