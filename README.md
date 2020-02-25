# Description

Angular 8 based project.
This project shows us how to deploy any angular app into a docker container via using multi-stage
docker image for smaller image footprint. This DEMO is prepared in Ubuntu version 18.04.

## Step 1

Make sure you have install latest angular and docker packages in your system
Install Angular - https://angular.io/guide/setup-local
Install Docker  - https://docs.docker.com/install/linux/docker-ce/ubuntu/

## Step 2

Create a angular project - 
- Command : ng new your-project-name
Get inside the newly created project directory and create two new files at root.
- Command : touch Dockerfile .dockerignore

## Step 3 

The Docker image will be of multi-stage kind. First stage is for compiling the source code into production ready code and second stage would be for running the compiled app into a docker image.
Only compiled output from first stage will be moved to the second so small size of the container will be preserved.

Open up any editor of your choice and fire up the Dockerfile. Copy paste the below code into the Dockerfile(copy content inside the ``).
- `### STAGE 1: Build ###`
- `FROM node:12.7-alpine AS build`
- `WORKDIR /usr/src/app`
- `COPY package.json package-lock.json ./`
- `RUN npm cache clean --force`
- `RUN npm i`
- `COPY . .`
- `RUN npm run build`

Description for the above code
- ( FROM ) getting node Docker image from registry and naming the compilation stage as build (so we will be able to refer to it in another stage).
- ( WORKDIR ) setting default work directory.
- ( COPY ) copying package.json file from local root directory — this file contains all dependencies that our app requires.
- ( RUN ) installing necessary libraries (based on a file copied in previous step) and cleaning the cache of the node forcefully otherwise it will throw error of core-js being outdated.
- ( COPY ) copying all remaining files with a source code.
- ( RUN ) and finally compiling our app.

## Step 4

We don't need node_modules and dist directory in our running app. So, we can ignore them by placing them in .dockerignore, which works similarly as of .gitignore.
Copy paste this in .dockerignore
- dist
- node_modules

## Step 5

To run the compiled code, add the following code in Dockerfile
- `### STAGE 2: Run ###`
- `FROM nginx:1.17.1-alpine`
- `COPY --from=build /usr/src/app/dist/your-project-name /usr/share/nginx/html`

Descriptions for the above code
- ( FROM ) For running the angular app we are using an nginx server and this is its base image
- ( COPY ) We are copying content from first stage which was build stage and putting that content into the nginx directory in which it will be rendered.
- To learn more about nginx follow this 
  - https://nginx.org/en/docs/, 
  - https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts

## Step 6

Your Dockerfile should look like this

- `### STAGE 1: Build ###`
- `FROM node:12.7-alpine AS build`
- `WORKDIR /usr/src/app`
- `COPY package.json package-lock.json ./`
- `RUN npm cache clean --force`
- `RUN npm i`
- `COPY . .`
- `RUN npm run build`
- `### STAGE 2: Run ###`
- `FROM nginx:1.17.1-alpine`
- `COPY --from=build /usr/src/app/dist/your-project-name /usr/share/nginx/html`

## Step 7

Now let's build the image. At project root, open up the terminal and fire up this command
- Command : docker build -t dockerized-angular-app-multistage-image .

Once image is created, execute this
- Command : docker run --name dockerized-angular-app-multistage-image -d -p 8080:80 dockerized-angular-app-multistage-image

And, voila you have successfully dockerized your angular app.
Just visit this address in any browser
- http://localhost:8080/
