#!/bin/bash

[[ -n "$DEBUG" ]] && set -eox

PUBLICSERVER=${PUBLICSERVER:-"true"}
DESCRIPTION=${DESCRIPTION:-"ECO Game Server on Kubernetes"}
SERVERCATEGORY=${SERVERCATEGORY:="None"}
DATADIR=${DATADIR:="/data"}

mkdir -p $DATADIR/{Configs,Storage}

ln -s $DATADIR/Configs /ecoserver/Configs
ln -s $DATADIR/Storage /ecoserver/Storage

# Check if there's an existing Config, if not, copy over the defaults.
echo "--> Checking for existing Configuration Settings"
if [[ "$(find "$DATADIR/Configs" -name "*.eco" | wc -l 2>/dev/null)" -eq "0" ]]; then
  echo "====> Using default config settings"
  cp /ecoserver/Configs.default/* $DATADIR/Configs/

  echo "--> Process environment settings"
  if [[ -n "$WORLD_SIZE_X" ]]; then
    echo "====> Setting World Size X to $WORLD_SIZE_X"
    cat $DATADIR/Configs/WorldGenerator.eco | jq ".Dimensions.x=$WORLD_SIZE_X" | sponge $DATADIR/Configs/WorldGenerator.eco
  fi

  if [[ -n "$WORLD_SIZE_Y" ]]; then
    echo "====> Setting World Size Y to $WORLD_SIZE_Y"
    cat $DATADIR/Configs/WorldGenerator.eco | jq ".Dimensions.y=$WORLD_SIZE_Y" | sponge $DATADIR/Configs/WorldGenerator.eco
  fi

  if [[ -n "$METEOR_IMPACT_DAYS" ]]; then
    echo "====> Setting Days to Meteor Impact to $METEOR_IMPACT_DAYS"
    cat $DATADIR/Configs/Disasters.eco | jq ".MeteorImpactDays=$METEOR_IMPACT_DAYS" | sponge $DATADIR/Configs/Disasters.eco
  fi
else
  echo "====> Using existing Config Settings"
fi

# Check if there's a Network Config
if [[ ! -e $DATADIR/Configs/Network.eco ]]; then
  echo "--> Creating Network Configuration"
  cat << EOF > $DATADIR/Configs/Network.eco
{
  "PublicServer": $PUBLICSERVER,
  "GameServerPort": 3000,
  "WebServerPort": 3001,
  "UPnPEnabled": false,
  "DetectNAT": false,
  "Description": "$DESCRIPTION",
  "ServerCategory": "$SERVERCATEGORY",
  "IPAddress": "Any",
  "Rate": 20,
  "MaxConnections": -1,
  "ID": "$(uuidgen)",
  "Passport": "$(uuidgen)"
}
EOF
fi

# Check if there's an existing Game state
if [[ "$(find "$DATADIR/Storage" -name "Game.*" | wc -l 2>/dev/null)" -eq "0" ]]; then
  echo "--> No existing game state. This will create a new game."
fi

echo "--> Launching Eco Server"
mono /ecoserver/EcoServer.exe -nogui