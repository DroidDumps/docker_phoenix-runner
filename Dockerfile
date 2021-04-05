FROM python:3.8-alpine3.13

RUN printf "Adding Alpine Edge Package Support...\n" \
  && printf "http://dl-cdn.alpinelinux.org/alpine/edge/main\n" >> /etc/apk/repositories \
  && printf "http://dl-cdn.alpinelinux.org/alpine/edge/community\n" >> /etc/apk/repositories \
  && printf "http://dl-cdn.alpinelinux.org/alpine/edge/testing\n" >> /etc/apk/repositories

RUN apk update -q --progress --force-refresh \
  && apk upgrade -q --no-cache --available \
  && apk add --update --progress --no-cache --purge \
    bash bash-completion binutils coreutils scanelf ncurses ncurses-dev findutils grep dpkg musl-dev libffi libffi-dev gawk sed file sharutils xterm \
    wget curl aria2 ca-certificates gzip cpio bzip2 bzip2-dev libbz2 lz4 lz4-dev xz xz-dev xz-libs zlib zlib-dev lzo lzop brotli brotli-dev tar zstd zstd-dev p7zip \
    gcc libgcc libstdc++ linux-headers libc-dev git libxml2 libfdt dtc-dev openssh openssl openssl-dev libcrypto1.1 libssl1.1 gnupg detox bc xxd \
    py3-future py3-requests py3-humanize py3-lz4 py3-zstandard py3-protobuf py3-pycryptodome py3-docopt \
  && find /usr/local/lib /usr/lib -depth \( \( -type d -a \( -name "__pycache__" -o -name test -o -name tests -o -name idle_test \) \) \
    -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \) -exec rm -rf '{}' +; 2>/dev/null \
  && rm -rf /var/cache/apk/* 2>/dev/null

ENV TERM=xterm-256color

RUN set -xe \
  && wget -q -O get-pip.py https://bootstrap.pypa.io/get-pip.py \
  && python3 get-pip.py --upgrade --disable-pip-version-check --no-cache-dir \
  && rm -f get-pip.py \
  && pip3 install clint backports.lzma \
  && find /usr/local/lib /usr/lib -depth \( \( -type d -a \( -name "__pycache__" -o -name test -o -name tests -o -name idle_test \) \) \
    -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \) -exec rm -rf '{}' +; 2>/dev/null
