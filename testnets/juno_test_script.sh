KEY="mykey" # juno1hj5fveer5cjtn4wd6wstzugjfdxzl0xps73ftl
CHAINID="test-1"
MONIKER="localtestnet"
KEYALGO="secp256k1"
KEYRING="test"
LOGLEVEL="info"
# to trace evm
#TRACE="--trace"
TRACE=""

junod config keyring-backend $KEYRING
junod config chain-id $CHAINID
junod config node tcp://0.0.0.0:26658

# validate dependencies are installed
command -v jq > /dev/null 2>&1 || { echo >&2 "jq not installed. More info: https://stedolan.github.io/jq/download/"; exit 1; }

from_scratch () {
  # remove existing daemon
  rm -rf ~/.juno* 

  # if $KEY exists it should be deleted
  # decorate bright ozone fork gallery riot bus exhaust worth way bone indoor calm squirrel merry zero scheme cotton until shop any excess stage laundry
  # juno1hj5fveer5cjtn4wd6wstzugjfdxzl0xps73ftl
  echo "decorate bright ozone fork gallery riot bus exhaust worth way bone indoor calm squirrel merry zero scheme cotton until shop any excess stage laundry" | junod keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO --recover
  # Set moniker and chain-id for Craft
  junod init $MONIKER --chain-id $CHAINID 

  # Function updates the config based on a jq argument as a string
  update_test_genesis () {
    # update_test_genesis '.consensus_params["block"]["max_gas"]="100000000"'
    cat $HOME/.junod/config/genesis.json | jq "$1" > $HOME/.junod/config/tmp_genesis.json && mv $HOME/.junod/config/tmp_genesis.json $HOME/.junod/config/genesis.json
  }

  # Set gas limit in genesis
  update_test_genesis '.consensus_params["block"]["max_gas"]="100000000"'
  update_test_genesis '.app_state["gov"]["voting_params"]["voting_period"]="15s"'

  # # Change chain options to use EXP as the staking denom for craft
  # update_test_genesis '.app_state["staking"]["params"]["bond_denom"]="ujuno"'
  # update_test_genesis '.app_state["bank"]["params"]["send_enabled"]=[{"denom": "uexp","enabled": true}]'
  # update_test_genesis '.app_state["staking"]["params"]["min_commission_rate"]="0.050000000000000000"'

  # # update from token -> ucraft
  # update_test_genesis '.app_state["mint"]["params"]["mint_denom"]="ujuno"'
  # update_test_genesis '.app_state["exp"]["params"]["ibc_asset_denom"]="ucraft"'
  # update_test_genesis '.app_state["gov"]["deposit_params"]["min_deposit"]=[{"denom": "ujuno","amount": "10000000"}]'
  # update_test_genesis '.app_state["crisis"]["constant_fee"]={"denom": "ujuno","amount": "1000"}'


  # Allocate genesis accounts (cosmos formatted addresses)
  # 1 million EXP
  junod add-genesis-account $KEY 1000000000000stake --keyring-backend $KEYRING
  
  # Adds token to reece
  junod add-genesis-account juno10r39fueph9fq7a6lgswu4zdsg8t3gxlq670lt0 1000000000000stake --keyring-backend $KEYRING  
  
  # Sign genesis transaction
  junod gentx $KEY 1000000000000stake --keyring-backend $KEYRING --chain-id $CHAINID

  # Collect genesis tx
  junod collect-gentxs

  # Run this to ensure everything worked and that the genesis file is setup correctly
  junod validate-genesis
}

from_scratch


if [[ $1 == "pending" ]]; then
  echo "pending mode is on, please wait for the first block committed."
fi

# Opens the RPC endpoint to outside connections
sed -i 's/laddr = "tcp:\/\/0.0.0.0:26656"/laddr = "tcp:\/\/0.0.0.0:26655"/g' ~/.juno/config/config.toml # p2p
sed -i 's/laddr = "tcp:\/\/127.0.0.1:26657"/laddr = "tcp:\/\/0.0.0.0:26658"/g' ~/.juno/config/config.toml # rpc

sed -i 's/cors_allowed_origins = \[\]/cors_allowed_origins = \["\*"\]/g' ~/.juno/config/config.toml
sed -i 's/pprof_laddr = "localhost:6060"/pprof_laddr = "localhost:6080"/g' ~/.juno/config/config.toml

sed -i 's/address = "0.0.0.0:9090"/address = "0.0.0.0:9092"/g' ~/.juno/config/app.toml # all grpc 
sed -i 's/address = "0.0.0.0:9091"/address = "0.0.0.0:9093"/g' ~/.juno/config/app.toml # just the first one 

# # Start the node (remove the --pruning=nothing flag if historical queries are not needed)
junod start --pruning=nothing  --minimum-gas-prices=0stake #--mode validator       

