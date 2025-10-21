#!/bin/bash

set -e

echo "Restowing all config packages..."

cd config

# Read packages from YAML configuration and restow each one
for package in $(yq eval '.packages | keys | .[]' ../stow-packages.yml); do
    target_path=$(eval echo $(yq eval ".packages.${package}.target" ../stow-packages.yml))
    echo "Restowing $package -> $target_path"
    stow -t "$target_path" -R "$package"
done

echo "Done!"