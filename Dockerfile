FROM jenkins/jenkins:lts
# dockerVersion is now set in DockerHub Builds
# ARG dockerVersion=19.03.12 
# ARG dockerComposeVersion=1.26.2
ARG dockerVersion
ARG dockerComposeVersion

#install docker-cli and docker-compose binaries only and add jenkins to the docker group
USER root
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-$dockerVersion.tgz | tar zxvf - --strip 1 -C /usr/bin docker/docker \
   && curl -L "https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
   && chmod +x /usr/local/bin/docker-compose /usr/bin/docker \
   && groupadd docker \
   && usermod -aG docker jenkins
