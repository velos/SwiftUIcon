[[ "$ENABLE_PREVIEWS" = "NO" ]] || exit 0
[[ "$MAC_OS_X_VERSION_MAJOR" -ge "101500" ]] || exit 0

TMPFILE=`mktemp /tmp/SwiftUIcon.swift.XXXXXX` || exit 1
trap "rm -f $TMPFILE" EXIT


[[ -s "$SCRIPT_INPUT_FILE_0" ]] && [ "${SCRIPT_INPUT_FILE_0: -5}" == "swift" ] || {
    echo "error: You must specify your Icon.swift as the first Input File in the Build Phase."
    exit 1
}

[[ -s "$SCRIPT_OUTPUT_FILE_0" ]] && [ "${SCRIPT_OUTPUT_FILE_0: -8}" == "xcassets" ] || {
    echo "error: You must specify your Assets file as the first Output File in the Build Phase."
    exit 1
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

HELPER="$SCRIPT_DIR/Sources/SwiftUIcon/Icon+PreviewHelpers.swift"
GENERATOR="$SCRIPT_DIR/Sources/SwiftUIcon/IconGenerator.swift"
MAIN="$SCRIPT_DIR/Sources/SwiftUIcon/main.swift"

# Concatenate all files and remove import that is most likely in the input file
cat $SCRIPT_INPUT_FILE_0 $HELPER $GENERATOR $MAIN | grep -v "import\sSwiftUIcon" > $TMPFILE

xcrun -sdk macosx swift $TMPFILE || echo "error: Failed to generate icons from $SCRIPT_INPUT_FILE_0 into $SCRIPT_OUTPUT_FILE_0"
