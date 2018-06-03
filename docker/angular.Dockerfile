FROM node:carbon-alpine

RUN npm install -g @angular/cli@latest

WORKDIR /frontend

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install

COPY angular.json angular.json
COPY tsconfig.json tsconfig.json
COPY tslint.json tslint.json

CMD ["ng", "serve", "--host", "0.0.0.0"]
