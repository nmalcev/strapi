# Podman

Podman exists to offer a daemonless container engine for managing OCI-compliant containers on your Linux system.

Advantages:
1. Podman has excellent [rootless support](https://www.redhat.com/sysadmin/rootless-containers-podman), 
2. it can generate [systemd unit files](https://www.redhat.com/sysadmin/podman-shareable-systemd-services) for easily containerizing systemd services, 
3. and it has a [powerful RESTful API](https://www.redhat.com/sysadmin/podman-python-bash) that allows for running Podman on macOS and Windows.

Features:
- Images created by Podman are compatible with other container management tools. The images created by Podman adhere to OCI standard, and hence they can be pushed to other container registries like Docker Hub;
- It can be run as a normal user without requiring root privileges. When running as a non-root user, Podman creates a user namespace inside which it acquires the root permission. This allows it to mount file systems and setup required containers;
- It provides the ability to manage pods. Unlike the other container runtime tools, Podman lets the user manage pods (a group of one or more containers that operate together). Users can perform operations like create, list, inspect on the pods.

Differenets from Docker:
- The commands like podman ps and podman images will not show the containers or images created using Docker. This is because Podman's local repository is /var/lib/containers as opposed to /var/lib/docker maintained by Docker;
- Docker uses a client-server architecture for the containers, whereas Podman uses the traditional fork-exec model common across Linux processes. The containers created using Podman, are the child process of the parent Podman process. This is the reason that when the version command is run for both Docker and Podman, Docker lists the versions of both client and server whereas Podman lists only it's version.


## Installing Podman and Buildah

In Ubuntu/Debian/Raspbian:
```
sudo apt-get -y update
sudo apt-get -y install podman
sudo apt-get -y install buildah
```
[Source](https://podman.io/getting-started/installation)

After installing the packages, start the Podman systemd socket-activated service using the following command:
```
$ sudo systemctl start podman.socket
```

### Installation of required packages

Let's install some necessary packages:
```
$ sudo apt-get install python3-pip
# To activate ~/./local/bin
$ source ~/.profile
```
	
## Podman commands

```
$ podman ps
$ podman pod stop podname
$ podman pod rm podname
$ podman volume ls
$ podman info --debug

$ buildah images
REPOSITORY                 TAG      IMAGE ID       CREATED          SIZE
<none>                     <none>   2d5dab8f7f12   47 minutes ago   8.72 MB
docker.io/library/alpine   3.14     d4ff818577bc   5 days ago       5.87 MB
k8s.gcr.io/pause           3.2      80d28bedfe5d   16 months ago    688 KB

$ podman images --digests
REPOSITORY                  TAG          DIGEST                                                                   IMAGE ID      CREATED        SIZE
docker.io/library/postgres  latest       sha256:a8f25ca44e98a4846cad176be8017f8f9c34028e4eebbf905dd46ccbab77d7a2  e36567eeafa1  4 days ago     322 MB
docker.io/library/alpine    3.14         sha256:234cb88d3020898631af0ccbbcca9a66ae7306ecd30c9720690858c1b007d2a0  d4ff818577bc  5 days ago     5.87 MB
docker.io/strapi/strapi     latest       sha256:1f85427b69bfb514a57c1273a300dbb19bdccd69b947c8d3fb09392a5ed4d723  9a0e917916e8  2 weeks ago    1.05 GB
docker.io/library/nginx     1.21-alpine  sha256:6d76a25a64f6a9a873bded796761bf7a1d18367570281d73d16750ce37fae297  a6eb2a334a9f  3 weeks ago    24.2 MB
k8s.gcr.io/pause            3.2          sha256:927d98197ec1141a368550822d18fa1c60bdae27b78b0c004f705f548c07814f  80d28bedfe5d  16 months ago  688 kB

```

## Podman Compose

A major difference between Docker Compose and Podman Compose is that Podman Compose adds the containers to a single pod for the whole project, and all the containers share the same network.
```
pip3 install --user --upgrade podman-compose 
pip3 install  --user https://github.com/containers/podman-compose/archive/devel.tar.gz

podman-compose --help
podman-compose up --help
```
[Source](https://github.com/containers/podman-compose/blob/devel/examples/busybox/docker-compose.yaml)

### ERRORS

If you encounter an error like this: `error creating build container: short-name "nginx:1.21-alpine" did not resolve to an alias and no unqualified-search registries are defined in "/etc/containers/registries.conf" ERRO exit status 125`, you should execute this command: `echo -e "[registries.search]\nregistries = ['docker.io']" | sudo tee /etc/containers/registries.conf`.

## Production configurations

For production, the Podman service should use systemd's socket activation protocol. This allows Podman to support clients without additional daemons and secure the access endpoint.
You can read more about docker-related issues and how to enable container in systemd service at this [link](https://www.redhat.com/sysadmin/podman-shareable-systemd-services).

```
$ podman pod ls
POD ID        NAME    STATUS   CREATED      INFRA ID      # OF CONTAINERS
c29c39557690  pc      Running  4 hours ago  a5eab97d2208  4
nmaltsev@nmvm1:~/repos/strapi/pc$ podman generate systemd --name pc
# pod-pc.service
# autogenerated by Podman 3.0.1
# Mon Jun 21 16:30:30 CEST 2021
...
```

The generated `systemd` service file can now be used to manage the pc pod via systemd. We can copy the file to `~/.config/systemd/user/pod-pc.service` and start a rootless container via `systemctl --user start pod-pc.service`.

The ability to generate systemd service files offers a lot of flexibility to users, and intentionally blurs the difference between a container and any other program or service on the host. We can generate service files for pods that can conveniently be written to files via the `--files` flag. However, all of these generated files are specific to containers and pods that already exist. 
First, make sure that the file is accessible to our non-root user:
```
	$ cat ~/.config/systemd/user/pod-pc.service
```
Now, we can load and start the service:
```
	$ systemctl --user daemon-reload
	$ systemctl --user start container.service
	$ systemctl --user status container.service
```


