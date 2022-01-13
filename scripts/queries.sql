select top 1 tt.name
from vehicles v
         left join vehicle_types tt on tt.id = v.type_id
group by name
order by count(v.id) desc

go

select r.number, count(v.id) as count
from routes r
         left join vehicle_routes vr on r.id = vr.route_id
         left join vehicles v on v.id = vr.vehicle_id
where v.seats > 29
  and v.seats < 69
group by r.number

go


select vt.name, r.number, sum(v.seats) as total_seats
from vehicle_types vt
         left join vehicles v on vt.id = v.type_id
         left join vehicle_routes vr on v.id = vr.vehicle_id
         left join routes r on r.id = vr.route_id
group by vt.name, r.number

go

select *
from vehicle_types
order by id
offset 2 rows fetch next 3 rows only

