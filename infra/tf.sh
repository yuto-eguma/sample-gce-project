#!/usr/bin/env bash

set -o pipefail
BASE_DIR=$(pwd)
TF_CMD=$1
ENV=$2
TARGET_DIR=$3
TF_ARGS=${@:4}

ENV_CONFIG=$(cat "$BASE_DIR/_terraform_config/env_variables/$ENV.json")

cd $BASE_DIR/$TARGET_DIR

echo "=========== $TARGET_DIR"

if [[ ${TF_CMD} != 'init' ]]; then
  TF_VAR_primary_env=$(echo $ENV_CONFIG | jq -r ".primary_env") \
  terraform $1 $TF_ARGS
else
  terraform providers lock -platform=darwin_amd64 -platform=linux_amd64
  # # bucket を用いる場合の init command
  # terraform init \
  #   -backend-config "key=state/$(echo ${TARGET_DIR} | sed "s/\/$//").tfstate" \
  #   -backend-config "bucket=$(echo $ENV_CONFIG | jq -r ".state_bucket")" \
  #   -backend-config "region=$(echo $ENV_CONFIG | jq -r ".default_region")"
  terraform init
  terraform workspace select "${ENV}" || terraform workspace new "${ENV}"
  terraform workspace list
fi
