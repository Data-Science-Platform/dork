FROM internal.docker.gda.allianz/bionic-20210222-non-root:jre8-anaconda3-2020.11

ENV LANG "C.UTF-8"
ENV DEBIAN_FRONTEND=noninteractive

ADD sudoers /tmp/sudoers
RUN sudo chmod 440 /tmp/sudoers && sudo chown root:root /tmp/sudoers && sudo mv /tmp/sudoers /etc/sudoers

RUN sudo apt clean && sudo apt update && sudo apt install sssd-tools libsss-sudo -y

ADD sudoers /tmp/sudoers
RUN sudo chmod 440 /tmp/sudoers && sudo chown root:root /tmp/sudoers && sudo mv /tmp/sudoers /etc/sudoers

RUN sudo cat /etc/sudoers

ADD nsswitch.conf /etc/nsswitch.conf

RUN sudo mkdir -p /var/run/sshd

ADD spark /spark

RUN sudo mkdir /application && sudo chmod 777 /application

ENV SPARK_HOME /spark
ENV PATH $PATH:/spark/bin

COPY conf/sshd_config.template /etc/ssh/sshd_config.template

COPY scripts/dork-submit /usr/bin
COPY scripts/dork-shell /usr/bin
COPY scripts/start-history-server /usr/bin
COPY scripts/start-worker /usr/bin
COPY scripts/start-master /usr/bin
COPY scripts/setup-users /usr/bin

RUN sudo chmod +x /usr/bin/dork-submit
RUN sudo chmod +x /usr/bin/dork-shell
RUN sudo chmod +x /usr/bin/start-history-server
RUN sudo chmod +x /usr/bin/start-worker
RUN sudo chmod +x /usr/bin/start-master
RUN sudo chmod +x /usr/bin/setup-users

RUN sudo mkdir /ssh-keys
