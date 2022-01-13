-- for each vehicle type display max,min,avg seat count

select *
from vehicle_types vt
         cross apply (
    select max(v.seats) as max_seats,
           min(v.seats) as min_seats,
           avg(v.seats) as avg_seats
    from vehicles v
    where v.type_id = vt.id
) as x;

go

-- sum of seats in vehicle types
select v.id,
       sum(seats) over(partition by v.type_id) as s
from vehicles v

go

-- partition by assigned route count + adding idx to result sequence 
select v.id as vehicle_id,
       count(v.id) as assigned_routes,
       row_number() over(partition by count(v.id) order by count(v.id)) as seq_num
from vehicles v
         join vehicle_routes vr on v.id = vr.vehicle_id
group by v.id

go

-- average seats in veh type
select distinct v.type_id,
                avg(v.seats)
                    over (partition by v.type_id order by v.type_id desc) as avg_seats_in_type
from vehicles v
         left outer join vehicle_types vt on vt.id = v.type_id

go

-- flat average seats
select average, [1] as veh_type_1, [2] as veh_type_2, [3] as veh_type_3
from (select 'average seats' as average, type_id, seats from vehicles) v
         pivot (avg(seats) for type_id in ([1], [2], [3])) pvt

go

-- rollup
select vt.name, count(*) as total_vehicles_of_type, sum(v.seats) total_seats
from vehicle_types vt
         left join vehicles v on vt.id = v.type_id
group by vt.name with rollup 