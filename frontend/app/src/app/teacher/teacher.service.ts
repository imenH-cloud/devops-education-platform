import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../environments/environment';

export interface Teacher {
  id?: number;
  firstName: string;
  lastName: string;
  email: string;
  phoneNumber: string;
  specialization: string;
  qualification: string;
  experience: number;
  availability: string;
}

@Injectable({ providedIn: 'root' })
export class TeacherService {
  private http = inject(HttpClient);
  private apiUrl = `${environment.apiUrl}/teachers`;
  
  getAll(): Observable<Teacher[]> { 
    return this.http.get<any>(this.apiUrl).pipe(
      map(response => response.items || response || [])
    );
  }
  
  create(teacher: Teacher): Observable<Teacher> { 
    return this.http.post<Teacher>(this.apiUrl, teacher); 
  }
  
  delete(id: number): Observable<any> { 
    return this.http.delete(`${this.apiUrl}/${id}`); 
  }
}
