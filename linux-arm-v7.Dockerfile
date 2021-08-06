FROM hotio/base@sha256:bd1ba080a8f623f874c026fa579a1f1b5b6cb5349bbf960a566ecc242db48d0f
EXPOSE 8080

RUN apk add --no-cache unrar p7zip python3 py3-six py3-cryptography py3-chardet py3-feedparser py3-configobj py3-openssl && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing par2cmdline py3-guessit && \
    apk add --no-cache --virtual=build-dependencies py3-pip py3-setuptools gcc python3-dev musl-dev && \
    pip3 install --no-cache-dir --upgrade \
        puremagic \
        sabyenc3 \
        cheetah3 \
        cherrypy \
        portend \
        notify2 && \
    apk del --purge build-dependencies

ARG VERSION
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${VERSION}/SABnzbd-${VERSION}-src.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
