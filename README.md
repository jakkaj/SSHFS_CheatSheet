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

## SSH from Windows

In Windows once the FUSE driver is installed its as simple as opening Explorer and typing in a drive path in the usual `\\` style notation. 

```
\\sshfs\[locuser=]user@host[!port][\path]
```

![sshfswindows](https://user-images.githubusercontent.com/5225782/53215597-7dd31500-36a5-11e9-9b45-ae77143de95d.gif)

## SSH on Mac and Linux

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

