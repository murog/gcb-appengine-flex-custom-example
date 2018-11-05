FROM node:8-alpine as base

FROM base as builder
WORKDIR /usr/src/app
COPY package.json ./
RUN npm install --only=production 
COPY . ./
RUN npm run build

FROM nginx:1.15-alpine

# Copy the nginx configuration file
# Sets up logging for app engine and has nginx listening on port 8080
# App Engine expects runtime to respond to HTTP request at port 8080
COPY --from=builder usr/src/app/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /var/log/app_engine

# Copy over static assets 
COPY --from=builder usr/src/app/build /usr/share/nginx/html
# TODO chmod build ?

EXPOSE 8080
# TODO does nginx need daemon off?
# CMD ["nginx", "-g", "daemon off;"]


