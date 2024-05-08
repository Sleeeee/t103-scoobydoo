--
-- This command file reloads a database that was unloaded using "dbunload".
--
-- (Version:  12.0.1.3152)
--


-- Database file: C:\Users\J\Documents\Sybase\ScoobyDoo\ScoobyDoo_clean.db
-- Database CHAR collation: UTF8BIN, NCHAR collation: UCA
-- Connection Character Set: UTF-8
--
-- CREATE DATABASE command: CREATE DATABASE 'C:\\Users\\J\\Documents\\Sybase\\ScoobyDoo\\ScoobyDoo_clean.db' LOG OFF CASE IGNORE ACCENT IGNORE PAGE SIZE 4096 COLLATION 'UTF8BIN' NCHAR COLLATION 'UCA' BLANK PADDING OFF JCONNECT ON CHECKSUM ON
--


SET OPTION date_order          = 'YMD'
go

SET OPTION PUBLIC.preserve_source_format = 'OFF'
go

SET TEMPORARY OPTION tsql_outer_joins = 'ON'
go

SET TEMPORARY OPTION st_geometry_describe_type = 'binary'
go

SET TEMPORARY OPTION st_geometry_on_invalid = 'Ignore'
go

SET OPTION PUBLIC.reserved_keywords = ''
go

create temporary procedure sa_unload_display_table_status( 
    msgid int, ord int, numtabs int, user_name char(128), table_name char(128) )
begin 
  declare @fullmsg long varchar; 
  set @fullmsg = lang_message( msgid ) ||
      ' (' || ord || '/' || numtabs || ') ' ||
      '"' || user_name || '"."' || table_name || '"'; 
  message @fullmsg type info to client; 
end
go


-------------------------------------------------
--   Create tables
-------------------------------------------------

CREATE TABLE "DBA"."tNetwork" (
    "netId"                          varchar(3) NOT NULL
   ,"netName"                        varchar(20) NOT NULL
   ,CONSTRAINT "pkNetwork" PRIMARY KEY ("netId") 
)
go

ALTER TABLE "DBA"."tNetwork"
    ADD CONSTRAINT "ukNetwork" UNIQUE ( "netName" )
go

CREATE TABLE "DBA"."tSeries" (
    "serId"                          varchar(4) NOT NULL
   ,"serName"                        varchar(50) NOT NULL
   ,"formId"                         varchar(3) NULL
   ,CONSTRAINT "pkSeries" PRIMARY KEY ("serId") 
)
go

ALTER TABLE "DBA"."tSeries"
    ADD CONSTRAINT "ukSeries" UNIQUE ( "serName" )
go

ALTER INDEX PRIMARY KEY ON "DBA"."tSeries" RENAME TO "tSeries"
go

CREATE TABLE "DBA"."tSeason" (
    "seasId"                         varchar(4) NOT NULL
   ,"seasLab"                        varchar(10) NOT NULL
   ,CONSTRAINT "pkSeason" PRIMARY KEY ("seasId") 
)
go

ALTER TABLE "DBA"."tSeason"
    ADD CONSTRAINT "ukSeason" UNIQUE ( "seasLab" )
go

CREATE TABLE "DBA"."tFormat" (
    "formId"                         varchar(3) NOT NULL
   ,"formLab"                        varchar(25) NOT NULL
   ,CONSTRAINT "pkFormat" PRIMARY KEY ("formId") 
)
go

ALTER TABLE "DBA"."tFormat"
    ADD CONSTRAINT "ukFormat" UNIQUE ( "formLab" )
go

CREATE TABLE "DBA"."tTerrain" (
    "terId"                          varchar(3) NOT NULL
   ,"terLab"                         varchar(10) NOT NULL
   ,CONSTRAINT "pkTerrain" PRIMARY KEY ("terId") 
)
go

ALTER TABLE "DBA"."tTerrain"
    ADD CONSTRAINT "ukTerrain" UNIQUE ( "terLab" )
go

CREATE TABLE "DBA"."tLocation" (
    "locId"                          varchar(3) NOT NULL
   ,"locLab"                         varchar(20) NOT NULL
   ,CONSTRAINT "pkLocation" PRIMARY KEY ("locId") 
)
go

ALTER TABLE "DBA"."tLocation"
    ADD CONSTRAINT "ukLocation" UNIQUE ( "locLab" )
go

CREATE TABLE "DBA"."tSnackUnit" (
    "snUnId"                         varchar(4) NOT NULL
   ,"snUnLab"                        varchar(20) NOT NULL
   ,CONSTRAINT "pkSnackUnit" PRIMARY KEY ("snUnId") 
)
go

ALTER TABLE "DBA"."tSnackUnit"
    ADD CONSTRAINT "ukNetwork" UNIQUE ( "snUnLab" )
go

CREATE TABLE "DBA"."tMonsterGender" (
    "monGenId"                       varchar(3) NOT NULL
   ,"monGenLab"                      varchar(6) NOT NULL
   ,CONSTRAINT "pkMonsterGender" PRIMARY KEY ("monGenId") 
)
go

ALTER TABLE "DBA"."tMonsterGender"
    ADD UNIQUE ( "monGenLab" )
go

CREATE TABLE "DBA"."tMonsterType" (
    "monTypId"                       varchar(4) NOT NULL
   ,"monTypLab"                      varchar(20) NOT NULL
   ,CONSTRAINT "pkMonsterType" PRIMARY KEY ("monTypId") 
)
go

ALTER TABLE "DBA"."tMonsterType"
    ADD CONSTRAINT "ukMonsterType" UNIQUE ( "monTypLab" )
go

