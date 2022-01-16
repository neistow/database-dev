import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { Observable } from 'rxjs';
import { CreateVehicleModel, UpdateVehicleModel, Vehicle } from '../models';


@Injectable({
    providedIn: 'root'
})
export class VehicleService {

    private readonly baseUrl: string;

    constructor(
        private client: HttpClient
    ) {
        this.baseUrl = environment.apiUrl;
    }

    public getVehicles(): Observable<Vehicle[]> {
        return this.client.get<Vehicle[]>(`${this.baseUrl}/vehicles`)
    }

    public getVehicle(id: number): Observable<Vehicle> {
        return this.client.get<Vehicle>(`${this.baseUrl}/vehicles/${id}`)
    }

    public createVehicle(model: CreateVehicleModel): Observable<Vehicle> {
        return this.client.post<Vehicle>(`${this.baseUrl}/vehicles`, model);
    }

    public updateVehicle(model: UpdateVehicleModel): Observable<Vehicle> {
        return this.client.put<Vehicle>(`${this.baseUrl}/vehicles`, model);
    }

    public deleteVehicle(id: number): Observable<void> {
        return this.client.delete<void>(`${this.baseUrl}/vehicles/${id}`);
    }
}
