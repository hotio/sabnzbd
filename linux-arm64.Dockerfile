FROM cr.hotio.dev/hotio/base@sha256:395f6abf5a3965353a307032ca2dc4dafa66a048b1358211dec6d6b6fb8d2ed7
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
        python3-dev \
        rust && \
    pip3 install --upgrade pip && \
    pip3 install -r "${APP_DIR}/requirements.txt" && \
    apk del --purge build-dependencies

COPY root/ /
