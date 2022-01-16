using FluentValidation;
using TransportApi.Models;

namespace TransportApi.Validators;

public class UpdateVehicleModelValidator : AbstractValidator<UpdateVehicleModel>
{
    public UpdateVehicleModelValidator()
    {
        RuleFor(m => m.Id).GreaterThan(0);

        Include(new CreateVehicleModelValidator());
    }
}