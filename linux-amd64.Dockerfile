ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

FROM alpine AS builder

ARG PAR2TURBO_VERSION

RUN apk --update --no-cache add \
    curl \
    autoconf \
    automake \
    build-base \
&& mkdir /par2turbo \
&& curl -fsSL "https://github.com/animetosho/par2cmdline-turbo/archive/refs/tags/v${PAR2TURBO_VERSION}.tar.gz" | tar xzf - -C /par2turbo --strip-components=1 \
&& cd /par2turbo \
&& aclocal \
&& automake --add-missing \
&& autoconf \
&& ./configure \
&& make \
&& make install

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}
EXPOSE 8080
VOLUME ["${CONFIG_DIR}"]

COPY --from=builder /usr/local/bin/par2* /usr/local/bin/

RUN mv /usr/local/bin/par2 /usr/local/bin/par2-turbo && \
    echo '#!/bin/bash' > /usr/local/bin/par2 && \
    echo '/usr/local/bin/par2-turbo "$@"' >> /usr/local/bin/par2 && \
    echo 'echo "par2cmdline-turbo"' >> /usr/local/bin/par2 && \
    chmod +x /usr/local/bin/par2

ARG VERSION
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${VERSION}/SABnzbd-${VERSION}-src.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

RUN apk add --no-cache py3-pip && \
    apk add --no-cache --virtual=build-dependencies \
        build-base \
        libffi-dev \
        openssl-dev \
        musl-dev \
        cargo \
        python3-dev && \
    pip3 install -r "${APP_DIR}/requirements.txt" && \
    apk del --purge build-dependencies

COPY root/ /
