#!/bin/bash

# Setup flare directory
sudo mkdir -p /opt/flare
sudo chown -R $USER:$USER /opt/flare

# Download required scripts
wget -c -O /opt/flare/ https://raw.githubusercontent.com/vahid-dan/flare-push-test/source/flare-config.yml
wget -c -O /opt/flare/ https://raw.githubusercontent.com/vahid-dan/flare-push-test/source/flare-host.sh
wget -c -O /opt/flare/ https://raw.githubusercontent.com/vahid-dan/flare-push-test/source/flare-container.sh
