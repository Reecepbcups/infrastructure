# https://github.com/osmosis-labs/osmosis/pull/2974

OSMOSISD_NODE="https://osmosis-rpc.lavenderfive.com:443"

# test account - osmo1hj5fveer5cjtn4wd6wstzugjfdxzl0xpwhpz63. DO NOT PUT MAJOR FUNDS HERE
echo "decorate bright ozone fork gallery riot bus exhaust worth way bone indoor calm squirrel merry zero scheme cotton until shop any excess stage laundry" | osmosisd keys add osmotest --keyring-backend test --algo "secp256k1" --recover


# (Keplr) Custom
# type: osmosis/gamm/join-swap-extern-amount-in
# value:
#   sender: osmo1hj5fveer5cjtn4wd6wstzugjfdxzl0xpwhpz63
#   pool_id: '1'
#   token_in:
#     denom: uosmo
#     amount: '500000'
#   share_out_min_amount: '1935318805590864473'
osmosisd tx gamm join-swap-extern-amount-in 100000uosmo 387035722592697287 --pool-id 1 --from osmotest --keyring-backend test --chain-id osmosis-1
# osmosisd q tx 125D45810E4298A007103849DCF1EE007E8E3A8151ABCA1BFAEC3D47AFA7B992


# type: osmosis/lockup/lock-tokens
# value:
#   owner: osmo1hj5fveer5cjtn4wd6wstzugjfdxzl0xpwhpz63
#   duration: '86400000000000'
#   coins:
#     - amount: '100000000000000000' # 0.1gamm-1 tokens
#       denom: gamm/pool/1

osmosisd tx lockup lock-tokens 1000000000000000000gamm/pool/1 --duration 24h --from osmotest --keyring-backend test --chain-id osmosis-1
# osmosisd q tx 57027B480F9B2E2306F4511AC9A992022FFB3AED1991596F6835FB13B30756D2 <- period_lock_id 1513271
# osmosisd q tx BD4A3A7D7EEEEB85E1028F82C7EE039B4E014D202E16CACB036A827C0EE80918 <- period_lock_id 1513275


# osmosisd q lockup lock-by-id 1513271 # old lock to test 
osmosisd q lockup lock-by-id 1513275
# lock:
#   ID: "1513275"
#   coins:
#   - amount: "1000000000000000000"
#     denom: gamm/pool/1
#   duration: 86400s
#   end_time: "0001-01-01T00:00:00Z"
#   owner: osmo1hj5fveer5cjtn4wd6wstzugjfdxzl0xpwhpz63

# lockup some id, then extend it - 24h, 168h, 336h
osmosisd tx lockup extend-lockup-by-id 1513275 --duration 168h --from osmotest --keyring-backend test --chain-id osmosis-1
# osmosisd q tx E37E9E4FF193EBF69154E05A473B3399EAC5066AB9295AB1FF3756CF3A7F158D # from 168h -> 168h [fails correctly], tested on 1513271
# osmosisd q tx CCAEB24DA38B238F838257AE46FAD9F1B0B1CC8EA4D7C8DB6C66D63926460712 # from 24h -> 168h

osmosisd q lockup lock-by-id 1513275
# lock:
#   ID: "1513275"
#   coins:
#   - amount: "1000000000000000000"
#     denom: gamm/pool/1
#   duration: 604800s
#   end_time: "0001-01-01T00:00:00Z"
#   owner: osmo1hj5fveer5cjtn4wd6wstzugjfdxzl0xpwhpz63
# lock increased successfully!

# osmosis exit pool by lock id
osmosisd tx lockup unlock-by-id 1513271 --from osmotest --keyring-backend test --chain-id osmosis-1
# osmosisd q tx CB599B3B444D5061F2E7F4198B2A26988A14B041F8CD768919F00989DF849914 # unlocks 168h lock

# no, after the unbond we nmeed to allow ourselfs to rebond to the pool for a given time