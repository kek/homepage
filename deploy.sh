#!/bin/sh

ssh pi@pablo.local "git clone https://github.com/kek/rpi-elixir-cluster rpi; cd rpi; git status; git checkout -- .; git pull; sh build.sh; rsync -r _build/prod/rel/hello/* ~/hello"
