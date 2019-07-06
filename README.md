# Docker image for cross-building Elixir/Phoenix apps to CentOS/RHEL

Docker image with Erlang, Elixir, and NodeJS on CentOS for cross-building Elixir/Phoenix apps as OTP releases.

Uses [CentOS](https://hub.docker.com/_/centos/) official base image and official binary 
builds of Erlang, Elixir, and NodeJS. 

Versions:

  - CentOS: `7.6` (x86-64) - same as RHEL 7.6
  - Erlang: `22.0.4`
  - Elixir: `1.9.0`
  - NodeJS: `10.16.0`

**Warining**: Do not use this image to deploy the app as the size is quite large at `~598MB`

## Usage

For an example build file that cross-builds a Phoenix app, refer to  [phoenix/build-release.sh](./phoenix/build-release.sh) file.

This file should be placed at the root of the Elixir/Phoenix project and:

```shell
# Run the build script inside a container running this image
# Note: On Windows replace $(pwd) with the actual path

docker run -v $(pwd):/home --rm -it nalakajayasena/elixir-centos /home/build-release.sh


# Run the generated release inside the same container

docker run -v $(pwd):/home --rm -it nalakajayasena/elixir-centos /home/_build/prod/rel/appname/bin/appname
```

The release is tarred and zipped to `releases/appname-version-utc_time_stamp.tar.gz`

## Contributions

> All contributions are welcome- please open an issue and send a pull request.

To build the image locally:

```shell
# Get the source
git clone https://github.com/nalaka/docker-elixir-centos.git

# Build
cd docker-elixir-centos
docker build -t elixir-centos:latest  . 

# Run
docker run --rm -it elixir-centos:latest
```
