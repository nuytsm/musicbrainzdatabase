#!/bin/bash

#cd /tmp
cd /var/lib/postgresql

echo "Creating Musicbrainz database structure"

echo "postgresql:5432:musicbrainz:$POSTGRES_USER:$POSTGRES_PASSWORD"  > ~/.pgpass
chmod 0600 ~/.pgpass

echo "Creating extensions"
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "CREATE SCHEMA musicbrainz;"
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "CREATE EXTENSION IF NOT EXISTS cube;"
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "CREATE EXTENSION IF NOT EXISTS earthdistance;"

wget https://raw.githubusercontent.com/metabrainz/musicbrainz-server/master/admin/sql/Extensions.sql
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -f Extensions.sql
rm Extensions.sql

wget https://raw.githubusercontent.com/metabrainz/musicbrainz-server/master/admin/sql/CreateTables.sql
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -f CreateTables.sql
rm CreateTables.sql

echo "Downloading last Musicbrainz dump"
wget -nd -nH -P /var/lib/postgresql http://ftp.musicbrainz.org/pub/musicbrainz/data/sample/LATEST
#wget -N -nd -nH -P /var/lib/postgresql http://ftp.musicbrainz.org/pub/musicbrainz/data/fullexport/LATEST
LATEST="$(cat /var/lib/postgresql/LATEST)"
rm -rf /var/lib/postgresql/LATEST

#Sample database dump (smaller than the full db dump (3gb vs 10gb)
wget --N nd -nH -P /var/lib/postgresql http://ftp.musicbrainz.org/pub/musicbrainz/data/sample/$LATEST/mbdump-sample.tar.xz

#Full database dump
#wget -N -nd -nH -P /var/lib/postgresql http://ftp.musicbrainz.org/pub/musicbrainz/data/fullexport/$LATEST/mbdump.tar.bz2


echo "Uncompressing Musicbrainz dump, this can take a while.."
#uncompress sample dump
tar xf /var/lib/postgresql/mbdump-sample.tar.xz
#rm mbdump-sample.tar.xz

#uncompress full dump
#tar vxjf /var/lib/postgresql/mbdump.tar.bz2
#rm mbdump.tar.bz2

for f in mbdump/*
do
 tablename="${f:7}"
 echo "Importing $tablename table"
 echo "psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c COPY $tablename FROM '/var/lib/postgresql/$f'"
 chmod a+rX /var/lib/postgresql/$f
 psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -c "\COPY $tablename FROM '/var/lib/postgresql/$f'"
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

echo "Creating view on the database that contains artitst and their albums"
wget https://raw.githubusercontent.com/nuytsm/musicbrainzdatabase/master/sql-scripts/createArtistAlbumview.sql
psql -h postgresql -d musicbrainz -U $POSTGRES_USER -a -f createArtistAlbumview.sql
rm createArtistAlbumview.sql

echo "Script done"
