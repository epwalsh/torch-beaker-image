#!/bin/sh

# Exit script if any commands fail.
set -e

if [ -z "$CONFIG" ]; then
    echo >&2 'error: missing CONFIG environment variable'
    exit 1
fi

if [ -z "$OVERRIDES" ]; then
    OVERRIDES='{}'
else
    echo "Using overrides ${OVERRIDES}"
fi

if [ ! -z "$PIP_EXTRAS" ]; then
    pip install --upgrade --no-cache-dir $PIP_EXTRAS
    pip uninstall -y dataclasses
fi

pip freeze

# allennlp test-install
allennlp train $CONFIG -s /output --file-friendly-logging --overrides $OVERRIDES
