FROM jenkins/jenkins:lts

#install docker-cli binary only and add jenkins to the docker group
USER root
ENV docker_version=19.03.12
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-$docker_version.tgz | tar zxvf - --strip 1 -C /usr/bin docker/docker \
   && groupadd docker \
   && usermod -aG docker jenkins
