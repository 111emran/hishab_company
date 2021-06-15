FROM nginx:alpine
COPY nginx-conf-file /etc/nginx/conf.d/default.conf
RUN mkdir /hishab_directory
COPY ./* /hishab_directory
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
