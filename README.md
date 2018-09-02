# base-docker-images
A collection of alpine-based images with support for both x86 and arm

I created this tree of images to provide very slim alpine-based images. By using alpine, it's possible to build all of the images on x86 or for arm (raspberry pi).

`./build.sh -t rpi` to build rpi images.
`./build.sh` to build regular images.
`./build.sh -p` to push images after building.

Each image is just built with the name of the directory; the build script builds things in order of dependencies.

After building all of the images, they will be available in docker, e.g.

docker run -it ipython

# Credit

I built most of these images and tested them for both alpine and regular. In some cases, I used existing work as reference and will credit them here:

- nginx-* images were based heavily off the structure of https://github.com/tiangolo/uwsgi-nginx-docker
- python3 images based off of https://github.com/frol/docker-alpine-python3
