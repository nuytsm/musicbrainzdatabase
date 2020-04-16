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
   
   
   
   
   