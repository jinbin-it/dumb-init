FROM ubuntu:16.04

COPY config.sh /config.sh
RUN chmod +x /config.sh
COPY java.sh /java.sh
RUN chmod +x /java.sh
COPY my_wrapper_script.sh /my_wrapper_script.sh
RUN chmod +x /my_wrapper_script.sh 

RUN apt-get update
RUN apt-get install -y openssh-server curl sudo jq
RUN mkdir /var/run/sshd
RUN echo 'root:rootroot' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

EXPOSE 22

# Change 1: Download dumb-init
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Change 2: Make it the entrypoint.  The arguments are optional
ENTRYPOINT ["/usr/local/bin/dumb-init","--rewrite","15:10","--"]
CMD ["/my_wrapper_script.sh"]
