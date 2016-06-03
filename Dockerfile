FROM iotivity_base 
RUN apt-get -y update
RUN apt-get install -y curl openssh-server

# Thanks, docker...
# https://docs.docker.com/engine/examples/running_ssh_service/
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN curl -sL https://deb.nodesource.com/setup_6.x | /bin/bash -
RUN apt-get install -y nodejs

RUN npm install -g node-red coap-cbor-cli

ADD Buildscript /root/NIBuildscript
RUN chmod +x /root/NIBuildscript

WORKDIR /root
RUN /root/NIBuildscript

EXPOSE 22
EXPOSE 5683
CMD ["/usr/sbin/sshd", "-D"]

