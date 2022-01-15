create trigger veh_insert
    on vehicles
    after insert
    as
    declare cur cursor local for 
        select type_id, count(*) as amount from inserted group by type_id
    declare @type int, @amount int;

    open cur
    fetch next from cur into @type, @amount
    while @@fetch_status = 0
        begin
            update vehicle_types set vehicle_count = vehicle_count + @amount where id = @type
            fetch next from cur into @type, @amount
        end
    close cur
    deallocate cur

-----

create trigger veh_delete
    on vehicles
    after delete 
    as
    declare cur cursor local for
        select type_id, count(*) as amount from deleted group by type_id
    declare @type int, @amount int;

    open cur
    fetch next from cur into @type, @amount
    while @@fetch_status = 0
        begin
            update vehicle_types set vehicle_count = vehicle_count - @amount where id = @type
            fetch next from cur into @type, @amount
        end
    close cur
    deallocate cur
