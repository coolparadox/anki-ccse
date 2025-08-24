#!/usr/bin/env bash
set -euo pipefail

TARGET='ccse_notes.txt'
./make_notes.sh >$TARGET
for ANSWER_FILE in *.answers ; do
    TAG=$( basename -s '.answers' "$ANSWER_FILE" )
    echo "Processing ${TAG}..." >&2
    ./make_notes.sh $TAG >>$TARGET
done
echo "Generated: $TARGET" >&2
