alter table vehicle_types
    add vehicle_count int;

declare cur1 cursor local scroll_locks
    for select v.type_id, count(*) c
        from vehicles v
        group by v.type_id
open cur1

declare @t int, @q int;
fetch next from cur1 into @t, @q;

while @@fetch_status = 0
    begin
        update vehicle_types set vehicle_count = @q where id = @t;
        fetch next from cur1 into @t, @q;
    end
close cur1;
deallocate cur1;

-----

declare cur2 cursor local scroll_locks
    for select id
        from vehicle_types
open cur2

declare @type int;
fetch next from cur2 into @type;

declare @type_qty int;
while @@fetch_status = 0
    begin
        select @type_qty = count(*) from vehicles where type_id = @type;
        update vehicle_types set vehicle_count = @type_qty where current of cur2;
        fetch next from cur2 into @type;
    end
close cur2;
deallocate cur2;

-----

update vehicle_types
set vehicle_count = 0;
update vehicle_types
set vehicle_count = (
    select count(*)
    from vehicles
    where type_id = vehicle_types.id)