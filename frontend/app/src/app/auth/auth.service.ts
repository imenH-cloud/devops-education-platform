import { Injectable, PLATFORM_ID, inject } from '@angular/core';
import { Login, User } from './auth';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { isPlatformBrowser } from '@angular/common';

@Injectable({
  providedIn: 'root'
})
export default class AuthService {
  private apiUrl = environment.apiUrl;
  private http = inject(HttpClient);

  loginUser(login: Login): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/auth/login`, login);
  }
}

export function tokenGetter(platformId: object): string {
  if (!isPlatformBrowser(platformId)) {
    console.warn("tokenGetter: Running in a non-browser environment.");
    return "";
  }
  const cookies = document.cookie.split(";").map(c => c.trim());
  const tokenCookie = cookies.find(c => c.startsWith("token="));
  return tokenCookie ? tokenCookie.split("=")[1] : "";
}