#!/bin/bash

DESTINATION="backups/$(date '+%Y-%m-%d %H:%M:%S')"
mkdir -p "$DESTINATION"

echo --- Backing up Plausible data
echo Stopping Plausible containers
ssh "nicholas@$(cat droplet-config/ansible/hosts.ini)" "systemctl --user stop plausible"
echo Creating backup file of user data
ssh "nicholas@$(cat droplet-config/ansible/hosts.ini)" "sudo docker run --rm --mount 'source=plausible-hosting_db-data,destination=/var/lib/postgresql/data' ubuntu tar --create --absolute-names --gzip /var/lib/postgresql/data 2>/dev/null" > "$DESTINATION/plausible-user-data.tar.gz"
echo Creating backup file of event data
ssh "nicholas@$(cat droplet-config/ansible/hosts.ini)" "sudo docker run --rm --mount 'source=plausible-hosting_event-data,destination=/var/lib/clickhouse' ubuntu tar --create --absolute-names --gzip /var/lib/clickhouse 2>/dev/null" > "$DESTINATION/plausible-event-data.tar.gz"
echo Restarting Plausible containers
ssh "nicholas@$(cat droplet-config/ansible/hosts.ini)" "systemctl --user start plausible"