CREATE TABLE "DBA"."tMonsterSubtype" (
    "monSubtypId"                    varchar(6) NOT NULL
   ,"monSubtypLab"                   varchar(25) NOT NULL
   ,CONSTRAINT "pkMonsterSubtype" PRIMARY KEY ("monSubtypId") 
)
go

ALTER TABLE "DBA"."tMonsterSubtype"
    ADD CONSTRAINT "ukMonsterSubtype" UNIQUE ( "monSubtypLab" )
go

CREATE TABLE "DBA"."tMonsterSpecies" (
    "monSpecId"                      varchar(6) NOT NULL
   ,"monSpecLab"                     varchar(20) NOT NULL
   ,CONSTRAINT "pkMonsterSpecies" PRIMARY KEY ("monSpecId") 
)
go

ALTER TABLE "DBA"."tMonsterSpecies"
    ADD CONSTRAINT "ukMonsterSpecies" UNIQUE ( "monSpecLab" )
go

CREATE TABLE "DBA"."tMonster" (
    "monId"                          varchar(4) NOT NULL
   ,"monName"                        varchar(40) NOT NULL
   ,"monGenId"                       varchar(3) NOT NULL
   ,"monTypId"                       varchar(4) NOT NULL
   ,"monSubtypId"                    varchar(6) NOT NULL
   ,"monSpecId"                      varchar(6) NOT NULL
   ,CONSTRAINT "pkMonster" PRIMARY KEY ("monId") 
)
go

ALTER TABLE "DBA"."tMonster"
    ADD CONSTRAINT "ukMonster" UNIQUE ( "monName" )
go

CREATE TABLE "DBA"."tEpisode" (
    "epId"                           varchar(4) NOT NULL
   ,"serId"                          varchar(4) NOT NULL
   ,"netId"                          varchar(3) NOT NULL
   ,"seasId"                         varchar(4) NOT NULL INLINE 4 PREFIX 4
   ,"epTitle"                        varchar(80) NOT NULL INLINE 80 PREFIX 8
   ,"epDateAired"                    date NOT NULL
   ,"epRunTime"                      tinyint NOT NULL
   ,"terId"                          varchar(3) NOT NULL INLINE 3 PREFIX 3
   ,"locId"                          varchar(3) NOT NULL INLINE 3 PREFIX 3
   ,"epSnNb"                         tinyint NULL
   ,"snUnId"                         varchar(4) NOT NULL INLINE 4 PREFIX 4
   ,CONSTRAINT "pkEpisode" PRIMARY KEY ("epId") 
)
go

ALTER TABLE "DBA"."tEpisode"
    ADD CONSTRAINT "ukEpisode" UNIQUE ( "epTitle" )
go

ALTER INDEX PRIMARY KEY ON "DBA"."tEpisode" RENAME TO "pkTempEpisode2"
go

CREATE TABLE "DBA"."tVoiceActor" (
    "vaId"                           varchar(4) NOT NULL
   ,"vaFirstName"                    varchar(15) NULL
   ,"vaLastName"                     varchar(15) NULL
   ,CONSTRAINT "pkVoiceActor" PRIMARY KEY ("vaId") 
)
go

CREATE TABLE "DBA"."tEpisodeMonster" (
    "epId"                           varchar(4) NOT NULL
   ,"monId"                          varchar(4) NOT NULL
   ,CONSTRAINT "pkEpisodeMonster" PRIMARY KEY ("epId","monId") 
)
go

CREATE TABLE "DBA"."tEpisodeVoiceActor" (
    "epId"                           varchar(4) NOT NULL
   ,"charId"                         varchar(2) NOT NULL
   ,"vaId"                           varchar(4) NOT NULL
   ,CONSTRAINT "pkEpisodeVoiceActor" PRIMARY KEY ("epId","charId") 
)
go

CREATE TABLE "DBA"."tCharacters" (
    "charId"                         varchar(2) NOT NULL
   ,"charName"                       varchar(7) NULL
   ,CONSTRAINT "pkCharacters" PRIMARY KEY ("charId") 
)
go


