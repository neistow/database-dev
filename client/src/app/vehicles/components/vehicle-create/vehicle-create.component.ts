import { Component, OnDestroy } from '@angular/core';
import { VehicleService } from 'src/app/vehicles/services';
import { Subject, takeUntil } from 'rxjs';
import { Vehicle } from 'src/app/vehicles/models';
import { Router } from '@angular/router';

@Component({
    selector: 'app-vehicle-create',
    templateUrl: './vehicle-create.component.html',
    styleUrls: ['./vehicle-create.component.scss']
})
export class VehicleCreateComponent implements OnDestroy {

    private unsubscribe = new Subject<void>();

    constructor(
        private vehicleService: VehicleService,
        private router: Router
    ) {
    }

    public ngOnDestroy(): void {
        this.unsubscribe.next();
        this.unsubscribe.complete();
    }

    public onSubmit(vehicle: Vehicle): void {
        this.vehicleService
            .createVehicle(vehicle)
            .pipe(takeUntil(this.unsubscribe))
            .subscribe(() => this.router.navigate(['/']))
    }

}
