---
title: "Backing up and restoring a self-hosted Plausible instance"
date: 2021-08-14T11:00:00+1000
tags:
    - docker
---

I've been using [Plausible Analytics](https://plausible.io/) on this website [for a few months now](/blips/im-now-using-plausible-analytics/) and I'm a fan for three key reasons.

-   They're open source
-   They explicitly detail how they [track web traffic in a privacy-preserving manner](https://plausible.io/data-policy)
-   Customers can [self-host their own Plausible instances](https://github.com/plausible/hosting)

Being able to self-host Plausible gives me ownership of the data it collects, but it also makes me responsible for storing this data and backing it up. I manage backups for my instance with several Ansible playbooks, but the same can be done with plain shell commands.

A self-hosted Plausible instance is run as a collection of Docker containers and volumes managed by Docker Compose. As a result, a full backup of each volume gives you a copy of all of the data you'll need for a restore.

So let's dive in! To start, bring down your running Plausible instance.

```sh
cd hosting # your clone of github.com/plausible/hosting
docker-compose down
```

With Plausible stopped, you can take a copy of each Docker volume. I do this by mounting each volume to a plain Ubuntu container and running `tar`, writing to a mounted directory on the host.

```sh
mkdir $HOME/backups/

docker run --rm \
    --mount "source=hosting_db-data,destination=/var/lib/postgresql/data,readonly" \
    --mount "type=bind,source=$HOME/backups,destination=/backups" \
    ubuntu \
    tar --absolute-names --gzip -cf /backups/plausible-user-data.tar.gz /var/lib/postgresql/data

docker run --rm \
    --mount "source=hosting_event-data,destination=/var/lib/clickhouse,readonly" \
    --mount "type=bind,source=$HOME/backups,destination=/backups" \
    ubuntu \
    tar --absolute-names --gzip -cf /backups/plausible-event-data.tar.gz /var/lib/clickhouse
```

To restore a backup, you can remove the old volumes and extract your tarballs into new volumes.

```sh
docker volume rm hosting_db-data hosting_event-data

docker run --rm \
    --mount "source=hosting_db-data,destination=/var/lib/postgresql/data" \
    --mount "type=bind,source=$HOME/backups,destination=/backups,readonly" \
    ubuntu \
    tar -xf /backups/plausible-user-data.tar.gz

docker run --rm \
    --mount "source=hosting_event-data,destination=/var/lib/clickhouse" \
    --mount "type=bind,source=$HOME/backups,destination=/backups,readonly" \
    ubuntu \
    tar -xf /backups/plausible-event-data.tar.gz
```

All that's left after this is to restart the Plausible containers. You may also want to pull changes from Plausible's hosting repo and the latest Docker images.

```sh
# Optionally, update your clone and pull latest images
git pull
docker-compose pull

docker-compose up --detach
```

From here, it's up to you what you do with your backups. I'd suggest moving them to an external store, whether that's your machine via `rsync` or a storage service with your provider of choice.

Happy coding!
