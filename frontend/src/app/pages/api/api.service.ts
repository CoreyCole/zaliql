import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { map } from 'rxjs/operators';

// zql data
import { apiData } from './api.data';

import { FunctionData } from '../../models';
import { functionData } from './function-data';

@Injectable()
export class ApiService {
  public apiUrl: string;
  public functions;
  public resultData: any;
  public functionData: any;

  constructor(private http: HttpClient) {
    this.apiUrl = apiData.apiUrl;
    this.functions = apiData.functions;
    const resultDataString = localStorage.getItem('resultData');
    this.resultData = resultDataString ? JSON.parse(resultDataString) : null;
    this.functionData = functionData;
  }

  public setResultData(data: any) {
    this.resultData = data;
    localStorage.setItem('resultData', JSON.stringify(data));
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

  public getFunction(functionName: string): FunctionData {
    return this.functionData[functionName];
  }

  public callFunction(functionName: string, functionParamData: { [paramName: string]: string | string[] | string[][] }): Observable<any> {
    console.log(functionParamData);
    return this.http.post(`${this.apiUrl}/function/${functionName}`, functionParamData);
  }
}
