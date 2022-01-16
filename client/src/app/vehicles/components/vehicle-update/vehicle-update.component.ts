import { Component, OnDestroy } from '@angular/core';
import { Vehicle } from 'src/app/vehicles/models';
import { VehicleService } from 'src/app/vehicles/services';
import { map, Observable, Subject, switchMap, takeUntil } from 'rxjs';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
    selector: 'app-vehicle-update',
    templateUrl: './vehicle-update.component.html',
    styleUrls: ['./vehicle-update.component.scss']
})
export class VehicleUpdateComponent implements OnDestroy {

    private unsubscribe = new Subject<void>()

    public vehicle$: Observable<Vehicle>;

    constructor(
        private vehicleService: VehicleService,
        private router: Router,
        private activatedRoute: ActivatedRoute,
    ) {
        this.vehicle$ = this.activatedRoute.paramMap
            .pipe(
                map(m => Number(m.get('id'))),
                switchMap(id => this.vehicleService.getVehicle(id))
            );
    }

    public ngOnDestroy(): void {
        this.unsubscribe.next();
        this.unsubscribe.complete();
    }

    public onSubmit(model: Vehicle) {
        this.vehicleService
            .updateVehicle(model)
            .pipe(takeUntil(this.unsubscribe))
            .subscribe(() => this.router.navigate(['/']))
    }
}
