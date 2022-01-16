namespace TransportApi.Data.Entities;

public class Route
{
    public int Id { get; set; }
    public string Number { get; set; } = null!;

    public ICollection<VehicleRoute> VehicleRoutes { get; set; } = null!;
}