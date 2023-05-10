#!/bin/bash

mkdir -p tests/keyfile
openssl rand -base64 756 > tests/keyfile/keyfile