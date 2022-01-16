using System.ComponentModel.DataAnnotations;

namespace TransportApp.ViewModels.Vehicle;

public class UpdateVehicleViewModel : CreateVehicleViewModel
{
    [Required]
    [Range(1, int.MaxValue)]
    public int Id { get; set; }
}