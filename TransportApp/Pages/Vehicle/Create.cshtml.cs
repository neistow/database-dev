using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using TransportApp.Data;
using TransportApp.ViewModels.Vehicle;

namespace TransportApp.Pages.Vehicle;

public class CreateModel : PageModel
{
    private readonly IConnectionFactory _connectionFactory;

    public CreateModel(IConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    [BindProperty]
    public CreateVehicleViewModel Vehicle { get; set; }

    public IActionResult OnGet()
    {
        return Page();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
        {
            return Page();
        }

        using var connection = _connectionFactory.CreateConnection();
        connection.Open();

        using var transaction = connection.BeginTransaction();

        var type = await connection.QueryFirstOrDefaultAsync(
            TypeQuery,
            new { Vehicle.TypeId },
            transaction);
        if (type == null)
        {
            return RedirectToPage("/Error");
        }

        await connection.ExecuteAsync(
            CreateVehicleQuery,
            new { Vehicle.Identifier, Vehicle.Seats, Vehicle.TypeId },
            transaction);
        
        transaction.Commit();

        return RedirectToPage("./Index");
    }

    private string CreateVehicleQuery => @"
        insert into vehicles (identifier, seats, type_id) values(@Identifier, @Seats, @TypeId)
    ";

    private string TypeQuery => @"
        select * from vehicle_types where id = @TypeId
    ";
}