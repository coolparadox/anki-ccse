#!/usr/bin/env bash
set -euo pipefail

TARGET='ccse_notes.txt'
echo "Generating $TARGET ..."
./make_notes.sh >$TARGET
for SECTION in 1 2 3 ; do
    TAG="tarea_${SECTION}"
    ./make_notes.sh $TAG >>$TARGET
done
