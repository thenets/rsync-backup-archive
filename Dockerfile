FROM alpine

ENV LOCAL_OUTPUT_DIR /output
ENV REMOTE_INPUT_DIR /input
ENV REMOTE_SSH_USER root
ENV REMOTE_SSH_HOST localhost
ENV REMOTE_SSH_PORT 22
ENV REMOTE_SSH_KEY /secrets/id_rsa
ENV REMOTE_SSH_EXTRA_OPTS ""
ENV REMOTE_RSYNC_EXTRA_OPTS ""
ENV REMOTE_RSYNC_INTERVAL_SECONDS 0

ADD entrypoint.sh /

RUN set -x \
    && apk add openssh-client rsync \
    && chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
