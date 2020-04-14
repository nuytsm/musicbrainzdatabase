#!/bin/bash

cd /tmp

echo "Creating Musicbrainz database structure"

echo "postgresql:5432:musicbrainz:$POSTGRES_USER:$POSTGRES_PASSWORD"  > ~/.pgpass
chmod 0600 ~/.pgpass

echo "Creating extensions"
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "CREATE EXTENSION IF NOT EXISTS cube;"
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "CREATE EXTENSION IF NOT EXISTS earthdistance;"
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "CREATE SCHEMA musicbrainz;"
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "CREATE EXTENSION IF NOT EXISTS musicbrainz_unaccent WITH SCHEMA musicbrainz;"
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "CREATE EXTENSION IF NOT EXISTS musicbrainz_collate WITH SCHEMA musicbrainz;"
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "COMMIT";

wget https://raw.githubusercontent.com/metabrainz/musicbrainz-server/master/admin/sql/CreateTables.sql
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -f CreateTables.sql
rm CreateTables.sql

echo "Downloading last Musicbrainz dump"
wget -nd -nH -P /tmp http://ftp.musicbrainz.org/pub/musicbrainz/data/sample/LATEST
LATEST="$(cat /tmp/LATEST)"

#Sample database dump (smaller than the full db dump (3gb vs 10gb)
wget -nd -nH -P /tmp http://ftp.musicbrainz.org/pub/musicbrainz/data/sample/$LATEST/mbdump-sample.tar.xz

#Full database dump
#wget -nd -nH -P /tmp http://ftp.musicbrainz.org/pub/musicbrainz/data/sample/$LATEST/mbdump.tar.bz2


echo "Uncompressing Musicbrainz dump"
#uncompress sample dump
tar xf /tmp/mbdump-sample.tar.xz
#rm mbdump-sample.tar.xz

#uncompress full dump
#tar xjf /tmp/mbdump.tar.bz2
#rm mbdump.tar.bz2

for f in mbdump/*
do
 tablename="${f:7}"
 echo "Importing $tablename table"
 echo "psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c COPY $tablename FROM '/tmp/$f'"
 chmod a+rX /tmp/$f
 psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "\COPY $tablename FROM '/tmp/$f'"
done

rm -rf mbdump

echo "Creating Indexes and Primary Keys"

wget https://raw.githubusercontent.com/metabrainz/musicbrainz-server/master/admin/sql/CreatePrimaryKeys.sql
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -f CreatePrimaryKeys.sql
rm CreatePrimaryKeys.sql

wget https://raw.githubusercontent.com/metabrainz/musicbrainz-server/master/admin/sql/CreateIndexes.sql
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -f CreateIndexes.sql
rm CreateIndexes.sql

echo "create-database.sh script finished, database should be filled with data"
