[[ "$ENABLE_PREVIEWS" = "NO" ]] || exit 0
[[ "$MAC_OS_X_VERSION_MAJOR" -ge "101500" ]] || exit 0

TMPFILE=`mktemp /tmp/SwiftUIcon.swift.XXXXXX` || exit 1
trap "rm -f $TMPFILE" EXIT

if [ -z "$SCRIPT_INPUT_FILE_0" ]
then
    echo "error: You must specify your Icon.swift as the first Input File in the Build Phase."
    exit 1
fi

cat ${SCRIPT_INPUT_FILE_0%/*}/*.swift > $TMPFILE

xcrun -sdk macosx swift $TMPFILE
