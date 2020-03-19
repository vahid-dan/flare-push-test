#!/bin/bash

sudo mkdir -p /opt/flare
sudo chown -R $USER:$USER /opt/flare
wget -nc https://raw.githubusercontent.com/vahid-dan/flare-push-test/source/flare-config.yml /opt/flare/