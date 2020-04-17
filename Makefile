# This is a helper for development of dockerimages

all:
	@ exit 2

debian:
	@ cat dockerfiles/core/debian.Dockerfile > temporary.Dockerfile
	@ cat dockerfiles/default/append-dockerfile.Dockerfile >> temporary.Dockerfile