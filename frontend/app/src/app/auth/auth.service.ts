import { Injectable, PLATFORM_ID, inject } from '@angular/core';
import { Login, User } from './auth';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { isPlatformBrowser } from '@angular/common';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export default class AuthService {
  private http = inject(HttpClient);
  private platformId = inject(PLATFORM_ID);

  loginUser(login: Login): Observable<any> {
    // URL relative : sera proxifiée par nginx vers auth-service:3001
    const url = '/auth/login';
    console.log('Login URL:', url);
    console.log('Login payload:', login);
    return this.http.post<any>(url, login);
  }
}

export function tokenGetter(platformId: object): string {
  if (!isPlatformBrowser(platformId)) {
    console.warn("tokenGetter: Running in a non-browser environment.");
    return "";
  }
  
  let token = localStorage.getItem('token');
  if (token) {
    console.log('Token trouvé dans localStorage');
    return token;
  }
  
  const cookies = document.cookie.split(";").map(c => c.trim());
  const tokenCookie = cookies.find(c => c.startsWith("token="));
  if (tokenCookie) {
    const tokenValue = tokenCookie.split("=")[1];
    console.log('Token trouvé dans les cookies');
    return tokenValue;
  }
  
  console.warn('Aucun token trouvé');
  return "";
}