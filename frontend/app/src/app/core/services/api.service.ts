import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  timestamp: string;
}

export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  private baseUrl = '/api';
  private isLoadingSubject = new BehaviorSubject<boolean>(false);
  public isLoading$ = this.isLoadingSubject.asObservable();

  constructor(private http: HttpClient) {}

  private setLoading(loading: boolean) {
    this.isLoadingSubject.next(loading);
  }

  get<T>(endpoint: string, params?: HttpParams): Observable<ApiResponse<T>> {
    this.setLoading(true);
    return this.http
      .get<ApiResponse<T>>(`${this.baseUrl}${endpoint}`, { params })
      .pipe(
        tap(() => this.setLoading(false)),
        catchError((error) => {
          this.setLoading(false);
          throw error;
        }),
      );
  }

  post<T>(endpoint: string, body: any): Observable<ApiResponse<T>> {
    this.setLoading(true);
    return this.http
      .post<ApiResponse<T>>(`${this.baseUrl}${endpoint}`, body)
      .pipe(
        tap(() => this.setLoading(false)),
        catchError((error) => {
          this.setLoading(false);
          throw error;
        }),
      );
  }

  put<T>(endpoint: string, body: any): Observable<ApiResponse<T>> {
    this.setLoading(true);
    return this.http
      .put<ApiResponse<T>>(`${this.baseUrl}${endpoint}`, body)
      .pipe(
        tap(() => this.setLoading(false)),
        catchError((error) => {
          this.setLoading(false);
          throw error;
        }),
      );
  }

  delete<T>(endpoint: string): Observable<ApiResponse<T>> {
    this.setLoading(true);
    return this.http
      .delete<ApiResponse<T>>(`${this.baseUrl}${endpoint}`)
      .pipe(
        tap(() => this.setLoading(false)),
        catchError((error) => {
          this.setLoading(false);
          throw error;
        }),
      );
  }

  // Pagination helper
  getPaginated<T>(
    endpoint: string,
    page: number = 1,
    pageSize: number = 10,
  ): Observable<ApiResponse<PaginatedResponse<T>>> {
    const params = new HttpParams()
      .set('page', page.toString())
      .set('pageSize', pageSize.toString());

    return this.get<PaginatedResponse<T>>(endpoint, params);
  }
}
