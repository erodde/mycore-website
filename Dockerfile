# Use a base image with node and yarn
FROM node:22-alpine

# Add metadata labels
LABEL org.opencontainers.image.source="https://github.com/erodde/mycore-website"
LABEL org.opencontainers.image.description="MyCoRe website docker image"
LABEL org.opencontainers.image.licenses="MIT"

# Set the working directory
WORKDIR /app

# Install curl and git
RUN apk add --no-cache curl git

# Install gohugo extended 0.89.4
ENV HUGO_VERSION=0.89.4
RUN curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz | tar xzf - -C /tmp && \
    mv /tmp/hugo /usr/local/bin/hugo && \
    chmod +x /usr/local/bin/hugo

# Copy the pom.xml to the container
COPY package.json yarn.lock /app/

# Load all dependencies necessary for building
RUN yarn install --immutable --immutable-cache --check-cache

# Set default args needed inside the entrypoint
ARG MYCORE_WEBSITE_REPO_URL="https://github.com/MyCoRe-Org/mycore-website.git"
ARG MYCORE_BASE_URL="https://www.mycore.de"

# Set the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# debugging
RUN ls -la /
RUN cat /entrypoint.sh

ENTRYPOINT /entrypoint.sh ${MYCORE_WEBSITE_REPO_URL} ${MYCORE_BASE_URL}
