# Specifies the base image we're extending
FROM node:alpine

# Specify the "working directory" for the rest of the Dockerfile
WORKDIR /src

# Install packages using NPM 5 (bundled with the node:9 image)
COPY ./package.json /src/package.json
COPY ./package-lock.json /src/package-lock.json
RUN npm install --silent  && \
    chmod -s /home/node

# Add application code
COPY ./app /src/app
COPY ./bin /src/bin
COPY ./public /src/public

# Add the nodemon configuration file
COPY ./nodemon.json /src/nodemon.json

# Set environment to "development" by default
ENV NODE_ENV development

# Allows port 12345 to be publicly available
EXPOSE 12345

# Set user as non-privileged alternative to root
USER node:node

# The command uses nodemon to run the application
CMD ["node", "node_modules/.bin/nodemon", "-L", "bin/www"]

# HealthCheck
HEALTHCHECK CMD curl --fail http://localhost:12345/ || exit 1
