### check for newer scripts in 
> https://github.com/notional-labs/craft/tree/master/networks


- craftd init (local)
- use add-genesis-account.py
  - edit resetGenesisFile() and CUSTOM_GENESIS_ACCOUNT_VALUES (balances)
  - check the genesis matches in your $HOME/.craftd/config/genesis.json

Begin testnet gentxs (min of 2 public machines required)
```bash
git pull git@github.com:notional-labs/craft.git
cd craft
make install # go install ./...
craftd version # ensure it works, if not fix $HOME/go/bin path

# gentx with the 'Genesis Tx' section
# get the node id@ip:port (for p2p)
```

OPTIONS:
- If you have only the json strings, put in create_gentxs_from_strings.py
- else: put the JSON files in a 'gentx' folder in this directory.

Run add-genesis-accounts.py again
craftd collect-gentxs --gentx-dir gentx/
craftd validate-genesis

if valid, put that genesis file on both machines in .craft/config/genesis.json

craftd start --p2p.persistent_peers <id>@65.109.000.000:26656
