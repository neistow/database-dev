create table vehicles_to_insert
(
    row_id     int primary key identity (1,1),
    identifier char(24) unique not null,
    seats      tinyint check (seats > 10 and seats < 100),
    type_id    int             not null,
    route_id   int             not null,
)

create proc sp_populate_vehicles @bulk_update bit, @row_id int, @processed_rows int output
as
declare @added_rows int = 0
    set @processed_rows = 0

declare @id int, @identifier char(24), @seats tinyint, @type_id int, @route_id int
    if @bulk_update = 1
        begin
            declare cur cursor local fast_forward
                for select * from vehicles_to_insert
            open cur

            fetch next FROM cur into @id, @identifier, @seats, @type_id, @route_id
            while @@fetch_status = 0
                begin
                    if not exists(select 1 from routes where id = @route_id)
                        throw 50001, 'route doesnt exist', 1

                    if not exists(select 1 from vehicle_types where id = @type_id)
                        throw 50001, 'type doesnt exist', 1

                    insert into vehicles (identifier, seats, type_id) values (@identifier, @seats, @type_id)
                    insert into vehicle_routes (vehicle_id, route_id, active) values (@@identity, @route_id, 1)
                    delete from vehicles_to_insert where row_id = @id

                    set @processed_rows = @processed_rows + 1
                    set @added_rows = @added_rows + 2

                    fetch next FROM cur into @id, @identifier, @seats, @type_id, @route_id
                end

            close cur
            deallocate cur
        end
    else
        begin
            if @row_id is null
                throw 50001, 'row is null', 1

            select @id = row_id,
                   @identifier = identifier,
                   @seats = seats,
                   @type_id = type_id,
                   @route_id = route_id
            from vehicles_to_insert
            where row_id = @row_id

            if @id is null
                throw 50001, 'row doesnt exist', 1

            if not exists(select 1 from routes where id = @route_id)
                throw 50001, 'route doesnt exist', 1

            if not exists(select 1 from vehicle_types where id = @type_id)
                throw 50001, 'type doesnt exist', 1

            insert into vehicles(identifier, seats, type_id) values (@identifier, @seats, @type_id)
            print @@identity
            insert into vehicle_routes (vehicle_id, route_id, active) values (@@identity, @route_id, 1)
            delete from vehicles_to_insert where row_id = @id

            set @processed_rows = 1
            set @added_rows = 2
        end

    return @added_rows


declare @temp int;
exec sp_populate_vehicles 1, null, @processed_rows = @temp output
print @temp
