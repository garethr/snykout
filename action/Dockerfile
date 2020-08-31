FROM debian:10

RUN apt-get update && apt-get install -y \
    wget \
    libevent-2.1-6 \
    libyaml-0-2 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /

RUN wget -O /snykout https://github.com/garethr/snykout/releases/download/v0.1.0/snykout_v0.1.0_linux-amd64 \
    && chmod +x /snykout

ENTRYPOINT ["/snykout"]
CMD ["--help"]
