create database transport;
go;

use transport;
create table transport_types
(
    id   int primary key identity (1,1),
    name varchar(64) not null unique
)
go

create table routes
(
    id             int primary key identity (1,1),
    number         varchar(64) not null,
    transport_type int         not null references transport_types (id)
);
go;

create table vehicles
(
    id int primary key identity (1,1),
    route_id int references routes(id),
    identifier char(24) not null unique,
    seats tinyint check (seats > 10 and seats < 100)
);

insert into transport_types(name) values ('type one');
insert into transport_types(name) values ('type two');
insert into transport_types(name) values ('type three');
insert into transport_types(name) values ('type four');
insert into transport_types(name) values ('type five');
go;

insert into routes(number, transport_type) values ('one', 1);
insert into routes(number, transport_type) values ('two', 2);
insert into routes(number, transport_type) values ('three',3);
go;

insert into vehicles(route_id, identifier, seats) values (1,'AAA', 20);
insert into vehicles(route_id, identifier, seats) values (2,'BBB', 30);
insert into vehicles(route_id, identifier, seats) values (3,'CCC', 40);
insert into vehicles(route_id, identifier, seats) values (3,'DDD', 50);

-- fails

insert into vehicles(route_id, identifier, seats) values (10,'EEE', 50);
insert into vehicles(route_id, identifier, seats) values (1,'DDD', 9);
insert into transport_types(name) values (null);
insert into vehicles(route_id, identifier, seats) values (1,'DDD', 25);
