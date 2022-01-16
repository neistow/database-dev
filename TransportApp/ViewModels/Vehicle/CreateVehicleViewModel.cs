using System.ComponentModel.DataAnnotations;

namespace TransportApp.ViewModels.Vehicle;

public class CreateVehicleViewModel
{
    [Required]
    [StringLength(24)]
    public string Identifier { get; set; } = null!;

    [Required]
    [Range(10, 100)]
    public int Seats { get; set; }
    
    [Required]
    [Range(0, int.MaxValue)]
    public int TypeId { get; set; }
}