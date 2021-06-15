FROM nginx:alpine
RUN mkdir /hishab_directory
COPY ./* /hishab_directory
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
