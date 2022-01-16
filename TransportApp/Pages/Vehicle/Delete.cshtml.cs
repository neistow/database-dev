using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using TransportApp.Data;
using TransportApp.ViewModels.Vehicle;

namespace TransportApp.Pages.Vehicle;

public class DeleteModel : PageModel
{
    private readonly IConnectionFactory _connectionFactory;

    public DeleteModel(IConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public VehicleViewModel Vehicle { get; set; }
    
    public async Task<IActionResult> OnGetAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();

        Vehicle = await connection.QueryFirstOrDefaultAsync<VehicleViewModel>(GetVehicleQuery, new { id });
        if (Vehicle == null)
        {
            return RedirectToPage("/Error");
        }

        return Page();
    }

    public async Task<IActionResult> OnPostAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        connection.Open();

        using var transaction = connection.BeginTransaction();
        var vehicle = await connection.QueryFirstOrDefaultAsync<VehicleViewModel>(
            GetVehicleQuery, 
            new{ id },
            transaction);
        if (vehicle == null)
        {
            return RedirectToPage("/Error");
        }

        await connection.ExecuteAsync(DeleteVehicleQuery, new { id }, transaction);
        transaction.Commit();

        return RedirectToPage("./Index");
    }

    private string GetVehicleQuery => @"
        select top 1 
               id as Id,
               identifier as Identifier,
               seats as Seats,
               type_id as TypeId
        from vehicles
        where id = @id
    ";

    private string DeleteVehicleQuery => @"
        delete from vehicle_routes where vehicle_id = @id
        delete from vehicles where id = @id
    ";
}