FROM cr.hotio.dev/hotio/base@sha256:8935fb7523e5f13f27b10500d3bb9eceb105d44c8b521b585e8994dc898ddb51
EXPOSE 8080

ARG VERSION
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${VERSION}/SABnzbd-${VERSION}-src.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
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
