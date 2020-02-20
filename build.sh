#!/bin/sh

cp ~/prod.secret.exs config
MIX_ENV=prod mix release
