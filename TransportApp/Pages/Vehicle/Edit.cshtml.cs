using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using TransportApp.Data;
using TransportApp.ViewModels.Vehicle;

namespace TransportApp.Pages.Vehicle;

public class EditModel : PageModel
{
    private readonly IConnectionFactory _connectionFactory;

    public EditModel(IConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    [BindProperty] public UpdateVehicleViewModel Vehicle { get; set; }

    public async Task<IActionResult> OnGetAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();

        Vehicle = await connection.QueryFirstOrDefaultAsync<UpdateVehicleViewModel>(GetVehicleQuery, new { id });
        if (Vehicle == null)
        {
            return NotFound();
        }

        return Page();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
        {
            return Page();
        }

        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            UpdateVehicleQuery,
            new { Vehicle.Id, Vehicle.Identifier, Vehicle.Seats, Vehicle.TypeId });

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

    private string UpdateVehicleQuery => @"
        update vehicles set 
                            identifier = @Identifier,
                            seats = @Seats,
                            type_id = @TypeId
        where id = @Id
    ";
}