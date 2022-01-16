using FluentValidation;
using FluentValidation.AspNetCore;
using Microsoft.EntityFrameworkCore;
using TransportApi.Data;
using TransportApi.Data.Entities;
using TransportApi.Models;
using TransportApi.Validators;

var builder = WebApplication.CreateBuilder(args);

var sqlServerConnection = builder.Configuration.GetConnectionString("SqlServer");
builder.Services.AddDbContext<TransportDbContext>(o => o.UseSqlServer(sqlServerConnection));

builder.Services.AddFluentValidation();
builder.Services.AddValidatorsFromAssembly(typeof(CreateVehicleModelValidator).Assembly);

builder.Services.AddCors(o => o.AddDefaultPolicy(pb => pb.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod()));

var app = builder.Build();

app.UseCors();

app.MapGet("/vehicles", (TransportDbContext context) => context.Vehicles.ToListAsync());
app.MapGet("/vehicles/{id}", async (int id, TransportDbContext context) =>
{
    var vehicle = await context.Vehicles.FindAsync(id);
    return vehicle == null ? Results.NotFound() : Results.Ok(vehicle);
});

app.MapPost("/vehicles", async (CreateVehicleModel model, TransportDbContext context) =>
{
    var vehicle = new Vehicle
    {
        Identifier = model.Identifier,
        Seats = model.Seats,
        TypeId = model.TypeId
    };
    context.Vehicles.Add(vehicle);
    await context.SaveChangesAsync();

    return Results.Created($"/vehicles/{vehicle.Id}", vehicle);
});

app.MapPut("/vehicles", async (UpdateVehicleModel model, TransportDbContext context) =>
{
    var vehicle = await context.Vehicles.FindAsync(model.Id);
    if (vehicle == null)
    {
        return Results.NotFound();
    }

    vehicle.Identifier = model.Identifier;
    vehicle.Seats = model.Seats;
    vehicle.TypeId = model.TypeId;

    await context.SaveChangesAsync();

    return Results.Ok(vehicle);
});

app.MapDelete("/vehicles/{id}", async (int id, TransportDbContext context) =>
{
    var vehicle = await context.Vehicles.FindAsync(id);
    if (vehicle == null)
    {
        return Results.NotFound();
    }

    context.Remove(vehicle);
    await context.SaveChangesAsync();

    return Results.Ok();
});

app.Run();