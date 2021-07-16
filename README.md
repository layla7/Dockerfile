# Personal Dockerfiles

## Dockerfile_base: 
* ubuntu==20.04
* cuda==11.1.1
* python==3.9.5
* pytorch==1.9.0
* torchvision==0.10.0
* numpy==1.21.0

To build the base image, run
```
docker build -f Dockerfile_base -t [name:tag] .
```

## Dockerfile
This build is based on the base image built by `Dockerfile_base`. You can modify `Dockerfile` for your own project. If you only need to install additional packages, just modify `install.sh` which automatically install all the packages you specify. To build an image for your project, run
```
docker build -t [name:tag] .
```