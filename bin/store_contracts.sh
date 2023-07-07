#!/bin/bash

RPC_NODE="https://rpc-testnet-archway.ezstaking.dev:443"
CHAIN_ID="constantine-3"
GAS_PRICES=$(archwayd q rewards estimate-fees 1 --node ${RPC_NODE} --output json | jq -r '.gas_unit_price | (.amount + .denom)')
DETAILS="--from EZStaking --instantiate-everybody true --gas auto --gas-adjustment 1.4 --gas-prices ${GAS_PRICES} -b block --keyring-backend test --chain-id ${CHAIN_ID} -y --node ${RPC_NODE}"
CONTRACTS=(
  'cw20_base_standard'
  'cw20_base_burnable'
  'cw20_base_mintable'
  'cw20_base_common'
  'cw20_base_unlimited'
)
CONTRACTS_DIR=(
  'cw20-base-standard'
  'cw20-base-burnable'
  'cw20-base-mintable'
  'cw20-base-common'
  'cw20-base-unlimited'
)

FILE='code_id'
TMP_FILE='upload_contract.tmp'

echo '' > "${FILE}"
for i in ${!CONTRACTS[@]};
do
  CONTRACT=${CONTRACTS[$i]}
  CONTRACT_DIR=${CONTRACTS_DIR[$i]}

  echo "${CONTRACT_DIR}"
  cd "${CONTRACT_DIR}"

  # Run
  OUTPUT=$(cp ../../artifacts/${CONTRACT}.wasm . && archwayd tx wasm store ${CONTRACT}.wasm ${DETAILS})
  echo $OUTPUT

  # Grep
  echo ${OUTPUT} > "../${TMP_FILE}"
  VALUES=$(grep -Po '"value": *\K"[^"]*"' "../${TMP_FILE}")
  echo ${VALUES}

  # Populate file
  echo ${CONTRACT_DIR} >> "../${FILE}"
  echo ${VALUES} >> "../${FILE}"
  echo '' >> "../${FILE}"

  cd ../
done

rm "${TMP_FILE}"
