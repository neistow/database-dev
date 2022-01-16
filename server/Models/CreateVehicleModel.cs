namespace TransportApi.Models;

public class CreateVehicleModel
{
    public string Identifier { get; set; } = null!;
    public int Seats { get; set; }
    public int TypeId { get; set; }
}