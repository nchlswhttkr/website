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

echo --- Backing up Writefreely data
echo Stopping Writefreely
ssh "nicholas@$(cat droplet-config/ansible/hosts.ini)" "systemctl --user stop writefreely"
echo Creating a backup of data/keys
ssh "nicholas@$(cat droplet-config/ansible/hosts.ini)" "tar --create --absolute-names --gzip /home/nicholas/writefreely/writefreely.db /home/nicholas/writefreely/keys 2>/dev/null" > "$DESTINATION/writefreely-data.tar.gz"
echo Restarting Writefreely
ssh "nicholas@$(cat droplet-config/ansible/hosts.ini)" "systemctl --user start writefreely"
