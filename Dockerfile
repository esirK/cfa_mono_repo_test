FROM ubuntu@sha256:9c152418e380c6e6dd7e19567bb6762b67e22b1d0612e4f5074bda6e6040c64a as ubuntu-22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt install -y clang build-essential  zlib1g-dev  libssl-dev curl

WORKDIR /app

# Using Ubuntu
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get install -y nodejs

# Install bazelisk
RUN npm install -g @bazel/bazelisk && bazelisk 

EXPOSE 8000

# run bazelisk with project and arguments passed as environment variable
CMD [ "bazelisk", "run", "projects/twoopstracker:twoopstracker", "--", "runserver", "0.0.0.0:8000" ]
# The projects/twoopstracker:twoopstracker should be passed as an environment variable
# CMD [ "bazelisk", "run", $PROJECT ]

COPY . /app
