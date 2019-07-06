#!/usr/bin/env bash

# Exit if any subcommand or pipeline returns a non-zero status
set -e

cd /home

APP_NAME="$(grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g')"
APP_VSN="$(grep 'version:' mix.exs | cut -d '"' -f2)"

echo "Building $APP_NAME-$APP_VSN"
echo "OS version: $(cat /etc/redhat-release)"
echo "Erlang version: $(elixir -e "IO.puts(:erlang.system_info(:otp_release))")"
echo "Elixir version: $(elixir  -e "IO.puts(System.version)")"

export MIX_ENV=prod

# Set envars used in config/config.exs to dummy values
# (otherwise it's a compile error)
export MY_PORT=0
export MY_DB_URL=0

echo "Install updated versions of hex/rebar ..."
mix local.rebar --force
mix local.hex --if-missing --force
echo "Install updated versions of hex/rebar - ok"

echo "Fetch Elixir dependencies ..."
mix deps.get --only prod
echo "Fetch Elixir dependencies - ok"

echo "Fetch JS dependencies ..."
pushd assets; npm install; popd
echo "Fetch JS dependencies - ok"

echo "Build Elixir app ..."
mix compile --force
echo "Build Elixir app - ok"

echo "Build web assets..."
pushd assets; npm run deploy; popd
echo "Build web assets - ok"

echo "Generate cache manifest ..."
mix phx.digest
echo "Generate cache manifest - ok"

echo "Building release ..."
mix release
echo "Building release - ok"

echo "Compressing release ..."
mkdir -p /home/releases/
FILENAME="/home/releases/$APP_NAME-$APP_VSN-$(date '+%Y%m%dT%H%M%SZ').tar.gz"
# Replace above line with below for timestamps in local timezone
# FILENAME="/home/releases/$APP_NAME-$APP_VSN-$(TZ=Asia/Colombo date '+%Y%m%dT%H%M%S').tar.gz"
cd "/home/_build/prod/rel/$APP_NAME/"
tar -czf $FILENAME ./
cd /home
ls -alh $FILENAME
echo "Compressing release - ok "
echo "Release bundle saved at: $FILENAME"

exit 0
