#!/usr/bin/env bash
set -euo pipefail

# Log available ALSA capture devices
echo "=== ALSA Capture Devices ==="
arecord -L
echo "============================"

# Check that environment variables are set
: "${VINYLPOD_SRC:?Environment variable VINYLPOD_SRC not set}"
: "${VINYLPOD_DST:?Environment variable VINYLPOD_DST not set}"

# Optional silence tail duration (default 5.0 seconds)
VINYLPOD_SILENCE_TAIL="${VINYLPOD_SILENCE_TAIL:-5.0}"

echo "Starting vinyl line-in capture..."
echo "Source device: $VINYLPOD_SRC"
echo "Destination FIFO: $VINYLPOD_DST"
echo "Silence tail duration: $VINYLPOD_SILENCE_TAIL seconds"

# Ensure the destination FIFO exists
if [[ ! -p "$VINYLPOD_DST" ]]; then
    echo "FIFO $VINYLPOD_DST does not exist. Creating..."
    mkfifo "$VINYLPOD_DST"
fi

# Run SoX
sox -V3 \
    -t alsa -r 44100 -c 2 -b 16 "$VINYLPOD_SRC" \
    -t wav -r 44100 -c 2 -b 16 -e signed-integer - \
    silence -l 1 0.2 1% -1 "$VINYLPOD_SILENCE_TAIL" 1% \
    > "$VINYLPOD_DST"
