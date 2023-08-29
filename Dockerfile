FROM golang:alpine AS build
RUN apk add --no-cache git wget build-base shadow

RUN mkdir /overlay
COPY root/ /overlay/

ENV GO111MODULE=on
RUN go install github.com/danysantiago/gphotos-cdp@31196df9d02807191cddd52d058cb0b6494c3896

FROM crazymax/alpine-s6:3.18-edge
LABEL maintainer="Jake Wharton <docker@jakewharton.com>"

ENV \
    # Fail if cont-init scripts exit with non-zero code.
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    CRON="" \
    HEALTHCHECK_ID="" \
    HEALTHCHECK_HOST="https://hc-ping.com" \
    PUID="" \
    PGID="" \
    TZ="" \
    CHROMIUM_USER_FLAGS="--no-sandbox"

# Installs latest Chromium package.
RUN echo @edge http://dl-cdn.alpinelinux.org/alpine/edge/community > /etc/apk/repositories \
    && echo @edge http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
    && apk add --no-cache \
      libstdc++@edge \
      chromium@edge \
      harfbuzz@edge \
      nss@edge \
      freetype@edge \
      ttf-freefont@edge \
      tzdata@edge \
      curl@edge \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk

COPY --from=build /go/bin/gphotos-cdp /usr/bin/
COPY root/ /
