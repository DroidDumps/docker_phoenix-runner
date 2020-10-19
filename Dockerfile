FROM python:3-alpine

RUN printf "Adding Alpine Edge Package Support...\n" \
  && printf "http://dl-cdn.alpinelinux.org/alpine/edge/main\n" >> /etc/apk/repositories \
  && printf "http://dl-cdn.alpinelinux.org/alpine/edge/community\n" >> /etc/apk/repositories \
  && printf "http://dl-cdn.alpinelinux.org/alpine/edge/testing\n" >> /etc/apk/repositories

RUN apk update -q --progress \
  && apk add --progress --no-cache --purge --update-cache \
    bash bash-completion binutils coreutils scanelf ncurses ncurses-dev findutils grep dpkg musl-dev libffi gawk sed file sharutils xterm \
    wget curl aria2 ca-certificates gzip cpio bzip2 libbz2 lz4 xz-dev xz xz-libs zlib lzo lzop brotli tar zstd zstd-dev p7zip \
    gcc libgcc libstdc++ linux-headers libc-dev git libxml2 libfdt dtc-dev openssh openssl libcrypto1.1 libssl1.1 gnupg detox xxd

ENV TERM=xterm-256color

RUN wget -q -O get-pip.py https://github.com/pypa/get-pip/raw/master/get-pip.py \
  && python3 get-pip.py --upgrade --disable-pip-version-check --no-cache-dir \
  && rm -f get-pip.py \
  && pip3 install future requests humanize clint backports.lzma lz4 zstandard protobuf pycrypto pycryptodome docopt \
  && find /usr/local -depth \( \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
    -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \) -exec rm -rf '{}' +; 2>/dev/null

