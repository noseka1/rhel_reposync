#!/bin/bash
source /credentials

if [ -n "$USERNAME" -a -n "$PASSWORD" ]; then
  echo Registering with the Red Hat Customer Portal
  subscription-manager register --username=$USERNAME --password=$PASSWORD --name={{ reposync_container }} --auto-attach
  echo Enabling RHEL repositories
  for REPO in {{ enable_repos | join(" ") }}; do
    subscription-manager repos --enable=$REPO
  done
elif [ -d /repodir ]; then
  echo Syncing RHEL repositories
  reposync --plugins --newest-only --delete --download_path /repodir
else
  echo You have to mount a volume on /repodir to start repository sync. Exiting ...
fi
