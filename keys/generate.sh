#!/bin/bash

TF="keys.tf"
echo "" > "$TF"
NUM=${1:-10}

append() {
    echo "$1" >> "$TF"
}

provider() {
    append 'terraform {'
    append '  required_providers {'
    append '    aws = {'
    append '      source  = "hashicorp/aws"'
    append '      version = "~> 3.0"'
    append '    }'
    append '  }'
    append '}'
    append ''


    append 'provider "aws" {'
    append '  region = "eu-central-1"'
    append '}'
    append ''
}

ansible_helper() {
    local sshconf="sshconfig"
    local inv="inventory"

    echo '[all:vars]' >> $inv
    echo 'ansible_user=ubuntu' >> $inv
    echo 'ansible_become=false' >> $inv
    echo 'ansible_ssh_args=-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -F sshconfig' >> $inv
    echo '' >> $inv
    echo '[all]' >> $inv
    echo "training[1:${NUM}].cc-openshift.de"  >> $inv

    for i in $(seq 1 $NUM); do
        echo "Host training${i}.cc-openshift.de" >> $sshconf
        echo "  IdentityFile training${i}" >> $sshconf
        echo "" >> $sshconf
    done
}

add_key() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Invalid parameter" > /dev/stderr
        exit 5
    fi
    PUB_KEY="${2}"

    append "resource \"aws_key_pair\" \"public-key-$1\" {"
    append "  key_name = \"training-$1\""
    append "  public_key = \"${PUB_KEY}\""
    append '}'
    append ''
}

provider

HOST_KEY=$(cat "$HOME/.ssh/id_rsa.pub")
add_key "0" "$HOST_KEY"

for i in $(seq 1 $NUM); do
    FILENAME="training$i"
    if [[ ! -f "${FILENAME}" ]]; then
        echo "Generate key $i to file: '${FILENAME}'"
        ssh-keygen -t rsa -b 4096 -C "Heinlein Training ${i}" -P '' -f "${FILENAME}" > /dev/null
    else
        echo "Key ${FILENAME} already exists"
    fi
    
    PUB_KEY=$(cat "training${i}.pub")
    add_key "$i" "${PUB_KEY}" 
done

ansible_helper

terraform init

terraform_return=-1
if [[ $? -eq 0 ]]; then
    terraform apply
fi

exit $?
