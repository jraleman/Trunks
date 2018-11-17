# Specifies Node v11 as base image
FROM        node:11 as react-build

# Author contact info
LABEL       maintainer="jraleman@scarletbytes.com"

# Create a working directory called app
WORKDIR     /app

# Copy project repo to docker image
COPY        .                             ./

# Download dependencies and build the react app
RUN         set -ex \
            && yarn \
            && yarn build

# Specifies Alpine Linux with ngnix as base image
FROM        nginx:alpine

# Copy nginx config file and build directory to nginx entry point
# COPY        nginx.conf                    /etc/nginx/conf.d/default.conf
COPY        --from=react-build app/build  /usr/share/nginx/html

# RUN         cat /etc/nginx/conf.d/default.conf
# RUN         ls -la /usr/share/nginx/html

# Expose port 80 (http)
EXPOSE      80

# Run production enviroment
CMD         ["nginx", "-g", "daemon off;"]
