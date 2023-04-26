FROM golang:1.20-buster

ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update \
    && apt-get install -y \
      libgtk-3-dev \
      libwebkit2gtk-4.0-dev \
      libayatana-appindicator3-dev \
      librsvg2-dev \
      libssl-dev \
      make

RUN \
    go install github.com/wailsapp/wails/v2/cmd/wails@latest
