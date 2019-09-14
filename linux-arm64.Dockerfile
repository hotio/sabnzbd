ARG BRANCH
FROM hotio/base:${BRANCH}

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8080
HEALTHCHECK --interval=60s CMD curl -fsSL http://localhost:8080 || exit 1

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        software-properties-common && \
    add-apt-repository ppa:jcfp/sab-addons && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        python-cheetah python-sabyenc python-cryptography par2-tbb unrar p7zip-full && \
# clean up
    apt purge -y software-properties-common && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY root/ /

# install app
RUN version=$(sed -n '1p' /versions/sabnzbd) && \
    curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${version}/SABnzbd-${version}-src.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"
