begin transaction
declare @result int
exec sp_populate_vehicles 1, null, @processed_rows = @result output
commit transaction

begin transaction
update vehicles
set seats = seats + 1
if exists(select 1
          from vehicles
          where seats = 99)
    rollback transaction
else
    commit transaction


begin transaction
select *
from vehicles
where seats > 25
select *
from routes
where number like '%oute %'
commit transaction


--- try-catch
begin try
    begin transaction
        update vehicles set seats = seats + 10000
    commit transaction
end try
begin catch
    rollback transaction
end catch

--- nested
begin transaction one
select *
from routes
update routes
set number = concat('_', number)
select *
from routes
begin transaction two
update routes
set number = concat('__', number)
select *
from routes
rollback transaction
select *
from routes

--- savepoints
begin transaction one
update routes
set number = concat('_', number)
select *
from routes

save transaction one

update routes
set number = concat('__', number)
select *
from routes

rollback transaction one

select *
from routes

--- deadlock example

set transaction isolation level serializable
begin transaction
update routes set number = concat('route-', id)
select * from vehicles;
commit tran

--- to fix lower isolation
set transaction isolation level serializable
begin transaction
update vehicles set identifier = identifier
select * from routes
commit transaction

--- read uncommitted deadlock
set transaction isolation level read uncommitted
begin transaction
update vehicles set identifier = identifier
update routes set number = number
commit transaction

set transaction isolation level read uncommitted
begin transaction
update routes set number = number
update vehicles set identifier = identifier
commit transaction