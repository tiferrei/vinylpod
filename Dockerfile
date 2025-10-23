FROM alpine:3

# Set environment variables (can override at runtime)
ENV VINYLPOD_SRC="hw:CODEC,DEV=0" \
    VINYLPOD_DST="/music/AUX" \
    VINYLPOD_SILENCE_TAIL="5.0"

# Avoid interactive prompts
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies: SoX with ALSA support and ALSA utils
RUN apk add --no-cache \
        sox \
        alsa-utils \
        bash \
        alsa-lib \
        alsa-plugins \
        coreutils \
        && mkdir -p /music

# Copy the capture script
COPY capture.sh /usr/local/bin/capture.sh
RUN chmod +x /usr/local/bin/capture.sh

# Set working directory
WORKDIR /music

# Expose the FIFO path as a volume
VOLUME /music

# Entrypoint
ENTRYPOINT ["/usr/local/bin/capture.sh"]
