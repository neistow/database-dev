import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Vehicle } from 'src/app/vehicles/models';

@Component({
    selector: 'app-vehicle-form',
    templateUrl: './vehicle-form.component.html',
    styleUrls: ['./vehicle-form.component.scss']
})
export class VehicleFormComponent implements OnInit {

    public form!: FormGroup;

    @Input()
    public model?: Vehicle;

    @Output()
    public submit: EventEmitter<Vehicle> = new EventEmitter<Vehicle>();

    constructor(
        private fb: FormBuilder
    ) {
    }

    public ngOnInit(): void {
        const model = this.model;
        this.form = this.fb.group({
            id: [model?.id],
            identifier: [model?.identifier, [Validators.required, Validators.min(1), Validators.maxLength(24)]],
            seats: [model?.seats, [Validators.required, Validators.min(20), Validators.max(100)]],
            typeId: [model?.typeId, [Validators.required, Validators.min(1)]]
        })
    }

    public onSubmit(): void {
        this.submit.emit(this.form.value);
    }
}
