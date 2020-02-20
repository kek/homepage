#!/bin/sh

cp ~/prod.secret.exs config
mix deps.get
mix clean
MIX_ENV=prod mix release
