-- display vehicle types and associated routes
-- where vehicle total seat count > 100
select vt.name, r.id
from vehicle_types vt
         left join vehicles v on vt.id = v.type_id
         left join vehicle_routes vr on v.id = vr.vehicle_id
         left join routes r on r.id = vr.route_id
group by vt.name, r.id
having sum(v.seats) > 100

go

-- display assigned routes count for vehicle
select identifier, assigned_routes
from (
         select v.id, v.identifier, sum(vr.route_id) as assigned_routes
         from vehicles v
                  join vehicle_routes vr on v.id = vr.vehicle_id
         group by v.id, v.identifier
     ) assigned_veh_routes
where assigned_routes > 1

go

-- display count of vehicles by type
select vt.name,
       (select count(*) from vehicles where type_id = vt.id) as veh_count
from vehicle_types vt

go

-- Variable demo
declare @free_transport table(transport_id int)

insert into @free_transport(transport_id)
select v.id as transport_id
from vehicles v
         left join vehicle_routes vr on v.id = vr.vehicle_id
where route_id is null

select * from @free_transport

go

-- Temp table demo
drop table if exists #Temp
create table #Temp(veh_type varchar(64), max_seats int);

insert into #Temp
select vt.name, max(v.seats)
from vehicles v
         left join vehicle_types vt on vt.id = v.type_id
group by vt.name

select * from #Temp

go

-- CTE demo
with veh_type_with_veh_count as (
    select vt.id, count(*) as vehicle_count
    from vehicle_types vt
             left join vehicles v on vt.id = v.type_id
    group by vt.id
)
select avg(vehicle_count)
from veh_type_with_veh_count

go

-- view demo
create view trans_port_type_veh_units
as
select vt.name,
       (select count(*) from vehicles where type_id = vt.id) as veh_count
from vehicle_types vt

select vt.id, vt.name, t.veh_count
from trans_port_type_veh_units t
         left join vehicle_types vt on vt.name = t.name

go
