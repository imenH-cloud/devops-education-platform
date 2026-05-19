import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Parent } from './parent';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ParentService {
  private http = inject(HttpClient);
  private apiUrl = `${environment.apiUrl}/parent`;

  getAll(): Observable<Parent[]> {
    return this.http.get<Parent[]>(this.apiUrl);
  }

  getParents(): Observable<Parent[]> {
    return this.getAll();
  }

  getById(id: number): Observable<Parent> {
    return this.http.get<Parent>(`${this.apiUrl}/${id}`);
  }

  getParentById(id: number): Observable<Parent> {
    return this.getById(id);
  }

  create(parent: Partial<Parent>): Observable<Parent> {
    return this.http.post<Parent>(this.apiUrl, parent);
  }

  createParent(parent: Partial<Parent>): Observable<Parent> {
    return this.create(parent);
  }

  update(id: number, parent: Partial<Parent>): Observable<Parent> {
    return this.http.patch<Parent>(`${this.apiUrl}/${id}`, parent);
  }

  updateParent(id: number, parent: Partial<Parent>): Observable<Parent> {
    return this.update(id, parent);
  }

  delete(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/${id}`);
  }

  deleteParent(id: number): Observable<any> {
    return this.delete(id);
  }

  deleteMultipleParents(ids: number[]): Observable<any> {
    return this.http.post(`${this.apiUrl}/delete-multiple`, { ids });
  }
}
