set -e

export OSMOSISD_NODE="http://localhost:26657"
CHAIN_ID="testing"
# validator1, osmo1nfehl7autn8lkq8ltufh696nq73hxjh5u54x4v
V1="--keyring-backend test --home=$HOME/.osmosisd/validator1 --from validator1 --chain-id testing --yes --broadcast-mode block"

osmosisd tx gamm create-pool $V1 --pool-file pool_file.json --chain-id $CHAIN_ID
# osmosisd q tx 7A9CA1B3B3DAB08B53122B81F1E9FB29637412087D0BF636BA499B6CECAE7B0C
# osmosisd q gamm pools

osmosisd tx gamm join-pool --pool-id 1 --max-amounts-in=100stake --max-amounts-in=100uosmo --share-amount-out=100 $V1
# osmosisd q tx FE0D837D2A16B91E3835AF1B66429A32B812AB1172C26C9C5AFF1216F1F897B7
# osmosisd q gamm pool 1



osmosisd tx gamm join-swap-extern-amount-in 1uosmo 387035722592697287 --pool-id 1 $V1
# osmosisd q gamm pool 1


osmosisd tx lockup lock-tokens 100gamm/pool/1 --duration 24h $V1
# osmosisd q tx 94A6B88CE29B80339D3BA71F6CB379A3C6F64922CF18151B75EEF7AB8EE1D1BA <- period_lock_id 1

osmosisd q lockup lock-by-id 1

# end the lockup from 1 day to 7 days
osmosisd tx lockup extend-lockup-by-id 1 --duration 168h $V1

# now lets unbond this lockup

# TODO: does this berak after we cancel the first time? looks like It may require an extend first THEN it can begin unlock correctly.
osmosisd tx lockup begin-unlock-by-id 1 $V1
# osmosisd q lockup lock-by-id 1 # < now has an end time, lets try and cancel it

# cancel the lockup by id
osmosisd tx lockup cancel-unlock-by-id 1 $V1

osmosisd q lockup lock-by-id 1