#!/bin/bash

set -euox pipefail

sudo chown -R steam:steam $HOME
$HOME/start_server.sh
