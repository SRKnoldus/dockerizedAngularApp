### STAGE 1: Build ###
FROM node:12.7-alpine AS build
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm cache clean --force
RUN npm i
COPY . .
RUN npm run build

### STAGE 2: Run ###
FROM nginx:1.17.1-alpine
### Do note the project name, as 'ng build or npm run build'
### will create the directory structure like this
### /dist/your-project-name
COPY --from=build /usr/src/app/dist/dockerizedAngularApp /usr/share/nginx/html
