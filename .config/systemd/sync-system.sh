#!/bin/sh

sudo cp -r /home/floer/.config/systemd/system/* /usr/lib/systemd/system/
sudo systemctl daemon-reload

for aservice in 'kmonad-all'
do
  aservice_service="${aservice}.service"
  sudo systemctl restart "${aservice}"
  foot zsh -c "journalctl -u '${aservice}' | tail; $SHELL"
done
