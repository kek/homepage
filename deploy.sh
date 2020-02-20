#!/bin/sh

ssh pi@pablo.local "git clone https://github.com/kek/rpi-elixir-cluster rpi; cd rpi; git pull; sh build.sh"

