import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Student {
  id?: number;
  firstName: string;
  lastName: string;
  dateOfBirth: string;
  gender: string;
  parentId: number;
  classroomId: number;
  diagnosisType: string;
  notes: string;
}

@Injectable({
  providedIn: 'root'
})
export class StudentService {
  private http = inject(HttpClient);
  private apiUrl = `${environment.apiUrl}/student`;

  getAll(): Observable<Student[]> {
    return this.http.get<Student[]>(this.apiUrl);
  }

  getAllStudents(): Observable<Student[]> {
    return this.getAll();
  }

  getById(id: number): Observable<Student> {
    return this.http.get<Student>(`${this.apiUrl}/${id}`);
  }

  getStudentById(id: number): Observable<Student> {
    return this.getById(id);
  }

  create(student: Student): Observable<Student> {
    return this.http.post<Student>(this.apiUrl, student);
  }

  createStudent(student: Student): Observable<Student> {
    return this.create(student);
  }

  update(id: number, student: Student): Observable<Student> {
    return this.http.patch<Student>(`${this.apiUrl}/${id}`, student);
  }

  updateStudent(id: number, student: Student): Observable<Student> {
    return this.update(id, student);
  }

  delete(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/${id}`);
  }

  deleteStudent(id: number): Observable<any> {
    return this.delete(id);
  }
}
