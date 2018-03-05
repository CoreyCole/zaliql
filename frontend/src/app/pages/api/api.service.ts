import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { map } from 'rxjs/operators';

// zql data
import { apiData } from './api.data';

@Injectable()
export class ApiService {
  public apiUrl: string;
  public functions;

  constructor(private http: HttpClient) {
    this.apiUrl = apiData.apiUrl;
    this.functions = apiData.functions;
  }

  public queryTableNames(): Observable<string[]> {
    return this.http.get(`${this.apiUrl}/tables`).pipe(
      map(data => data['tables'])
    );
  }

  public queryColumnNames(tableName: string): Observable<string[]> {
    return this.http.get(`${this.apiUrl}/columns/${tableName}`).pipe(
      map(data => data['columns'])
    );
  }

  public callFunction(functionName: string, functionParamData: { [paramName: string]: string | string[] }): Observable<any> {
    console.log(functionParamData);
    return this.http.post(`${this.apiUrl}/function/${functionName}`, {}, { params: functionParamData });
  }

}
