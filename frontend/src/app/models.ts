export interface NavigationNode {
  url?: string;
  title?: string;
  tooltip?: string;
  hidden?: boolean;
  children?: NavigationNode[];
}

export interface FunctionData {
  name?: string;
  category?: string;
  description?: string;
  returns?: string;
  params?: FunctionParam[];
}

export interface FunctionParam {
  name?: string;
  description?: string;
  type?: string;
  default?: any;
}

export interface FunctionParamUpdate {
  name: string;
  type: string;
  data: string | string[] | string[][];
}
