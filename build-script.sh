[[ "$ENABLE_PREVIEWS" = "NO" ]] || exit 0
[[ "$MAC_OS_X_VERSION_MAJOR" -ge "101500" ]] || exit 0

TMPFILE=`mktemp /tmp/SwiftUIcon.swift.XXXXXX` || exit 1
trap "rm -f $TMPFILE" EXIT


[[ -s "$SCRIPT_INPUT_FILE_0" ]] || {
    echo "error: You must specify your Icon.swift as the first Input File in the Build Phase."
    exit 1
}

[[ -s "$SCRIPT_OUTPUT_FILE_0" ]] || {
    echo "error: You must specify your Assets file as the first Output File in the Build Phase."
    exit 1
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

HELPER=$SCRIPT_DIR/Icon/Icon+PreviewHelpers.swift
GENERATOR=$SCRIPT_DIR/IconGenerator/IconGenerator.swift
MAIN=$SCRIPT_DIR/IconGenerator/main.swift

# Concatenate all files and remove import that is most likely in the input file
cat $SCRIPT_INPUT_FILE_0 $HELPER $GENERATOR $MAIN | grep -v "import\sSwiftUIcon" > $TMPFILE

xcrun -sdk macosx swift $TMPFILE || echo "error: Failed to generate icons from $SCRIPT_INPUT_FILE_0 into $SCRIPT_OUTPUT_FILE_0"
