FROM ubuntu:18.04

# Do not exclude man pages & other documentation
RUN rm /etc/dpkg/dpkg.cfg.d/excludes
# Reinstall all currently installed packages in order to get the man pages back
RUN apt-get update \
  && apt-get install -y man \
  && apt-get install -y man-db \
  && dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt-get install -y --reinstall \
  && rm -r /var/lib/apt/lists/*

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y openssh-server \
  && apt-get install -y vim \
  && apt-get install -y sudo \
  && apt-get install -y net-tools \
  && apt-get install -y iputils-ping 
  
# Installing Git
# Installing the GNU C compiler and GNU C++ compiler
# Installing the prebuilt OpenJDK packages
RUN apt-get install -y git \
  && apt-get install -y build-essential \
  && apt-get install -y openjdk-8-jdk \
  && apt install -y maven

RUN mkdir /var/run/sshd
# RUN echo 'root:screencast' | chpasswd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Add developer group and user ubuntu
RUN addgroup --gid 1000 developer \
  && adduser --uid 1000 --gid 1000 --disabled-password --gecos "" ubuntu \
  && echo 'ubuntu:ubuntu' | chpasswd \
  && usermod -aG sudo ubuntu \
  && passwd -e ubuntu

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