-------------------------------------------------
--   Reload column statistics
-------------------------------------------------

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tNetwork"."netId" 
	82, -1, 12, 12, 
	0x80f103862ec2db502ec2dc502ec2dd502ec2de502ec2df502ec2e0502ec2e1502ec2e2502ec2e3502ec3da502ec3db50900808080808080808080808,
	0x000000008c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tNetwork"."netName" 
	82, -1, 34, 34, 
	0x80f1038604e34f531b94dbe07933b7c088de6de521f40d513249bcfc483a9bd5e63371e34d6f9c5f837c524698d44f30a226bc5a9bf00019fc8fd19b47ef154db52fd17523f41d51777ecd1334f40d518037cdb179c8a953e5f421510b39cdb1792c4153e5080d5112ef9020edf2b6c5fc7e0b6ca67f35afe8fefa1a850faf4fdf978a8ef7e6c7e790040404040808040404040808040404040808080804040804040804040408040404,
	0x000000008c2e3a3e8c2e3a3e8c2e3a3e8c2e3a3e8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d8c2eba3d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tSeries"."serId" 
	82, -1, 30, 30, 
	0x00000000ff14478eff144793ff144798ff14479dff1447a2ff1447a7ff1447acff1447b1ff1447b6ff144c89ff144c8eff144c93ff144c98ff144c9dff144ca2ff144ca7ff144cacff144cb1ff144cb6ff145189ff14518eff145193ff145198ff14519dff1451a2ff1451a7ff1451acff1451b1ff1451b6200808080808080808080808080808080808080808080808080808080808,
	0x00000000cb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tSeries"."serName" 
	82, .034482758492231, 125, 125, 
	0xe05b2386ba4bfe8d1b94dbe004e34f535ac697d51bb96fc81bfe8fa28d6bc29ae5f2cf50f2db32c3790455531b0489db6244a8c52b32986ae96430e16f7ad6f9477049467933b7c03726ad53f72c8fe01b3020f5df6462bb80dffcf022f7cf5079c34f53e6f5a7c5607bf761ba4bfe796c0405f0bd0b7fc80259f90e1ba9dc0ee24acb6f010eb37d05457875b1e9470279ce4552e5c2da50f7e6c7e72e3ab7e8b0678fe5895ec6176d6bfab579be9a531bcc2ba279f53bed9872e1a9418085c088c6edecf033b77fa02423750418896edcd359c5a6a8203da1b1c7dae2748a9d6ff8fd4979cd81c582eabf1a2ffdcf5017f78d39a81263c41281f32906c6ea50607bf74fec9285931bb9d3e1e155b73707118b71e2809b30e393ae67ee300ac337ec3e08b8b05a73ed50c693cf5e4b469ddfdbda7365cd939c6ded04fd21b3e753bf6551fc77d8379b9e3a36f985d80abd1d0955675d629d65843f3de5b7cf501b4f8f57dfea98e3719e353670a7bb011bdd170dd2248fc166ecd26247c03a18db8cd8de3b5762de79ce5452a199209b3fa644682177ecafb57cdbdaa696b74c6fe4cf4ae360f6e89b5eca930c59eb5470603a475b8b3f2702eef7c1742fcb26dc7b8c86d417b5663408d050791da55353c8cd16518e8f0412ef902088de6de5edf2b6c5fc7e0b6ce8fefa1a850faf4fba4bfe0f0004040404040404040404040404040404040804040408040404040408040404040404040404040404040404040408040404040808040404040408040804040804040404040804040408040404080408040404040804040404040408080404040404040408040408040408040408040408080404040408040404080404,
	0x00000000f734c23e232c773e3e8d303ecb3d0d3ecb3d0d3ecb3d0d3eb1dcd33dcb3d8d3dcb3d8d3dcb3d8d3dcb3d8d3dcb3d8d3dcb3d8d3dcb3d8d3dcb3d8d3dcb3d8d3dcb3d8d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3dcb3d0d3d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tSeries"."formId" 
	82, -1, 20, 6, 
	0x306e498626c2db5026c2dc5026c2dd5026c2de5026c2df50308888888888,
	0x8fc2753d8c31463e4a29253e0821043d19630c3f0821843d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tSeason"."seasId" 
	82, -1, 8, 8, 
	0x00000000ff19478eff194793ff194798ff19479dff1947a2ff1947a7ff1947ac2008080808080808,
	0x000000002549123e2549123e2549123e2549123e2549123e2549123e2549123e
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tSeason"."seasLab" 
	82, -1, 8, 8, 
	0x20bc4886b5d44f93bad44f93bfd44f93c4d44f93aa025e3f631f3946696dbd890008080808080808,
	0x000000002549123e2549123e2549123e2549123e2549123e2549123e2549123e
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tFormat"."formId" 
	82, -1, 6, 6, 
	0x0000000026c2db5026c2dc5026c2dd5026c2de5026c2df50200808080808,
	0x00000000cdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3e
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tFormat"."formLab" 
	82, -1, 16, 16, 
	0xb0a345863408d050791da5536f7ad6e5aa025e3f631f3946aa81c940ad9d1d5fe360a8e80980b3430fb3f0739e488817e37ec4d49d78df0008c37d98428d7f1e00040404080808040404040804080404,
	0x00000000cdcccc3ecdcccc3ecdcccc3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3e
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tTerrain"."terId" 
	82, -1, 16, 16, 
	0x6013558634c2db5034c2dc5034c2dd5034c2de5034c2df5034c2e05034c2e15034c2e25034c2e35034c3da5034c3db5034c3dc5034c3dd5034c3de5034c3df5020080808080808080808080808080808,
	0x000000008988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tTerrain"."terLab" 
	82, -1, 16, 16, 
	0x0000000021fb1c51afbfa493b41e2c3e18baa1692b9d2969d5913d72258c3861e10582c0ae0934f0c2f38e7c03b6d57dff0082edf9382cae30e82ca8586b457c10080808080808080808080808080808,
	0x000000008988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d8988883d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tLocation"."locId" 
	82, -1, 79, 79, 
	0x205a56862cc2db502cc2dc502cc2dd502cc2de502cc2df502cc2e0502cc2e1502cc2e2502cc2e3502cc3da502cc3db502cc3dc502cc3dd502cc3de502cc3df502cc3e0502cc3e1502cc3e2502cc3e3502cc4da502cc4db502cc4dc502cc4dd502cc4de502cc4df502cc4e0502cc4e1502cc4e2502cc4e3502cc5da502cc5db502cc5dc502cc5dd502cc5de502cc5df502cc5e0502cc5e1502cc5e2502cc5e3502cc6da502cc6db502cc6dc502cc6dd502cc6de502cc6df502cc6e0502cc6e1502cc6e2502cc6e3502cc7da502cc7db502cc7dc502cc7dd502cc7de502cc7df502cc7e0502cc7e1502cc7e2502cc7e3502cc8da502cc8db502cc8dc502cc8dd502cc8de502cc8df502cc8e0502cc8e1502cc8e2502cc8e3502cc9da502cc9db502cc9dc502cc9dd502cc9de502cc9df502cc9e0502cc9e1502cc9e250b0080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808,
	0x00000000210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tLocation"."locLab" 
	82, .012820512987673, 118, 118, 
	0x205a5686e6d3a9531bfe8fa2cb33255d9322db366668014a1584c6fc64e453c3421a5821188ef8dea01dc0694da8b257a3d1d93d61c35e0c1511dea10287652edec32e73ee7e0f80aa083a0dfb1e78a96798a6bcee2aa8d921f1c56a1647e9bbe65683f51b70bfb6285ce4d45012dec5888c73f3227e76c0882be3a129bfb0d6eb1a83f32b3ee4d4480430a99434a951f4c69377e15c1d78b70fafccb786b0cc65b489c22c04538b2ac6c4db2f7071a76f6c9d88852c7c3a5ba2e53ecd143ccf1c912b75639c2c8f45c1a17d81198ebcbaf93c3fc3ca3472e1bf90d94fb80b8895d72e54e10582c0456a01c69f25a27debc99d19e5854581a199f3e5ed51cad4f88633a26fdac17be35ec0f2e05592431b5db7c079128b264793a248346cb6567e15be77c7ecf48d759e29bcee68a8d4155d2808ab453b9b6a9f2933f68d02d5aed4f56140a13b72e1b04479634aa865659476d49c7a52a27ff2c56a8d63f4ae815939441e35afeade7985c55beeee29db55fbb66970da7fae8fa93f2bf4421effca99edde8262e34cccbf3d243d1db71cdeb553ffe73bbb2616f04de6a0a0bdee81a8e3caff7f029ccc4ccdf9382cae26392c44c4559b7b581490cd58266a7e5d8a44e0bc902c57e4a3994c6f668adea6ac6c05a67a4d3eb0040408080808080808040404040808080408080404040808080808080404040408040808040404040808040404040808080808080808080808080808080404080404080404080404080404040408080808080804040404080404040408080804040408080804040404040808080808080808040404,
	0x00000000210d523d210d523d210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c210d523c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tSnackUnit"."snUnId" 
	82, -1, 6, 6, 
	0x00000000ff23478eff234793ff234798ff23479dff2347a2c00808080808,
	0x00000000cdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3e
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tSnackUnit"."snUnLab" 
	82, -1, 19, 19, 
	0x0000000022012351ffbbdd9ba70a13649739ca52929d84b5ea851acb3ba07318ae18a270dd89b7e36c03b17356cd897d090164de0170a4f53e38cd62df9985939cd14de534169cd57e371f91c0080804040404080404040408080404040404,
	0x00000000cdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3e
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonsterType"."monTypId" 
	82, -1, 18, 18, 
	0x90645786e11e478ee11e4793e11e4798e11e479de11e47a2e11e47a7e11e47ace11e47b1e11e47b6e11e4c89e11e4c8ee11e4c93e11e4c98e11e4c9de11e4ca2e11e4ca7e11e4cac200808080808080808080808080808080808,
	0x00000000f1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonsterType"."monTypLab" 
	82, -1, 22, 22, 
	0x906457860b70bba7d01bc44caf2457db952a03e213080265a92a19c41870893f1220a66959d3ac716ae31044770df44ff9d42bc15ff40541f2fe064699c61d450795f6855b0c901ddf68b6acf904c2bc7af3ca686c25536260080808080808080808080808080804040404080808,
	0x00000000f1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703df1f0703d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonsterSubtype"."monSubtypId" 
	82, .005747126415372, 81, 81, 
	0x40f1ea85d08c2589d58c2589da8c2589df8c2589e48c2589e98c2589ee8c2589f38c2589f88c2589fd8c2589028d2589078d25890c8d2589118d2589168d25891b8d2589208d2589258d25892a8d25892f8d2589348d2589398d25893e8d2589438d2589488d25894d8d2589528d2589578d25895c8d2589618d2589668d25896b8d2589708d2589758d25897a8d25897f8d2589848d2589898d25898e8d2589938d2589988d25899d8d2589a28d2589a78d2589ac8d2589d08c2506d58c2506da8c2506df8c2506e48c2506e98c2506ee8c2506f38c2506f88c2506fd8c2506028d2506078d25060c8d2506118d2506168d25061b8d2506208d2506258d25062a8d25062f8d2506348d2506398d25063e8d2506438d2506488d25064d8d2506528d2506578d25065c8d2506618d2506668d25066b8d2506708d2506758d25067a8d2506200808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808,
	0x0000000064523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c64523c3c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonsterSubtype"."monSubtypLab" 
	82, .005376344081014, 3, 3, 
	0x40f1ea85e3eeb211a12f8a03400404,
	0x000000006452bc3c6452bc3c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonsterSpecies"."monSpecId" 
	82, .007092198356986, 63, 63, 
	0xc0ea1686d08c3187d58c3187da8c3187df8c3187e48c3187e98c3187ee8c3187f38c3187f88c3187fd8c3187028d3187078d31870c8d3187118d3187168d31871b8d3187208d3187258d31872a8d31872f8d3187348d3187398d31873e8d3187438d3187488d31874d8d3187528d3187578d31875c8d3187618d3187668d31876b8d3187708d3187758d31877a8d31877f8d3187848d3187898d31878e8d3187938d3187988d31879d8d3187a28d3187a78d3187ac8d3187d08c3104d58c3104da8c3104df8c3104e48c3104e98c3104ee8c3104f38c3104f88c3104fd8c3104028d3104078d31040c8d3104118d3104168d31041b8d3104208d3104200808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808,
	0x00000000ac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683cac65683c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonsterSpecies"."monSpecLab" 
	82, .007142857182771, 3, 3, 
	0x40f1ea85e3eeb211a12f8a03a00404,
	0x00000000ac65683cac65683c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonster"."monId" 
	82, .00164473685436, 1, 1, 
	0xb06d188620,
	0x00000000
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonster"."monName" 
	82, .000863787368871, 125, 125, 
	0x60d0ef85ed5185c53631af3da12f8a03790455536e9543461be52bc166654339e3eeb211dd958ade99c61d4579fa3bc0e30115e6e82e99c56ff8fd49fad34a53b9058aa35637d4e1e78976b6208f7693f13799c5b86a9b9a49bbd1d826646be7e833809371691c4515ab7bacec3306cb69f0b2117487ed2ced6fdecbb08b101b9ff6286a60288fe0ee9285a75b6983c9fce6b5d258acd167356b8a9030d96345ae73c01cb5a25d0875e86d2aee5c62c079133cf7b998ba847e62b656cc07bc41d811d26eee25055c3f9cfc3da6664b2f641c836bde6ab395df7dc693b7c6360879fd4ed17ed31e91ef4a06df3aac4765133cffde3e649eeb79dd59529c497130bfd5ccd4e1bf4a534c1dcbaf6318de364494b56579f172528e793f81df2d99a77004ba42e2ecfdb8a5d0d389a6100d6672ebda777f846714ed47a8e3e22099ca6f6c9d88ab76f3d2f4ba50edf92326623cc52eccea35e8e39c8eee05791dd7ad1bb956d5e87e997f2339e8c5f210d9c51b22d666853e9ebe889c360c7c6ee99551c5a322cd5d25b3986aae0056e43482e1143d52f1942575e0a1236abf4222425653588fc606fcbe4b5359556f98076de846a8e3f0b403bb2484629da1efabe68350d445949a65ba5f2b74bd583390dc17a4f1f44f09038488dbd386fc313aa110bf437cca902283e637c6b6d870decb4c2f21054004040404040404040404040404040404040404040404040404040404040404040404040404080808040404040804080408040804040404040404040408040408040404080408840804040808040404040404040404040404040804040808080404040404040408040404040404040404040408040804040404040404,
	0x000000002a6b0a3e18f4053efa823e3d3ce20e3d893be23c893be23cca9ab23cca9ab23cca9ab23c9bb2a63c6bca9a3c3ce28e3c3ce28e3c3ce28e3c0cfa823c0cfa823cb9236e3cb9236e3cb9236e3cb9236e3c5953563c5953563c5953563c5953563c5953563c5953563c5953563c5953563c5953563c5953563c5953563c5953563c5953563cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3c313cbe3bfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cfa823e3cc2973c3c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonster"."monGenId" 
	82, .001601519528776, 3, 3, 
	0x60d0ef852df9da502df9db50908888,
	0x000000009f375f3f55a8013e
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonster"."monTypId" 
	82, .00203488371335, 13, 13, 
	0x60d0ef85e11e47ace11e4793e11e4cace11e4c8ee11e4c9de11e47a2e11e4c89e11e47b6e11e478ee11e4ca7e11e4c93e11e47a790080808080808080808080808,
	0x00000000654d593e0cfa423e415f103ea7aca93da7aca93d18f4853d415f503d1277443dca9a323db923ee3c893be23c0cfa823c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonster"."monSubtypId" 
	82, .004056751262397, 28, 28, 
	0x60d0ef857a8d2589da8c25067a8d2506438d2589208d2589618d2506398d2589208d2506348d2506d08c2506bc8c2589758d2506e98c2506df8c2589df8c2506398d25066b8d25060c8d2589168d2589668d2589708d2506b68d2589118d2589438d2506488d25892a8d2589668d250690080808080808080808080808080808080808080808080808080808,
	0x000000000cfa023e067dc13db9236e3d53d6143d3ce20e3de80bfa3cb923ee3c5953d63c2a6bca3c2a6bca3cfa82be3c9bb2a63c6bca9a3c6bca9a3c0cfa823cb9236e3c5953563c5953563c5953563c5953563c5953563cfa823e3cfa823e3c9bb2263c9bb2263c9bb2263c9bb2263c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tMonster"."monSpecId" 
	82, .003667263081297, 15, 15, 
	0x60d0ef85618d31872a8d3187578d3187d08c3187bb8d3187898d3187bc8c3187c68c31042f8d31874d8d3187e98c3187e48c31871b8d3187208d3104900808080808080808080808080808,
	0x000000004d59133f5953d63c2a6bca3cca9ab23c0cfa823cfa823e3cfa823e3cfa823e3cfa823e3c9bb2263c9bb2263c9bb2263c9bb2263c9bb2263c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisode"."epId" 
	82, .001712328754365, 1, 1, 
	0x700b3186b0,
	0x00000000
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisode"."serId" 
	82, .003071035724133, 18, 18, 
	0x700b3186ff144ca2ff144793ff144ca7ff1447acff1451b1ff1451b6ff144c98ff1451a2ff14478eff144cacff144c8eff145193ff14518eff145198ff144c9dff145189ff145689b08888888888888888888888888888888808,
	0x000000000a0b123eb301b43d3b9cb03d5e06a33d5e06233c92a58e3d1b408b3da4da873df6c74b3d3b9c303d4dd1293d5e06233d5e06233da4da073dd35dd93c3b9cb03c3b9c303d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisode"."netId" 
	82, .003316749585792, 8, 8, 
	0x700b31862ec2db502ec2de502ec2dd502ec2df502ec2e3502ec3db502ec2e250b008080808080808,
	0x00000000fd97ee3e92a50e3e7c54fb3dd66ba63d1b408b3d2d75843d2a67373d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisode"."seasId" 
	82, .008291874080896, 7, 7, 
	0x700b3186ff19478eff194793ff194798ff1947a2ff1947a7ff1947acb0080808080808,
	0x0000803f7e08043f1b408b3ef6c7cb3dd35d593c92a58e3d3b9cb03c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisode"."epTitle" 
	82, .001445102621801, 124, 124, 
	0x700b31861b94dbe004e34f5379045553c2dfe2e9f72c8fe0e5f2cf50ba4bfe8dfc77d837d78cfc1679047d5306a0d6bfe3eeb211ec7e6c7fed5185c56e9543461b0489db8d98079c1bd2f212ddae42ff79e69553dd7ead7f9c7adb6ebf9a352147ade8501b948adb65441f061bd22ac7e2748a9d1be52bc1a6eef317ec9176a79524d6cced8cd0a792058fe0ca6f25769481671ef60e91e36a483ad36cdaa4fc193009eebb532bc8781dc5f047c03a18a7d9236b85ebc64c68b1dc91a065a559720da5063a4eb58f580b86794de128132fbeef28146b8a936c86c2c965568ae8e7943748e3f9042c79e7633edf48b79379a876c079e76c6b47a0357247ca2b13ce8988918843ea6edd3ed8d4ea58fdc22164c61be9a876dfac24ab3ee331d152b7c63608707958bee6859e7f6f638a96796acdcedf03da8eef8676d40e1b29096e24ca6e5b670db424ad8700db4f0973d0dcdfb5ee9faca74e4c84c2ca589ea3e8518a7f83e924c4830589db673ce3e65b0d5df3b5ec3d7d5655a1cbf02499a78211dfc5e89ea8e31b0f0b45472b1aa2e5facf50a36f4978ba4bfe792988859b30c728c78dd971880d5d4c567626449d008d4a27bd6f13f0c58cd441155d2808e688a3897ee705f69e62b6d28d128fb9b2f89c71ae8f64026cff714a1477c3d09ef1d162a60d2bfeed73b2d4db78e7b6b0040404040404040404040404040404040404040404040404040404040404040404040408040404080808040804080408040808040404040404040404040404040404040404080404080404040404080408080404040404040404080404080404040404040804040404040804040404040404040808040804040404,
	0x0000000098eeca3ef540653ec5bd133e92a58e3d7c547b3d703b1c3d8170153d92a50e3da4da073db50f013d8d89f43cb0f3e63cd35dd93cd35dd93cf6c7cb3c1932be3c1932be3c3b9cb03c3b9cb03c3b9cb03c3b9cb03c3b9cb03c3b9cb03c5e06a33c5e06a33c5e06a33c5e06a33c5e06a33c5e06a33c8170953c8170953c8170953c8170953c8170953c8170953ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873ca4da873c
