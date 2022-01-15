declare @current_date datetime2 = getdate()

declare @other_date datetime2;
set @other_date = '2022-01-14 11:41:00'

print @current_date
print @other_date

select datediff(hour, @other_date, @current_date)

declare @total_vehicle_count int;
select @total_vehicle_count = count(*)
from vehicles;

if @total_vehicle_count < 10
    begin
        select id, identifier from vehicles
    end
else
    begin
        declare @i int = 10;
        while @i < 15
            begin
                insert into routes(number) values (concat('route ', @i))
                set @i = @i + 1
            end
    end

begin try
    declare @query varchar(255) = concat('select ', 'idx', ' from routes')
    exec(@query)
end try
begin catch
    select error_number()  as code,
           error_message() as message
end catch