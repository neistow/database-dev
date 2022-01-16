using Dapper;
using Microsoft.AspNetCore.Mvc.RazorPages;
using TransportApp.Data;
using TransportApp.ViewModels;
using TransportApp.ViewModels.Vehicle;

namespace TransportApp.Pages.Vehicle;

public class IndexModel : PageModel
{
    private readonly IConnectionFactory _connectionFactory;

    public IndexModel(IConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public IEnumerable<VehicleViewModel> VehicleList { get; set; } = Array.Empty<VehicleViewModel>();

    public async Task OnGetAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        VehicleList = await connection.QueryAsync<VehicleViewModel>(VehicleListQuery);
    }

    private string VehicleListQuery => @"
        select id as Id,
               identifier as Identifier,
               seats as Seats,
               type_id as TypeId
        from vehicles
    ";
}