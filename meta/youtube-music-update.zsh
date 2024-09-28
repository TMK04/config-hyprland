#!/bin/zsh
set -e
source "$HOME/meta/zlanguages/nodejs.zsh"
cd "$HOME/meta/youtube-music"
pnpm install --frozen-lockfile
pnpm run clean
pnpm run build
pnpm exec electron-builder -p never --linux AppImage
mv "$(fd -t f '.*\.AppImage' 'pack/' | head -n 1)" 'pack/YTM.AppImage'
