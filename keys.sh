#!/bin/bash

users=$@

for var in $users
do
  echo "user: $var"
  private_key=$(wg genkey)
  public_key=$(echo "${private_key}" | wg pubkey)
  encrypted_private_key=$(ansible-vault encrypt_string $private_key --vault-password-file=.vault_pass)
  echo "encrypted_private_key = $encrypted_private_key"
  echo "public_key = $public_key"
  echo "------"
done
