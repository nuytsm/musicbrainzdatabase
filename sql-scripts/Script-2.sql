-- https://musicbrainz.org/doc/MusicBrainz_Database/Schema


select * from artist a;

select * from artist a where a."name" like '%Nine Inch%'; 

select * from artist a where a."name" like '%Nine Inch%';

select * from artist a where a."gender" is not null;

select * from gender;

select a."name", t."name" from track t 
	join artist a on t.artist_credit = a.id where a."name" like 'Metallica';


select a."name" as band, r."name" as recording, t."name" as track from track t 
	join artist a on t.artist_credit = a.id
	inner join "release" r on t. = r.id
	where a."name" like 'Metallica';
	

SELECT
    artist.name AS Artist
    ,artist.gid AS artistGid
    ,artist.type as artisTypeId
    ,artist_type.name as ArtistTypeName
    ,release_group_meta.first_release_date_year as Year
    ,release_group.name AS Album
    ,artist.begin_date_year ArtistBeginDateYear
    ,area.name as ArtistCountryName
    ,release_group.gid AS albumid
    ,release_group.type AS albumPrimaryTypeId
    ,release_group_primary_type.name as albumPrimaryTypeName
    FROM artist
    INNER JOIN artist_credit_name ON artist_credit_name.artist = artist.id
    INNER JOIN artist_credit ON artist_credit.id = artist_credit_name.artist_credit
    INNER JOIN release_group ON release_group.artist_credit = artist_credit.id
    INNER JOIN release_group_primary_type ON release_group_primary_type.id = release_group.type
    LEFT OUTER JOIN artist_type ON artist.type = artist_type.id
    LEFT OUTER JOIN area ON artist.area = area.id
    LEFT OUTER JOIN release_group_meta ON release_group_meta.id = release_group.id
    WHERE
    release_group.type = '1'
    --AND NOT EXISTS (SELECT 1 FROM release_group_secondary_type_join WHERE release_group = release_group.id)
    AND artist."name" like 'Metallica';
   
   select a."name", area."name" from artist a join area on area.id = a.id;

select * from artist a where a."name" like '%Nine Inch%'; 

select * from artist a where a."name" like '%Nine Inch%';

select * from artist a where a."gender" is not null;

select * from gender;

select a."name", t."name" from track t 
	join artist a on t.artist_credit = a.id where a."name" like 'Metallica';

drop table leerlingnamen;
create table leerlingnamen (
id SERIAL primary key,
name varchar(100) not null
);

create table favorite_track(
id SERIAL primary key,
leerlingid integer,
trackid integer,
foreign key (leerlingid) references leerlingnamen(id),
foreign key (trackid) references track(id)
);

insert into favorite_track(leerlingid, trackid) values (1, 148927);
select * from favorite_track;

insert into leerlingnamen (id, "name") values (0,'Test');
insert into leerlingnamen ("name") values ('Test');
select * from leerlingnamen;

delete from leerlingnamen l where l.id != 1;

update favorite_track set trackid = 218568 where trackid = 148927;

select lln."name" as leerling, t."name" as "Favorite Track", a."name" as "Artist" from favorite_track ft
	join track t on ft.trackid = t.id
	join leerlingnamen lln on ft.leerlingid = lln.id
	join artist a on t.artist_credit = a.id;


select t.id, a."name" as band , t."name" as track, rg."name" as album from track t 
	join artist a on t.artist_credit = a.id
	left join medium m on t.medium = m.id
	left join "release" r on m."release" = r.id
	left join release_group rg on rg.id = r.release_group
	where a."name" like 'Rammstein';


select t.id, a."name" as band , t."name" as track, rg."name" as album from track t 
	join artist a on t.artist_credit = a.id
	left join medium m on t.medium = m.id
	left join "release" r on m."release" = r.id
	left join release_group rg on rg.id = r.release_group
	where a."name" like 'Metallica';
	
create view artistsalbums AS
SELECT
    artist.name AS Artist
    ,artist.type as artisTypeId
    ,artist_type.name as ArtistTypeName
    ,release_group_meta.first_release_date_year as Year
    ,release_group.name AS Album
    ,artist.begin_date_year ArtistBeginDateYear
    ,area.name as ArtistCountryName
    --,release_group.gid AS albumid
    ,release_group.type AS albumPrimaryTypeId
    ,release_group_primary_type.name as albumPrimaryTypeName
    FROM artist
    INNER JOIN artist_credit_name ON artist_credit_name.artist = artist.id
    INNER JOIN artist_credit ON artist_credit.id = artist_credit_name.artist_credit
    INNER JOIN release_group ON release_group.artist_credit = artist_credit.id
    INNER JOIN release_group_primary_type ON release_group_primary_type.id = release_group.type
    LEFT OUTER JOIN artist_type ON artist.type = artist_type.id
    LEFT OUTER JOIN area ON artist.area = area.id
    LEFT OUTER JOIN release_group_meta ON release_group_meta.id = release_group.id;
    --WHERE
    --release_group.type = '1'
    --AND NOT EXISTS (SELECT 1 FROM release_group_secondary_type_join WHERE release_group = release_group.id)
   -- AND 
   --artist."name" like 'Metallica';
   
   select * from artistsalbums a where a.artist like 'Linkin%';
  select * from artistsalbums a where "year" = (select MIN("year") from artistsalbums a where upper(a.artist) like upper('linkin%')) and upper(a.artist) like upper('linkin%');
 select artist from artistsalbums a;
select artist, "year", album from artistsalbums a where artist = 'Metallica' and "year" <= 1999;
select artist, "year", album from artistsalbums a where artist = 'Metallica' and ("year" < 2004 and "year" > 1996);
select count(*) from artistsalbums a;

select * from artist a where a."name" like 'linkin%';
select * from artistsalbums a where artistcountryname ='Belgium';
select DISTINCT artist from artistsalbums a where artistcountryname ='Belgium';

 select count(distinct artist) from artistsalbums a where artistcountryname ='Belgium';
select count(*) from artistsalbums a where artistcountryname ='Belgium' or artistcountryname='Netherlands';
select artist from artistsalbums a where artistcountryname ='Belgium' or artistcountryname='Netherlands';
select distinct artist from artistsalbums a where artistcountryname ='Belgium' OR artistcountryname='Netherlands';

select a.artist, a.album from artistsalbums a where artistcountryname ='Belgium' or artistcountryname='Netherlands' AND a.artist = 'Zornik'; -- FOUT, zelfde als enkel belgium
select a.artist, a.album from artistsalbums a where (artistcountryname ='Belgium' or artistcountryname='Netherlands') AND a.artist = 'Zornik';
   
   
   
