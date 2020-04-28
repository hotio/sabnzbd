FROM hotio/base@sha256:b7f9f793ba275ea953ce4979b7a7c86e35ec3c2a93ca5932d0e0845ede0b3367

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8080

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        software-properties-common && \
    add-apt-repository ppa:jcfp/sab-addons && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        par2-tbb \
        python3-pip python3-setuptools build-essential python3-all-dev libffi-dev libssl-dev && \
# https://github.com/sabnzbd/sabnzbd/blob/develop/requirements.txt
    pip3 install --no-cache-dir --upgrade six sabyenc3 cheetah3 cryptography feedparser configobj cherrypy portend chardet gntp && \
# clean up
    apt purge -y software-properties-common python3-pip python3-setuptools build-essential python3-all-dev libffi-dev libssl-dev && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG SABNZBD_VERSION

# install app
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
