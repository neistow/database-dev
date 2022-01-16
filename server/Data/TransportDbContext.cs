using Microsoft.EntityFrameworkCore;
using TransportApi.Data.Entities;
using Route = TransportApi.Data.Entities.Route;

namespace TransportApi.Data
{
    public class TransportDbContext : DbContext
    {
        public DbSet<Vehicle> Vehicles { get; set; } = null!;

        public TransportDbContext(DbContextOptions<TransportDbContext> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Vehicle>()
                .HasMany(v => v.VehicleRoutes)
                .WithOne(vr => vr.Vehicle)
                .HasForeignKey(vr => vr.VehicleId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Route>()
                .HasMany(r => r.VehicleRoutes)
                .WithOne(vr => vr.Route)
                .HasForeignKey(vr => vr.RouteId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<VehicleRoute>()
                .HasKey(vr => new { vr.RouteId, vr.VehicleId });

        }
    }
}