end if
go

if db_property('PageSize') >= 4096 then 
    LOAD STATISTICS "DBA"."tEpisode"."epDateAired" 
	64, .002646247623488, 20, 20, 
	0x00000000fef3254100000000fef32541000000005eff254100000000f407264100000000f40726410000000002082641000000000208264100000000cc0a264100000000cc0a2641000000002e0b264100000000a40d264100000000a40d264100000000060e264100000000680e264100000000e81e2641000000005028264100000000344826410000000022662641000000007a7d264100000000d0862641,
	0x0000000038a2cf37e150643dd108413c5c9c5c3b000000005c9c5c3b96d2ce3c4575a53b9cc6103d5c9cdc3c4575a53b9cc6103dd108413ce72f783c95555e3e054bf13d9e43013eed233a3e59a2fb3d
end if
go

if db_property('PageSize') >= 4096 then 
    LOAD STATISTICS "DBA"."tEpisode"."epRunTime" 
	65, -1, 1, 1, 
	0x00000000fef32541,
	0x0000803f
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisode"."terId" 
	82, -1, 1, 1, 
	0x700b3186b0,
	0x0000803f
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisode"."locId" 
	82, -1, 1, 1, 
	0x700b3186b0,
	0x0000803f
end if
go

if db_property('PageSize') >= 4096 then 
    LOAD STATISTICS "DBA"."tEpisode"."epSnNb" 
	65, -1, 1, 1, 
	0x5b00000006000000,
	0x0000803f
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisode"."snUnId" 
	82, .001658374792896, 3, 3, 
	0x60d0ec85ff23479dff23478e800808,
	0x00000000236a723f07fd443d
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tVoiceActor"."vaId" 
	82, -1, 37, 37, 
	0x808a27860ec0468e0ec046930ec046980ec0469d0ec046a20ec046a70ec046ac0ec046b10ec046b60ec04b890ec04b8e0ec04b930ec04b980ec04b9d0ec04ba20ec04ba70ec04bac0ec04bb10ec04bb60ec050890ec0508e0ec050930ec050980ec0509d0ec050a20ec050a70ec050ac0ec050b10ec050b60ec055890ec0558e0ec055930ec055980ec0559d0ec055a20ec055a790080808080808080808080808080808080808080808080808080808080808080808080808,
	0x00000000398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tVoiceActor"."vaFirstName" 
	82, -1, 46, 46, 
	0x808a2786d7bf9a9308c2d37d44f48858e49edbc5aac06780b4883e90afbf90b6cdc0ece1559d8b3e24011951d2692cc1a1d08663af7b90876cf288698898d505e884f7a7c3e77c7fc31450f7e0c64ccde0c68dd7313aafde57bc36d1368970c84fc1d3904504b25ea1c922c2ec7462d41bb32bd479f03bf74a2613dfc78970c8e6d363b6e6e745b119b2d34330f31e51c2a159ea5fd145b2e6ca2275db8162d40e593c841078721a543707e626a5b32613e872b63af30d5190080808080808080808080808040404040808080808080808080404040408080808080808080404040408080808,
	0x00000000398e633d398e633d398e633d398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tVoiceActor"."vaLastName" 
	82, -1, 37, 37, 
	0x808a27863a3883f613c0908e13d495de0813d3af59c1ece14ac16f134b3802da10c236542a04d950f46d778e2841d9a72bf32351bbb0914e8b1fd55814be36b9454cb0e37ec922bc2a101c9444f488581836009e3e5bd8b6af055fc0282fe5c06522e77f18c1a7f9658ec4e85aec8f8fc8ad384e3847cf98dcb936d1450671e17746938ad33ba1e8fff9c7f8b41ed558c83dd4db90080808080808080808080808080808080808080808080808080808080808080808080808,
	0x00000000398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c398ee33c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisodeMonster"."epId" 
	82, .002484213327989, 8, 8, 
	0x00000000b9de4aa2b9d97298b9de4ab6b9d94a98b9de45b6b9de459db9e354890008880888080808,
	0x000000008fc2753c8fc2753cf4fd543c6f12833c5839343c0ad7233c0ad7233c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisodeMonster"."monId" 
	82, .001382397604175, 6, 6, 
	0x00000000e1cf59a2e1ca4a93e1cf59ace1ca4aa2e1ca45b6000808080808,
	0x00000000a69bc43c7f6abc3cbc74933c4260653c0ad7233c
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisodeVoiceActor"."epId" 
	82, .002119635231793, 1, 1, 
	0x9014ec8560,
	0x00000000
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisodeVoiceActor"."charId" 
	82, -1, 6, 6, 
	0x9014ec85652d8fe06a2d8fe06f2d8fe0742d8fe0792d8fe0608888888888,
	0x000000003862263e66c63e3e0b569f3ecd49a03ec9e9733e
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tEpisodeVoiceActor"."vaId" 
	82, .001279584132135, 15, 15, 
	0x9014ec850ec046b10ec0469d0ec04b8e0ec04b9d0ec04bac0ec050930ec04ba70ec050a70ec050a20ec046a70ec046a20ec0508e0ec055930ec046ac608888088888080808888888080888,
	0x00000000f868843e6e21433c199c8f3e284c843d81ed493c2940ca3d09dbb53d50f43a3da28eb13c7b194a3c230f1b3e176ace3d19db6f3cfc26063e
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tCharacters"."charId" 
	82, -1, 6, 6, 
	0x00000000652d8fe06a2d8fe06f2d8fe0742d8fe0792d8fe0000808080808,
	0x00000000cdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3e
