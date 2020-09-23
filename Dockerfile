FROM debian:buster
MAINTAINER schnuckz
# Forked from atmoz/sftp for unRAID + fail2ban + raspberryPi + rsync

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install openssh-server fail2ban rsync && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

RUN mkdir -p /etc/default/sshd && \
    mkdir -p /etc/default/fail2ban

COPY files/sshd_config /etc/default/sshd/sshd_config
COPY files/jail.local /etc/default/fail2ban/jail.local
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
