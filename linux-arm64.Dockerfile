FROM hotio/base@sha256:9adbfc4150ae80b31ee18d991897022e26e0722b47c9bcf9acdd02d43a19d372

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

# https://github.com/sabnzbd/sabnzbd/releases
ARG SABNZBD_VERSION=2.3.9

# install app
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
