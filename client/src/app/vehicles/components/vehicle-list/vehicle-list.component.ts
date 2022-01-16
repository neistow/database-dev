import { Component, OnDestroy } from '@angular/core';
import { VehicleService } from 'src/app/vehicles/services';
import { BehaviorSubject, Observable, Subject, switchMapTo, takeUntil } from 'rxjs';
import { Vehicle } from '../../models';

@Component({
    selector: 'app-vehicle-list',
    templateUrl: './vehicle-list.component.html',
    styleUrls: ['./vehicle-list.component.scss']
})
export class VehicleListComponent implements OnDestroy {

    private unsubscribe = new Subject<void>();

    private refresh = new BehaviorSubject(null);

    public vehicles$: Observable<Vehicle[]>;
    public displayedColumns: string[] = [
        'id',
        'identifier',
        'seats',
        'typeId',
        'actions'
    ];

    constructor(
        private vehicleService: VehicleService
    ) {
        this.vehicles$ = this.refresh.pipe(
            switchMapTo(this.vehicleService.getVehicles())
        );
    }

    public ngOnDestroy(): void {
        this.unsubscribe.next();
        this.unsubscribe.complete();
    }

    public onDelete(vehicle: Vehicle): void {
        this.vehicleService
            .deleteVehicle(vehicle.id)
            .pipe(takeUntil(this.unsubscribe))
            .subscribe(() => this.refresh.next(null));
    }
}
