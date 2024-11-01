#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export RPC_URL="http://localhost:5050";

export WORLD_ADDRESS=$(cat ./manifests/manifest_dev.json | jq -r '.world.address')

echo $WORLD_ADDRESS
 
# sozo execute --world <WORLD_ADDRESS> <CONTRACT> <ENTRYPOINT>
sozo execute --world 0x06171ed98331e849d6084bf2b3e3186a7ddf35574dd68cab4691053ee8ab69d7 dojo_starter::systems::actions::actions spawn --wait
