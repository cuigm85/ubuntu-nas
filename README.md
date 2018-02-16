_Ubuntu Docker Image for Synology DS916+_
===================

## _1. Docker Pull Command_

```bash
docker pull cuigm85/ubuntu-nas
```

## [_2.1. Dockerize an SSH service | Docker Documentation_](https://docs.docker.com/engine/examples/running_ssh_service/)

```
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```

## _2.2. Installed Packages_

- **vim**
- **sudo**
- **net-tools**
- **iputils-ping**
- **man**
- **man-db**
- **git**
- **build-essential**
- **python3-pip**

## _2.3. Default User_

```
User     : ubuntu
Password : ubuntu
Jupyter Notebook Port     : 8888
Jupyter Notebook Password : ubuntu
```
