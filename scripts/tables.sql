create table vehicle_types
(
    id   int primary key identity (1,1),
    name varchar(64) not null unique
)

create table routes
(
    id     int primary key identity (1,1),
    number varchar(64) not null
)

create table vehicles
(
    id         int primary key identity (1,1),
    identifier char(24) not null unique,
    seats      tinyint check (seats > 10 and seats < 100),
    type_id    int      not null references vehicle_types (id)
)

create table vehicle_routes
(
    vehicle_id int references vehicles (id),
    route_id   int references routes (id),
    active     bit not null default 0
)

create table vehicle_stops
(
    id       int primary key identity (1,1),
    name     varchar(256) not null unique,
    route_id int references routes (id)
)

create table vehicle_schedule
(
    id          int primary key identity (1,1),
    vehicle_id  int  not null references vehicles (id),
    stop_id     int  not null references vehicle_stops (id),
    arrive_time time not null,
    depart_time time not null
)
