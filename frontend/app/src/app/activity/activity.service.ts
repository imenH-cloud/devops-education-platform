import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Activity {
  id?: number;
  title?: string;
  name?: string;
  description: string;
  studentId?: number;
  type: string;
  date: string;
  duration: number;
  notes?: string;
  location?: string;
  isCompleted?: boolean;
  classroom?: { id: number };
  classroomId?: number;
  metadata?: {
    resources?: string[];
    attachments?: string[];
    comments?: string;
  };
}

@Injectable({ providedIn: 'root' })
export class ActivityService {
  private http = inject(HttpClient);
  private apiUrl = `${environment.apiUrl}/activity`;
  
  getAll(): Observable<Activity[]> { return this.http.get<Activity[]>(this.apiUrl); }
  findAll(): Observable<Activity[]> { return this.getAll(); }
  getById(id: number): Observable<Activity> { return this.http.get<Activity>(`${this.apiUrl}/${id}`); }
  create(activity: Activity): Observable<Activity> { return this.http.post<Activity>(this.apiUrl, activity); }
  update(id: number, activity: Activity): Observable<Activity> { return this.http.patch<Activity>(`${this.apiUrl}/${id}`, activity); }
  delete(id: number): Observable<any> { return this.http.delete(`${this.apiUrl}/${id}`); }
}
