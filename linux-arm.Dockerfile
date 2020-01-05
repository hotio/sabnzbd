FROM hotio/base@sha256:0754c8b551eb4b4c795fa68067a8cd553b3c618320e5af57e99b46486c445cf9

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8080

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        python3-pip python3-setuptools && \
# https://github.com/sabnzbd/sabnzbd/blob/develop/requirements.txt
    pip3 install --no-cache-dir --upgrade six sabyenc3 cheetah3 cryptography feedparser configobj cherrypy portend chardet gntp && \
# clean up
    apt purge -y python3-pip python3-setuptools && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG SABNZBD_VERSION=17719b1b5bfec074ec30bb633eb956d2a27c2d6c

# install app
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/archive/${SABNZBD_VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
