#!/bin/sh

set -e

SSH_PATH="$HOME/.ssh"

mkdir "$SSH_PATH"
touch "$SSH_PATH/known_hosts"

echo "$PRIVATE_KEY" > "$SSH_PATH/deploy_key"
echo "$PUBLIC_KEY" > "$SSH_PATH/deploy_key.pub"

chmod 700 "$SSH_PATH"
chmod 600 "$SSH_PATH/known_hosts"
chmod 600 "$SSH_PATH/deploy_key"
chmod 600 "$SSH_PATH/deploy_key.pub"

# below key was created by running the below line from inside karli.rrze
# ssh-keyscan -t ecdsa-sha2-nistp256 karli.rrze.uni-erlangen.de
echo '$HOST,131.188.16.138 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFHJVSekYKuF5pMKyHe1jS9mUkXMWoqNQe0TTs2sY1OQj379e6eqVSqGZe+9dKWzL5MRFpIiySRKgvxuHhaPQU4=' >> "$SSH_PATH/known_hosts"

eval $(ssh-agent)
ssh-add "$SSH_PATH/deploy_key"

rsync -r --delete-after --quiet home/repo/_site/ $USER@$HOST:/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource/ghaction-rsync