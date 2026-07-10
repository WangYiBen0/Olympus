#!/usr/bin/env bash

set -xeo pipefail

# Make sure we are in the right directory
cd "$(dirname "$0")"

# Reset the love directory
rm -rfv love
mkdir love

# Download and install latest Olympus as a base
cd love
wget -O macos.main.zip 'https://maddie480.ovh/celeste/download-olympus?branch=main&platform=macos'
unzip macos.main.zip
mv -v macos.main/dist.zip dist.zip
unzip dist.zip
rm -rfv macos.main dist.zip macos.main.zip olympus.love sharp
cd ..

# Build Olympus.Sharp and copy it to love
cd sharp
dotnet publish --self-contained Olympus.Sharp.sln
rm -rf ../love/Olympus.app/Contents/MacOS/sharp
cp -rv bin/Release/net8.0/osx-arm64/publish ../love/Olympus.app/Contents/MacOS/sharp
cd ..

# Copy the lua code
cd src
zip -r yes.zip *
mv -v yes.zip ../love/Olympus.app/Contents/MacOS/olympus.love
cd ..

# Run our fresh build!
cd love
open Olympus.app --stdout stdout.txt --stderr stderr.txt --args --debug
tail -f stdout.txt stderr.txt