end if
go

if db_property('PageSize') >= 4096 and
   db_property('Collation') = 'UTF8BIN' then 
    LOAD STATISTICS "DBA"."tCharacters"."charName" 
	82, -1, 6, 6, 
	0x00000000be14508e232aeda230263ea97137d95af4c5ac49200808080808,
	0x00000000cdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3ecdcc4c3e
end if
go


-------------------------------------------------
--   Reload data
-------------------------------------------------

call sa_unload_display_table_status( 17737, 1, 17, 'DBA', 'tNetwork' )
go

LOAD TABLE "DBA"."tNetwork" ("netId","netName")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/724.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 2, 17, 'DBA', 'tSeries' )
go

LOAD TABLE "DBA"."tSeries" ("serId","serName","formId")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/725.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 3, 17, 'DBA', 'tSeason' )
go

LOAD TABLE "DBA"."tSeason" ("seasId","seasLab")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/726.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 4, 17, 'DBA', 'tFormat' )
go

LOAD TABLE "DBA"."tFormat" ("formId","formLab")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/727.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 5, 17, 'DBA', 'tTerrain' )
go

LOAD TABLE "DBA"."tTerrain" ("terId","terLab")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/728.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 6, 17, 'DBA', 'tLocation' )
go

LOAD TABLE "DBA"."tLocation" ("locId","locLab")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/729.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 7, 17, 'DBA', 'tSnackUnit' )
go

