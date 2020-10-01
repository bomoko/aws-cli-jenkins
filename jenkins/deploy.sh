#!/bin/sh
cd /app

echo "deploy instructions live in this file"

sam deploy --no-confirm-changeset
