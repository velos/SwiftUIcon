[[ "$ENABLE_PREVIEWS" = "NO" ]] || exit 0
[[ "$MAC_OS_X_VERSION_MAJOR" -ge "101500" ]] || exit 0

TMPFILE=`mktemp /tmp/SwiftUIcon.swift.XXXXXX` || exit 1
trap "rm -f $TMPFILE" EXIT


[[ -s "$SCRIPT_INPUT_FILE_0" ]] || {
    echo "error: You must specify your Icon.swift as the first Input File in the Build Phase."
    exit 1
}

[[ -s "$SCRIPT_OUPUT_FILE_0" ]] || {
    echo "error: You must specify your Assets file as the first Output File in the Build Phase."
    exit 1
}

HELPER=$PWD/Icon/Icon+PreviewHelpers.swift
GENERATOR=$PWD/IconGenerator/IconGenerator.swift
MAIN=$PWD/IconGenerator/main.swift

cat $SCRIPT_INPUT_FILE_0 $HELPER $GENERATOR $MAIN > $TMPFILE

xcrun -sdk macosx swift $TMPFILE
