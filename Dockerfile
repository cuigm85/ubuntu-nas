FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y openssh-server \
  && apt-get install -y vim \
  && apt-get install -y man \
  && apt-get install -y man-db
  
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Add developer group and user ubuntu
RUN addgroup --gid 1000 developer \
  && adduser --uid 1000 --gid 1000 --disabled-password --gecos "" ubuntu \
  && echo 'ubuntu:ubuntu' | chpasswd

# Installing the GNU C compiler and GNU C++ compiler
RUN apt-get install -y build-essential

# Install Python 3
RUN apt-get install -y python3-pip \
  && runuser -l ubuntu -c 'python3 -m pip install --user numpy scipy matplotlib ipython jupyter pandas sympy nose' \
  && runuser -l ubuntu -c 'python3 -m pip install --user scikit-learn'

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
