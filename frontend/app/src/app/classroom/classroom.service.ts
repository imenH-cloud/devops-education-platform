import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Classroom {
  id?: number;
  name: string;
  level: string;
  capacity: number;
  description: string;
}

@Injectable({ providedIn: 'root' })
export class ClassroomService {
  private http = inject(HttpClient);
  private apiUrl = `${environment.apiUrl}/classroom`;
  
  getAll(): Observable<Classroom[]> { return this.http.get<Classroom[]>(this.apiUrl); }
  findAll(): Observable<Classroom[]> { return this.getAll(); }
  findOne(id: number): Observable<Classroom> { return this.http.get<Classroom>(`${this.apiUrl}/${id}`); }
  create(classroom: Classroom): Observable<Classroom> { return this.http.post<Classroom>(this.apiUrl, classroom); }
  update(id: number, classroom: Classroom): Observable<Classroom> { return this.http.patch<Classroom>(`${this.apiUrl}/${id}`, classroom); }
  delete(id: number): Observable<any> { return this.http.delete(`${this.apiUrl}/${id}`); }
  remove(id: number): Observable<any> { return this.delete(id); }
}
