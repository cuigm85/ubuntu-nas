FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y openssh-server \
  && apt-get install -y vim \
  && apt-get install -y sudo \
  && apt-get install -y net-tools \
  && apt-get install -y iputils-ping \
  && apt-get install -y man \
  && apt-get install -y man-db
  
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

# Installing Git
RUN apt-get install -y git

# Installing the GNU C compiler and GNU C++ compiler
RUN apt-get install -y build-essential

# Installing the OpenJDK 8 packages
RUN apt-get install -y openjdk-8-jdk

# Install Python 3
RUN apt-get install -y python3-pip \
  && apt-get install -y python3-venv

EXPOSE 8888
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
