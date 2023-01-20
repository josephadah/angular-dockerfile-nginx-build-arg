# base image
FROM node:14 as build

# set working directory
WORKDIR /app

ARG SERVER_ENV
ENV SERVER_ENV=$SERVER_ENV

# install dependencies
COPY package.json .
RUN npm install

# add app
COPY . .

# generate build
RUN npm run build-$SERVER_ENV --output-path=dist

### STAGE 2:RUN ###
# Defining nginx image to be used
FROM nginx:1.16.0-alpine AS ngi
# Copying compiled code and nginx config to different folder
COPY --from=build /app/dist /usr/share/nginx/html

COPY /src/nginx.conf  /etc/nginx/conf.d/default.conf
# Exposing a port, here it means that inside the container 
EXPOSE 80
