// parent.service.ts
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Parent, CreateParentDto, UpdateParentDto } from './parent';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ParentService {
  private apiUrl = `${environment.apiUrl}/parent`;

  constructor(private http: HttpClient) {}

  getParents(): Observable<Parent[]> {
    return this.http.get<Parent[]>(`${this.apiUrl}/`);
  }

  getParentById(id: number): Observable<Parent> {
    return this.http.get<Parent>(`${this.apiUrl}/${id}`);
  }

  createParent(parent: CreateParentDto): Observable<Parent> {
    return this.http.post<Parent>(`${this.apiUrl}/`, parent);
  }

  updateParent(id: number, parent: UpdateParentDto): Observable<Parent> {
    return this.http.patch<Parent>(`${this.apiUrl}/${id}`, parent);
  }

  deleteParent(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }

  deleteMultipleParents(ids: number[]): Observable<void> {
    return this.http.post<void>(`${this.apiUrl}/deleteMultiple`, { ids });
  }
}