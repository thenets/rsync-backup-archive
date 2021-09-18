#!/bin/sh

set -e

# Copy private key to the root container user
mkdir -p /root/.ssh
cp ${REMOTE_SSH_KEY} /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
chown root:root /root/.ssh/id_rsa

# Infinite loop
while true; do
    # Run rsync archive command
    echo "# Starting rsync archive..."
    date +"%Z %T %D"
    echo

    # echo all remote server info
    echo "# Remote server info:"
    echo "Host: ${REMOTE_SSH_HOST}"
    echo "Port: ${REMOTE_SSH_PORT}"
    echo "User: ${REMOTE_SSH_USER}"
    echo "Remote input path: ${REMOTE_INPUT_DIR}"
    echo

    # echo all local container info
    echo "# Local container info:"
    echo "Container ID: "$(cat /etc/hostname)
    echo "Local output path: ${LOCAL_OUTPUT_DIR}"
    echo

    rsync -zavh --delete \
        ${REMOTE_RSYNC_EXTRA_OPTS} \
        -e "ssh -i ${REMOTE_SSH_KEY} -p ${REMOTE_SSH_PORT} ${REMOTE_SSH_EXTRA_OPTS}" \
        ${REMOTE_SSH_USER}@${REMOTE_SSH_HOST}:${REMOTE_INPUT_DIR} ${LOCAL_OUTPUT_DIR}
    echo "... done"
    echo

    # Sleep until the next rsync archive
    # or break if REMOTE_RSYNC_INTERVAL_SECONDS is 0
    if [ "${REMOTE_RSYNC_INTERVAL_SECONDS}" -eq 0 ]; then
        break
    else
        echo "# Sleeping for ${REMOTE_RSYNC_INTERVAL_SECONDS} seconds until next rsync..."
        sleep ${REMOTE_RSYNC_INTERVAL_SECONDS}
    fi
done
