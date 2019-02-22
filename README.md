# Remote code with SSHFS 

SSHFS is a FUSE based driver that allows you to use SSH to map remote file system paths to your local machine. It works on Windows, Mac and Linux. 

In this documentation and accompanying video I'll demonstrate how to edit from your PC in to a Docker container that is running on a remote Raspberry PI. Editing code in the container is a great way to get things going when you're still trying to code and figure things out. It certainly beats building the image, copying code or editing on the PI itself. 


## Installation

### Mac 

https://github.com/osxfuse/osxfuse/wiki/SSHFS

### Windows

https://github.com/billziss-gh/sshfs-win

There appear to be others, this is the only one I've tried and it works super well on Windows 10 at least. 


### Linux

```
sudo apt-get install sshfs
```


This [Digital Ocean article](https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh) has some more tips and alternatives. 


## Getting Started

I'll be remote editing to a Rapberry PI. 

- if needed [copy your ssh keys](https://www.ssh.com/ssh/copy-id) to the remote machine. 
- Install [Docker CE](https://www.raspberrypi.org/blog/docker-comes-to-raspberry-pi/) on the PI. 

Docker isn't needed, it's just extra cool to have that extra step of editing files directly in to the container (well sort of, they are actually mapped in by Docker). 

## SSHFS from Windows

In Windows once the FUSE driver is installed its as simple as opening Explorer and typing in a drive path in the usual `\\` style notation. 

```
\\sshfs\[locuser=]user@host[!port][\path]
```

![sshfswindows](https://user-images.githubusercontent.com/5225782/53215597-7dd31500-36a5-11e9-9b45-ae77143de95d.gif)

## SSHFS on Mac and Linux

Use the `sshfs` to mount the remote path in to a folder. Using my Raspberry PI with a static ip of `10.0.0.223`. I like to use ~/mnt rather than /mnt as this code editing path feels more like a user thing than a system wide thing. 

```
cd ~/mnt
mkdir somefolder
sshfs pi@10.0.0.223:/ ./somefolder
```

If you come back later that path my disconnect. You might have to run `sudo umount somefolder` to diconnect and re-run the mount. 

You can also update `fstab` with the mounts. Add an entry to `/etc/fstab`

```
sshfs#pi@10.0.0.223:/ ~/mnt/
```

## Editing

Once you've mapped the path you can navigate to the area that your code is stored on the remote machine and run an editing environment like [Visual Studio Code](https://code.visualstudio.com/) from your local machine. 

### Windows

![sshfscode](https://user-images.githubusercontent.com/5225782/53216013-38afe280-36a7-11e9-8523-2b868a36d9bc.gif)

### Mac and Linux

![sshfscodemac](https://user-images.githubusercontent.com/5225782/53216315-44e86f80-36a8-11e9-9830-5118ae98794e.gif)


## Docker

Editing inside the Docker container involves having the code on your remote machine and the Docker container running with a mapped file system volume. 

Through SSHFS open your code folder on the remote machine with VS Code. 

Then in the code terminal window SSH (normally!) in the remote machine so you have the files open in code and a terminal open in the same location. 

![sshfscoderemote](https://user-images.githubusercontent.com/5225782/53216754-bd036500-36a9-11e9-820a-b825b25046e2.gif)

### Run the container

Clone this repo on to the PI in a folder path that makes sense.

```
git clone https://github.com/jakkaj/SSHFS_CheatSheet.git
```

This repo has a Python sample under `src\python\run.py` that shows the version of OpenCV that is installed. This is a great example because normally getting OpenCV to run on a PI is hard - this will work using just one bash script to run a container!

In the ssh terminal navigate to the dir where the code was checked out and run the `startdocker.sh` script. 

![sshfscoderemoteincontinare](https://user-images.githubusercontent.com/5225782/53218772-95b09600-36b1-11e9-9595-0f8fb1d4aed0.gif)

```
./startdocker.sh
# in the container
cd src/python
python3 run.py
```

This will launch the container, mapping through the ./src path to /src in the container. 

The script is running the following command 

```
docker run -it --rm -v "$(pwd)/src:/src" sgtwilko/rpi-raspbian-opencv
```


This code is being mapped through from the raspberry PI folder path... that you're using ssh to edit. So you can edit this file in VS Code and then run it again via SSH and it will show the edits without having to rebuild the container, and you can do it all from the comfort of your development machine!

The result when running the Python script is showing the OpenCV version that was detected. Too easy!