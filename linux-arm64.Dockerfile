FROM cr.hotio.dev/hotio/base@sha256:a9cd4d01e0a106d07d8b1a239ece2c1f166c6f7a76740d6bbac2769a0a271392
EXPOSE 8080

ARG VERSION
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/archive/${VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    cd "${APP_DIR}" && python3 tools/make_mo.py && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

RUN apk add --no-cache py3-pip par2cmdline && \
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
