# Personal Dockerfiles

## Dockerfile.NGC.DGX
* ubuntu==20.04
* cuda==11.3.1
* cuDNN==8.2.1
* python==3.8.10
* pytorch==1.9.0
* torchvision==0.10.0
* opencv-python==4.5.3
* etc

In addition, some additional packages are installed for transferring files between NVIDIA DGX and external source or NAS.
* rsync==3.1.3
* lftp==4.8.4

To build this image, run
```
docker build -f Dockerfile.NGC.DGX -t [name:tag] .
```

## Dockerfile_base
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
## How to use
If you want to use gpus before using Docker, you have to install `nvidia-container-toolkit`.
```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
```
```
sudo apt-get update && sudo apt-get install -y nvidia-docker2
```
To run a container, run
```
docker run -it -gpus all --shm-size=1gb --name [container_name] -v [directory]:/workspace [name:tag]
```
Here, `directory` means the directory you want to mount on the container in order to access to the local filesystem. 
