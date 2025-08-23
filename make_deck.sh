#!/usr/bin/env bash
set -euo pipefail

ME=$( basename "$0" )

fail() {
    echo "$ME: error: $*" >&2
    exit 1
}

log() {
    echo "$ME: $*" >&2
}

test $# -gt 0 || fail "missing seed"
SEED=$1

QUESTIONS_PATH="${SEED}.questions"
ANSWERS_PATH="${SEED}.answers"

declare ID  # question / answer identification
declare -a QT  # all question texts
declare -a QA  # all question options a)
declare -a QB  # all question options b)
declare -a QC  # all question options c)
while read CONTEXT CONTENT ; do
    [[ "$CONTEXT" =~ ^[[:digit:]]+$ ]] && {
        ID=$CONTEXT
        test -n "$CONTENT" || fail "missing text of question $ID"
        QT[$ID]=$CONTENT
        QA[$ID]=""
        QB[$ID]=""
        QC[$ID]=""
        continue
    }
    case "$CONTEXT" in
        'a)') QA[$ID]=$CONTENT ;;
        'b)') QB[$ID]=$CONTENT ;;
        'c)') QC[$ID]=$CONTENT ;;
        *) fail "invalid input: $CONTEXT"
    esac
done <$QUESTIONS_PATH
NQ=${#QT[@]}
log "$NQ questions found"
test $NQ -gt 0 || fail "no questions found"

declare -a ANS  # all answers
while read ID OPTION ; do
    set +u ; test -n "${QT[$ID]}" || fail "missing question for answer $ID"
    set -u
    case "$OPTION" in
        'a') test -n "${QA[$ID]}" || fail "missing text for option (a) in question $ID" ;;
        'b') test -n "${QB[$ID]}" || fail "missing text for option (b) in question $ID" ;;
        'c') test -n "${QC[$ID]}" || fail "missing text for option (c) in question $ID" ;;
        *) fail "unknown answer '$OPTION' for question $ID" ;;
    esac
    ANS[$ID]=$OPTION
done <<<$( tr -d '\n' <$ANSWERS_PATH | sed -E -e 's|([[:alpha:]])([[:digit:]])|\1\n\2|g' -e '$a\' )

