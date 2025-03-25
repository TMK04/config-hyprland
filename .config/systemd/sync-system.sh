#!/bin/sh

sudo cp -r /home/floer/.config/systemd/system/* '/usr/local/lib/systemd/system/'
sudo systemctl daemon-reload
