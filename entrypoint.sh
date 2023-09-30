#! /bin/sh

program=$1

if [ -z "$JAVA_MAX_MEMORY" ] && [ -z "$JAVA_MIN_MEMORY" ]; then
    JAVA_FLAGS="$JAVA_FLAGS -Xmx$JAVA_MEMORY -Xms$JAVA_MEMORY"
else
    if [ -n "$JAVA_MAX_MEMORY" ]; then
        JAVA_FLAGS="$JAVA_FLAGS -Xmx$JAVA_MAX_MEMORY"
    fi
    if [ -n "$JAVA_MIN_MEMORY" ]; then
        JAVA_FLAGS="$JAVA_FLAGS -Xms$JAVA_MIN_MEMORY"
    fi
fi

if [ "$(stat -c '%u' .)" != "$(id -u)" ]; then
    echo "Changing ownership of all files in $(pwd) to $(id -u)"
    chown -R "$(id -u)" .
fi

echo "Running with: \"$JAVA_FLAGS\""
# shellcheck disable=2086
java $JAVA_FLAGS -jar "$program"