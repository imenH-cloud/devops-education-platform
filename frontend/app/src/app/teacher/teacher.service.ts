import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Teacher {
  id?: number;
  name: string;
  email: string;
  subject: string;
}

@Injectable({
  providedIn: 'root'
})
export class TeacherService {
  private baseUrl = `${environment.apiUrl}/teachers`;

  constructor(private http: HttpClient) {}

  create(teacher: Teacher): Observable<Teacher> {
    return this.http.post<Teacher>(`${this.baseUrl}`, teacher);
  }

  findAll(page: number = 1, limit: number = 10): Observable<any> {
    let params = new HttpParams()
      .set('page', page.toString())
      .set('limit', limit.toString());
    return this.http.get<any>(`${this.baseUrl}`, { params });
  }

  findOne(id: number): Observable<Teacher> {
    return this.http.get<Teacher>(`${this.baseUrl}/${id}`);
  }

  update(id: number, teacher: Partial<Teacher>): Observable<Teacher> {
    return this.http.patch<Teacher>(`${this.baseUrl}/${id}`, teacher);
  }

  delete(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}/${id}`);
  }

  search(query: string): Observable<Teacher[]> {
    return this.http.get<Teacher[]>(`${this.baseUrl}/search`, {
      params: new HttpParams().set('query', query)
    });
  }
}