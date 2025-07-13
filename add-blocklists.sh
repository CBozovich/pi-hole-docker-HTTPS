#!/bin/bash

DB="/etc/pihole/gravity.db"

BLOCKLISTS=(
"https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
"https://dbl.oisd.nl/"
"https://raw.githubusercontent.com/lightswitch05/hosts/master/tracking-aggressive-extended.txt"
"https://mirror1.malwaredomains.com/files/justdomains"
"https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt"
)

echo "Checking Default group ID…"
DEFAULT_GID=$(sqlite3 $DB "SELECT id FROM 'group' WHERE name='Default';")
if [ -z "$DEFAULT_GID" ]; then
  echo "Could not find Default group. Creating it…"
  sqlite3 $DB "INSERT INTO 'group' (name, enabled) VALUES ('Default', 1);"
  DEFAULT_GID=$(sqlite3 $DB "SELECT id FROM 'group' WHERE name='Default';")
fi
echo "Default group ID: $DEFAULT_GID"

for URL in "${BLOCKLISTS[@]}"; do
  echo "Processing: $URL"
  ADLIST_ID=$(sqlite3 $DB "SELECT id FROM adlist WHERE address='$URL';")

  if [ -z "$ADLIST_ID" ]; then
    echo "Adding blocklist: $URL"
    sqlite3 $DB "INSERT INTO adlist (address, enabled) VALUES ('$URL',1);"
    ADLIST_ID=$(sqlite3 $DB "SELECT id FROM adlist WHERE address='$URL';")
  else
    echo "Already exists in adlist table."
  fi

  LINKED=$(sqlite3 $DB "SELECT id FROM group_adlist WHERE adlist_id=$ADLIST_ID AND group_id=$DEFAULT_GID;")
  if [ -z "$LINKED" ]; then
    echo "🔗 Linking to Default group."
    sqlite3 $DB "INSERT INTO group_adlist (group_id, adlist_id) VALUES ($DEFAULT_GID, $ADLIST_ID);"
  else
    echo "Already linked to Default group."
  fi
done

echo "Updating Gravity…"
pihole -g

echo "Done. Check the admin page → Group Management → Adlists."
