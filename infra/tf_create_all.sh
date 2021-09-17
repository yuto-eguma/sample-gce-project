#!/usr/bin/env bash

set -eu

TF_CMD=$1
ENV=$2
TF_ARGS=${@:3}

# ./tf.sh $TF_CMD $ENV module/dir $TF_ARGS