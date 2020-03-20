FROM hotio/base@sha256:5fa856ae4a428184ae3b8a2863efbb786cd1808b38ea6ce1b420848b0a8f61b0

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
        python3-pip python3-setuptools && \
# https://github.com/sabnzbd/sabnzbd/blob/develop/requirements.txt
    pip3 install --no-cache-dir --upgrade six sabyenc3 cheetah3 cryptography feedparser configobj cherrypy portend chardet gntp && \
# clean up
    apt purge -y software-properties-common python3-pip python3-setuptools && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG SABNZBD_VERSION=721976eb43f4af3b102f19cb06abcd9f5c7bbf6f

# install app
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/archive/${SABNZBD_VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    cd "${APP_DIR}" && python3 tools/make_mo.py && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