LOAD TABLE "DBA"."tSnackUnit" ("snUnId","snUnLab")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/730.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 8, 17, 'DBA', 'tMonsterGender' )
go

LOAD TABLE "DBA"."tMonsterGender" ("monGenId","monGenLab")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/734.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 9, 17, 'DBA', 'tMonsterType' )
go

LOAD TABLE "DBA"."tMonsterType" ("monTypId","monTypLab")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/735.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 10, 17, 'DBA', 'tMonsterSubtype' )
go

LOAD TABLE "DBA"."tMonsterSubtype" ("monSubtypId","monSubtypLab")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/736.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 11, 17, 'DBA', 'tMonsterSpecies' )
go

LOAD TABLE "DBA"."tMonsterSpecies" ("monSpecId","monSpecLab")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/737.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 12, 17, 'DBA', 'tMonster' )
go

LOAD TABLE "DBA"."tMonster" ("monId","monName","monGenId","monTypId","monSubtypId","monSpecId")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/738.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 13, 17, 'DBA', 'tEpisode' )
go

LOAD TABLE "DBA"."tEpisode" ("epId","serId","netId","seasId","epTitle","epDateAired","epRunTime","terId","locId","epSnNb","snUnId")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/740.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 14, 17, 'DBA', 'tVoiceActor' )
go

