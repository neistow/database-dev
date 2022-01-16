namespace TransportApi.Data.Entities;

public class VehicleRoute
{
    public bool Active { get; set; }

    public Vehicle? Vehicle { get; set; }
    public int? VehicleId { get; set; }
    
    public Route? Route { get; set; }
    public int? RouteId { get; set; }
}