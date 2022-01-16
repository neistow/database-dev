using FluentValidation;
using TransportApi.Models;

namespace TransportApi.Validators;

public class CreateVehicleModelValidator : AbstractValidator<CreateVehicleModel>
{
    public CreateVehicleModelValidator()
    {
        RuleFor(m => m.Identifier).NotEmpty().MaximumLength(24);
        RuleFor(m => m.Seats).GreaterThan(20).LessThan(100);
        RuleFor(m => m.TypeId).GreaterThan(0);
    }
}