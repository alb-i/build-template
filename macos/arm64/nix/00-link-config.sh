#!/bin/bash

cd $(dirname $0)

mkdir -p ~/.config/nix

ln -s "$(pwd)/nix.conf" ~/.config/nix/nix.conf
