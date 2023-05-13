# Use Ubuntu as base image
FROM ubuntu:latest

# Set environment variables
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 19

# Update and install dependencies
RUN apt-get update && \
    apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        wget \
        apt-utils \
    && rm -rf /var/lib/apt/lists/*

# Install docker
RUN curl -fsSL https://get.docker.com | sh

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Install node and npm
RUN /bin/bash -c "source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default"

# Add node and npm to path so the commands are available
RUN echo "export NVM_DIR=\"$NVM_DIR\"" >> ~/.bashrc && \
    echo "[ -s \"$NVM_DIR/nvm.sh\" ] && . \"$NVM_DIR/nvm.sh\"  # This loads nvm" >> ~/.bashrc && \
    echo "[ -s \"$NVM_DIR/versions/node/v$NODE_VERSION/bin\" ] && export PATH=\"$NVM_DIR/versions/node/v$NODE_VERSION/bin:\$PATH\"  # This loads Node.js" >> ~/.bashrc && \
    echo "export NODE_PATH=\"$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules\"" >> ~/.bashrc

RUN ln -s /root/.nvm/versions/node/v19.9.0/bin/node /bin/node
RUN ln -s /root/.nvm/versions/node/v19.9.0/bin/npm /bin/npm

# Set bash as the default command for the container
ENTRYPOINT ["/bin/bash", "-c"]
