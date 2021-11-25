#!/bin/bash

#set -x

number_keys=${1:-"1"} # Number of keys
pass_path=${2:-".vault_pass"} # Path to vault password file
INDEX=0

while [ $INDEX -lt $number_keys ]
do
  private_key=$(wg genkey)
  public_key=$(echo "${private_key}" | wg pubkey)
  encrypted_private_key=$(ansible-vault encrypt_string $private_key --vault-password-file=$pass_path)
  echo "private_key = $encrypted_private_key"
  echo "public_key = $public_key"
  echo "------"
  INDEX=$(($INDEX+1))
done
