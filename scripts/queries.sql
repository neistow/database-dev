create function fn_get_average_seats(@veh_typ int)
    returns int
as
begin
    declare @avg_seats int
    select @avg_seats = avg(seats) from vehicles where type_id = @veh_typ
    return @avg_seats
end
go

select *, fn_get_average_seats(type_id) as avg_type_seats
from vehicles

create function fn_get_total_routes_by_vehicle()
    returns table
        as
        return select v.id, count(vr.route_id) as total_routes
               from vehicles v
                        left join vehicle_routes vr on v.id = vr.vehicle_id
               group by v.id

select r.id, v.identifier, r.total_routes
from fn_get_total_routes_by_vehicle() r
         left join vehicles v on v.id = r.id

create function fn_get_vehicles_with_no_routes()
    returns @vehicles_with_no_routes table
                                     (
                                         id         int,
                                         identifier char(24)
                                     )
as
begin
    insert into @vehicles_with_no_routes
    select v.id, v.identifier
    from vehicles v
             left join vehicle_routes vr on v.id = vr.vehicle_id
    where vr.vehicle_id is null
    return
end

select *
from fn_get_vehicles_with_no_routes()

create function fn_get_top_seats(@type_id int)
    returns table
as
    return select max(v.seats) as top_seats
    from vehicles v
    where v.type_id = @type_id
    

select * from vehicle_types vt cross apply fn_get_top_seats(vt.id)