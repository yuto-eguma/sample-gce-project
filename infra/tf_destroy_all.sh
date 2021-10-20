#!/usr/bin/env bash

set -eu

TF_CMD=$1
ENV=$2
TF_ARGS=${@:3}

cat directries.txt | tail -r | while read line
do 
    echo "./tf.sh $TF_CMD $ENV $line $TF_ARGS"
done
