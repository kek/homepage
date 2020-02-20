#!/bin/sh

cp ~/prod.secret.exs config
mix deps.get
MIX_ENV=prod mix release
