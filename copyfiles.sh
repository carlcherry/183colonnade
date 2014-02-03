#!/bin/bash
INSTALL_DIR=/var/www/$2
echo $INSTALL_DIR
sudo tar -zxvf $1 -C $INSTALL_DIR
