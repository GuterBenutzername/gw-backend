#!/usr/bin/env bash
# The purpose of this script is to ensure a pure docker compose environment a la nix without having to run three commands everytime
docker compose up
docker compose down
docker compose rm