LOAD TABLE "DBA"."tVoiceActor" ("vaId","vaFirstName","vaLastName")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/742.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 15, 17, 'DBA', 'tEpisodeMonster' )
go

LOAD TABLE "DBA"."tEpisodeMonster" ("epId","monId")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/743.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 16, 17, 'DBA', 'tEpisodeVoiceActor' )
go

LOAD TABLE "DBA"."tEpisodeVoiceActor" ("epId","charId","vaId")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/744.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

call sa_unload_display_table_status( 17737, 17, 17, 'DBA', 'tCharacters' )
go

LOAD TABLE "DBA"."tCharacters" ("charId","charName")
    FROM 'C:/Users/J/Documents/Sybase/ScoobyDoo/unload/745.dat'
    FORMAT 'TEXT' QUOTES ON
    ORDER OFF ESCAPES ON
    CHECK CONSTRAINTS OFF COMPUTES OFF
    STRIP OFF DELIMITED BY ','
    ENCODING 'UTF-8'
go

commit work
go


-------------------------------------------------
--   Create indexes
-------------------------------------------------

call sa_unload_display_table_status( 17738, 1, 17, 'DBA', 'tNetwork' )
go

call sa_unload_display_table_status( 17738, 2, 17, 'DBA', 'tSeries' )
go

