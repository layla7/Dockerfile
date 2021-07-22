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

If you need to install additional packages, just modify `install.sh` which automatically install all the packages you specify.

When we mount a local volume to the container, the ownership of created files or directories belongs to the root user if we don't specify `USER` in Dockerfile. This is a problem because this ownership still belongs to the root user even if we access those files or directories from outside of the container. In order to solve this problem, you should build this image using `--build-arg` to add and use a non-root user. To build this image, run
```
docker build -f Dockerfile.NGC.DGX [--build-arg USERNAME=your_username --build-arg PASSWORD=your_password] [-t name:tag] PATH
```
If you omit those `--build-arg` arguments, there only exists the root user.


## Dockerfile_base
* ubuntu==20.04
* cuda==11.1.1
* python==3.9.5
* pytorch==1.9.0
* torchvision==0.10.0
* numpy==1.21.0

To build the base image, run
```
docker build -f Dockerfile_base [-t name:tag] PATH
```


## How to use
### Running a Docker container
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
docker run [-it] [-gpus all] [--shm-size=1gb] [--name container_name] [-v DIR:/workspace] IMAGE
```
Here, `DIR` means the directory you want to mount on the container in order to access to the local filesystem. 

### Transferring files between NVIDIA DGX and other sources

#### 1. rsync
   ```
   rsync -avzhP SOURCE TARGET [--exclude PATTERN]
   ```
   If you want to exclude some files or directories, add `--exclude PATTERN` recursively as many as you want. For example, suppose you want to transfer a directory `/home/user/foo` from `user@host` to `/workspace` of a container and you want to exclude `bar` and `foobar.py` in this directory. In this case, run the command below, and vice versa. You can also use `--exclude={bar, foobar.py}` for multiple patterns.
   ```
   rsync -avzhP user@host:/home/user/foo /workspace --exclude bar --exclude foobar.py
   ```
#### 2. lftp
   When you want to connect to the server and transfer the files, first connect to the server:
   ```
   lftp -u USER[,PASSWORD] SERVER_IP
   ```
   Note that you can use the Linux command (e.g., `cd`, `rm`, `ls`) when connected.
   Then, run the commands below to transfer directories. In order to exclude some files or directories, add `--exclude PATTERN` as in `rsync`.
   ```
   # remote --> local
   mirror REMOTE_DIR LOCAL_DIR [--exclude PATTERN]

   # local --> remote
   mirror -R LOCAL_DIR REMOTE_DIR [--exclude PATTERN]
   ```

   If you want to transfer files, run the commands below:
   ```
   # remote --> local
   get REMOTE_PATH LOCAL_PATH

   # local --> remote
   put LOCAL_PATH REMOTE_PATH
   ```

   When I use `lftp` in a Docker container, I encountered an error:
   ```
   Fatal Error: Certification verification: Not trusted
   ```
   In order to solve this problem, you need to edit the configuration file of `lftp`. You can just run the command below to do so.
   ```
   echo "set ssl:verify-certificate no" >> ~/.lftp/rc
   ```
   In the image built by `Dockerfile.NGC.DGX`, this job is already done, So you don't have to worry about this.
