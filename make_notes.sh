#!/usr/bin/env bash
set -euo pipefail

ME=$( basename "$0" )

fail() {
    echo "$ME: error: $*" >&2
    exit 1
}

log() {
    return 0
    echo "$ME: $*" >&2
}

test $# -gt 0 || {
    # Just output notes header
    cat <<__eod__
#separator:tab
#html:true
#notetype column:1
#deck column:2
#tags column:11
__eod__
    exit 0
}

# Produce notes for a section
SECTION=$1
QUESTIONS_PATH="${SECTION}.questions"
ANSWERS_PATH="${SECTION}.answers"

# Parse section questions
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
NQ=${#QT[@]}  # Amount of questions
log "$NQ questions found"
test $NQ -gt 0 || fail "no questions found"

# Parse section answers
declare -a ANS  # all answers
while read ID OPTION ; do
    set +u ; test -n "${QT[$ID]}" || fail "missing question for answer $ID"
    set -u
    case "$OPTION" in
        'a') test -n "${QA[$ID]}" || fail "missing option (a) in question $ID" ;;
        'b') test -n "${QB[$ID]}" || fail "missing option (b) in question $ID" ;;
        'c') test -n "${QC[$ID]}" || fail "missing option (c) in question $ID" ;;
        *) fail "unknown answer '$OPTION' for question $ID" ;;
    esac
    ANS[$ID]=$OPTION
done <<<$( tr -d '\n' <$ANSWERS_PATH | sed -E -e 's|([[:alpha:]])([[:digit:]])|\1\n\2|g' -e '$a\' )
NA=${#ANS[@]}  # Amount of answers
log "$NA answers found"
test $NA -eq $NQ || fail "Mismatching amount of questions ($NQ) and answers ($NA)"
for ID in ${!QT[@]} ; do
    set +u ; test -n "${ANS[$ID]}" || fail "missing answer for question $ID"
    set -u
done

# Generate Anki notes for section.
echo_column_back_option() {
    local OPTION_LETTER=$1
    local OPTION_TEXT=$2
    local CORRECT_OPTION=$3
    echo -en "\t"
    test -n "$OPTION_TEXT" || return 0
    echo -n '"'
    echo -n '<div class=""'
    if test "$OPTION_LETTER" = "$CORRECT_OPTION" ; then
        echo -n 'yes'
    else
        echo -n 'no'
    fi
    echo -n '"">'
    echo -n $OPTION_TEXT
    echo -n '</div>'
    echo -n '"'
}
for ID in ${!QT[@]} ; do
    echo -n 'choice_abc'
    echo -en '\tccse'
    echo -en "\t${ID}"
    echo -en "\t${QT[$ID]}"
    echo -en "\t${QA[$ID]}"
    echo -en "\t${QB[$ID]}"
    echo -en "\t${QC[$ID]}"
    echo_column_back_option 'a' "${QA[$ID]}" "${ANS[$ID]}"
    echo_column_back_option 'b' "${QB[$ID]}" "${ANS[$ID]}"
    echo_column_back_option 'c' "${QC[$ID]}" "${ANS[$ID]}"
    echo -en "\t${SECTION}"
    echo
done

