FROM cr.hotio.dev/hotio/base@sha256:ab76c33229508fe135b2ef84762fee8c28520d15e5b8ed19da99ac88f34f9dd0
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