ALTER TABLE "DBA"."tSeries"
    ADD FOREIGN KEY "fkFormat" ("formId")
    REFERENCES "DBA"."tFormat" ("formId")
    
go

call sa_unload_display_table_status( 17738, 3, 17, 'DBA', 'tSeason' )
go

call sa_unload_display_table_status( 17738, 4, 17, 'DBA', 'tFormat' )
go

call sa_unload_display_table_status( 17738, 5, 17, 'DBA', 'tTerrain' )
go

call sa_unload_display_table_status( 17738, 6, 17, 'DBA', 'tLocation' )
go

call sa_unload_display_table_status( 17738, 7, 17, 'DBA', 'tSnackUnit' )
go

call sa_unload_display_table_status( 17738, 8, 17, 'DBA', 'tMonsterGender' )
go

call sa_unload_display_table_status( 17738, 9, 17, 'DBA', 'tMonsterType' )
go

call sa_unload_display_table_status( 17738, 10, 17, 'DBA', 'tMonsterSubtype' )
go

call sa_unload_display_table_status( 17738, 11, 17, 'DBA', 'tMonsterSpecies' )
go

call sa_unload_display_table_status( 17738, 12, 17, 'DBA', 'tMonster' )
go

ALTER TABLE "DBA"."tMonster"
    ADD NOT NULL FOREIGN KEY "fkMonsterGender" ("monGenId")
    REFERENCES "DBA"."tMonsterGender" ("monGenId")
    
go

ALTER TABLE "DBA"."tMonster"
    ADD NOT NULL FOREIGN KEY "fkMonsterType" ("monTypId")
    REFERENCES "DBA"."tMonsterType" ("monTypId")
    
go

ALTER TABLE "DBA"."tMonster"
    ADD NOT NULL FOREIGN KEY "fkMonsterSubtype" ("monSubtypId")
    REFERENCES "DBA"."tMonsterSubtype" ("monSubtypId")
    
go

ALTER TABLE "DBA"."tMonster"
    ADD NOT NULL FOREIGN KEY "fkMonsterSpecies" ("monSpecId")
    REFERENCES "DBA"."tMonsterSpecies" ("monSpecId")
    
go

call sa_unload_display_table_status( 17738, 13, 17, 'DBA', 'tEpisode' )
go

ALTER TABLE "DBA"."tEpisode"
    ADD NOT NULL FOREIGN KEY "fkSeries" ("serId")
    REFERENCES "DBA"."tSeries" ("serId")
    
go

ALTER TABLE "DBA"."tEpisode"
    ADD NOT NULL FOREIGN KEY "fkNetwork" ("netId")
    REFERENCES "DBA"."tNetwork" ("netId")
    
go

ALTER TABLE "DBA"."tEpisode"
    ADD NOT NULL FOREIGN KEY "fkSeason" ("seasId")
    REFERENCES "DBA"."tSeason" ("seasId")
    
go

ALTER TABLE "DBA"."tEpisode"
    ADD NOT NULL FOREIGN KEY "fkTerrain" ("terId")
    REFERENCES "DBA"."tTerrain" ("terId")
    
go

ALTER TABLE "DBA"."tEpisode"
    ADD NOT NULL FOREIGN KEY "fkLocation" ("locId")
    REFERENCES "DBA"."tLocation" ("locId")
    
go

ALTER TABLE "DBA"."tEpisode"
    ADD NOT NULL FOREIGN KEY "fkSnackUnit" ("snUnId")
    REFERENCES "DBA"."tSnackUnit" ("snUnId")
    
go

call sa_unload_display_table_status( 17738, 14, 17, 'DBA', 'tVoiceActor' )
go

call sa_unload_display_table_status( 17738, 15, 17, 'DBA', 'tEpisodeMonster' )
go

ALTER TABLE "DBA"."tEpisodeMonster"
    ADD NOT NULL FOREIGN KEY "fkEpisode" ("epId")
    REFERENCES "DBA"."tEpisode" ("epId")
    
go

ALTER TABLE "DBA"."tEpisodeMonster"
    ADD NOT NULL FOREIGN KEY "fkMonster" ("monId")
    REFERENCES "DBA"."tMonster" ("monId")
    
go

call sa_unload_display_table_status( 17738, 16, 17, 'DBA', 'tEpisodeVoiceActor' )
go

ALTER TABLE "DBA"."tEpisodeVoiceActor"
    ADD NOT NULL FOREIGN KEY "fkEpisode" ("epId")
    REFERENCES "DBA"."tEpisode" ("epId")
    
go

ALTER TABLE "DBA"."tEpisodeVoiceActor"
    ADD NOT NULL FOREIGN KEY "fkCharacter" ("charId")
    REFERENCES "DBA"."tCharacters" ("charId")
    
go

ALTER TABLE "DBA"."tEpisodeVoiceActor"
    ADD NOT NULL FOREIGN KEY "fkVoiceActor" ("vaId")
    REFERENCES "DBA"."tVoiceActor" ("vaId")
    
go

call sa_unload_display_table_status( 17738, 17, 17, 'DBA', 'tCharacters' )
go

commit work
go


-------------------------------------------------
--   Create triggers
-------------------------------------------------

commit
go

