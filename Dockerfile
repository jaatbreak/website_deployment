FROM nginx:latest
MAINTAINER Aman Singh
WORKDIR /aman_data
COPY ./html /usr/share/nginx/html/
EXPOSE 80
