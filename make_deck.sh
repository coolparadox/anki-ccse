#!/usr/bin/env bash
set -euo pipefail

fail() {
    echo "$*" >&2
    exit 1
}

declare ID
declare -a Q
declare -a A
declare -a B
declare -a C
while read CONTEXT CONTENT ; do
    [[ "$CONTEXT" =~ ^[[:digit:]]+$ ]] && {
        ID=$CONTEXT
        Q[$ID]=$CONTENT
        continue
    }
    case "$CONTEXT" in
        'a)') A[$ID]=$CONTENT ;;
        'b)') B[$ID]=$CONTENT ;;
        'c)') C[$ID]=$CONTENT ;;
        *) fail "invalid input: $CONTEXT"
    esac
done
NQ=${#Q[@]}
test ${#A[@]} -eq $NQ || fail "missing A option(s)"
test ${#B[@]} -eq $NQ || fail "missing B option(s)"
test ${#C[@]} -eq $NQ || fail "missing C option(s)"

exit 1
