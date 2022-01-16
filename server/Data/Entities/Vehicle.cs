namespace TransportApi.Data.Entities;

public class Vehicle
{
    public int Id { get; set; }
    public string Identifier { get; set; } = null!;
    public int Seats { get; set; }

    public int TypeId { get; set; }
    public Type Type { get; set; } = null!;

    public ICollection<VehicleRoute> VehicleRoutes { get; set; } = null!;
}