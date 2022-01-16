import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { VehicleCreateComponent, VehicleListComponent, VehicleUpdateComponent } from './vehicles';

const routes: Routes = [
    { path: '', component: VehicleListComponent },
    { path: 'create', component: VehicleCreateComponent },
    { path: 'vehicles/:id', component: VehicleUpdateComponent }
];

@NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule]
})
export class AppRoutingModule {
}
