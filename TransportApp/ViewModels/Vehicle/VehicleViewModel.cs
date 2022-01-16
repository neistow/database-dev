namespace TransportApp.ViewModels.Vehicle;

public class VehicleViewModel
{
    public int Id { get; set; }
    public string Identifier { get; set; } = null!;
    public int Seats { get; set; }
    public int TypeId { get; set; }
}
