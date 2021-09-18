IMAGE_TAG=thenets/rsync-backup-archive
EXTRA_ARGS=
REMOTE_SSH_HOST=localhost

build:
	docker build -t $(IMAGE_TAG) .

run:
	docker run $(EXTRA_ARGS) \
		-e REMOTE_SSH_EXTRA_OPTS="-o StrictHostKeyChecking=no" \
		-e REMOTE_SSH_HOST=$(REMOTE_SSH_HOST) \
		-e REMOTE_INPUT_DIR="/opt/my-files" \
		-e REMOTE_RSYNC_INTERVAL_SECONDS="0" \
		-v $$(cd; pwd)/.ssh:/secrets:ro \
		-v $$(cd; pwd)/backup/$(REMOTE_SSH_HOST):/output:rw \
		$(IMAGE_TAG)

build-run: build run
