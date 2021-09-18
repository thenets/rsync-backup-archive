[![Docker Repository on Quay](https://quay.io/repository/thenets/rsync-backup-archive/status "Docker Repository on Quay")](https://quay.io/repository/thenets/rsync-backup-archive)

# rsync-backup-archive

Easiest way to backup files using `rsync`.

## 👨‍💻 Motivation

I needed a simple way to backup my own personal servers. Doesn't exist something critical that must have the best resiliance or something like that there.

I wanted a way to have copies of my files in case of some server blow up and if I have a simple way to do that, it's even better.

> 🔴 You should not use this kind of solution for critical production environment! Choose some cloud provider, like AWS, GCP, or Azure, and user their snapshot/backup solutions instead.
> This is for hobby projects and personal use-cases.

## 🚢 How to use

Choose the environment variables that you need and mount the volume where you want to store the backups.

Example:

> 💡 Check the `docker-compose.yml` example below for more details and how to use it.

```bash
docker run -it \
    --name "my-rsync-backup" \
    --restart unless-stopped \
    -e REMOTE_SSH_EXTRA_OPTS="-o StrictHostKeyChecking=no" \
    -e REMOTE_SSH_HOST="my-server.com" \
    -e REMOTE_RSYNC_INTERVAL_SECONDS="3600" \
    -v "~/backup/my-server-com:/output:rw"
```

### 🛠 Environment variables

- `LOCAL_OUTPUT_DIR`: [default: /output] local container directory to store the backup files.
- `REMOTE_SSH_HOST`: [default: localhost] [**required**] remote server domain or ip address.
- `REMOTE_INPUT_DIR`: [default: /input] remote directory to copy files from.
- `REMOTE_SSH_USER`: [default: root] remote ssh server username.
- `REMOTE_SSH_PORT`: [default: 22] remote ssh server port
- `REMOTE_SSH_KEY`: [default: /secrets/id_rsa] ssh private key file path.
- `REMOTE_SSH_EXTRA_OPTS`: [default: ""] extra arguments to pass to ssh command
- `REMOTE_RSYNC_EXTRA_OPTS`: [default: ""] extra arguments to pass to rsync command
- `REMOTE_RSYNC_INTERVAL_SECONDS`: [default: 0] Never run rsync again if 0. In other words, runs only once.

### 🐳 docker-compose.yaml example:

```yaml
---
version: "3.3"
services:
  my-rsync-backup:
    build: .

    # Container name
    container_name: "my-rsync-backup"

    # Restarts the container if the process exits with a
    # non-zero exit code. (in case of errors)
    restart: unless-stopped

    environment:
      # Probably you want to skip the public key check
      - REMOTE_SSH_EXTRA_OPTS="-o StrictHostKeyChecking=no"

      # Remote host domain or IP address
      - REMOTE_SSH_HOST="my-server.com"

      # Remote directory to backup
      - REMOTE_INPUT_DIR="/opt/my_data"

      # This makes this container never exit
      # unless some error occurs
      - REMOTE_RSYNC_INTERVAL_SECONDS="3600"
    volumes:
      # Pass the host user ssh key to the container
      - "~/.ssh:/secrets:ro"

      # Pass the local output directory to the container
      # this is the directory where the backup files will be stored.
      # If you not define this, all the files will be lost 
      # after the container exits
      - "~/backup/my-server-com:/output:rw"
```
