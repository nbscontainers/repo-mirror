FROM docker.io/alpine:latest

RUN apk add --no-cache python3 curl bash git gnupg openssh && \
    ln -sf python3 /usr/bin/python && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && \
    chmod a+x /usr/local/bin/repo

COPY entrypoint.sh /entrypoint.sh

ENV MANIFEST_URL=""
ENV MANIFEST_REVISION="HEAD"
ENV MANIFEST_NAME="default.xml"
ENV MANIFEST_GROUPS="default"

VOLUME /repos

ENTRYPOINT ["/entrypoint.sh"]
