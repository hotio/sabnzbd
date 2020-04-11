FROM hotio/base@sha256:75b16518487eb5cf1b65f55132938dbee7f954d82b8c13d4b0175780ada14ff7

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8080

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        software-properties-common && \
    add-apt-repository ppa:jcfp/sab-addons && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        python python-cheetah python-sabyenc python-cryptography par2-tbb && \
# clean up
    apt purge -y software-properties-common && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG SABNZBD_VERSION

# install app
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
