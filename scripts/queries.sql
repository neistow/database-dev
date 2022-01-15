SET SHOWPLAN_TEXT On
go
SET SHOWPLAN_ALL On
go
SET SHOWPLAN_XML On
go
SET STATISTICS PROFILE On
go
SET STATISTICS XML On

create table tickets
(
    id             int          not null,
    name           varchar(255) not null,
    price          money        not null,
    expirationDate datetime2    not null,
);

-- |--Table Scan(OBJECT:([transport].[dbo].[Tickets]))
select *
from tickets

drop table tickets;
create table tickets
(
    id             int          primary key,
    name           varchar(255) not null,
    price          money        not null,
    expirationDate datetime2    not null,
);

-- |--Clustered Index Scan(OBJECT:([transport].[dbo].[Tickets].[PK__Tickets__3213E83F6FDD327D]))
select *
from tickets


--   |--Clustered Index Seek(OBJECT:([transport].[dbo].[Tickets].[PK__Tickets__3213E83F6FDD327D]),
--   SEEK:([transport].[dbo].[Tickets].[id]=CONVERT_IMPLICIT(int,[@1],0)) ORDERED FORWARD)
select *
from tickets
where id = 10

create nonclustered index idx_exp_dte on tickets(expirationDate)

-- Clustered Index Scan(OBJECT:([transport].[dbo].[tickets].[PK__tickets__3213E83FD37AF2AF]),
-- WHERE:([transport].[dbo].[tickets].[expirationDate]=getdate()))
select *
from tickets
where expirationDate = GETDATE()

-- |--Nested Loops(Inner Join, OUTER REFERENCES:([transport].[dbo].[tickets].[id]))"
--    |--Index Scan(OBJECT:([transport].[dbo].[tickets].[idx_exp_dte]))
--    |--Clustered Index Seek(OBJECT:([transport].[dbo].[tickets].[PK__tickets__3213E83FD37AF2AF]),
--       SEEK:([transport].[dbo].[tickets].[id]=[transport].[dbo].[tickets].[id]) 
--       LOOKUP ORDERED FORWARD)"

select *
from tickets
         with (index (idx_exp_dte))

create nonclustered index idx_price on tickets(name, price)

-- |--Clustered Index Scan(OBJECT:([transport].[dbo].[tickets].[PK__tickets__3213E83FD37AF2AF]),
-- WHERE:([transport].[dbo].[tickets].[price]=[@1]))
select *
from tickets
where price = 25.5

--   |--Index Scan(OBJECT:([transport].[dbo].[tickets].[idx_price]),
--   WHERE:([transport].[dbo].[tickets].[price]=[@1]))
select name, price
from tickets
where price = 25.5

SET SHOWPLAN_TEXT OFF
go
SET SHOWPLAN_ALL OFF
go
SET SHOWPLAN_XML OFF
go
SET STATISTICS PROFILE OFF
go
SET STATISTICS XML OFF

drop table tickets;