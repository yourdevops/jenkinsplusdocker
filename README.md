# jenkinsplusdocker
Creating this image is just about adding a docker binary to the recent jenkins:lts image.
To use docker's unix socket directly from container, ensure to mount it to the contaner. Example:

docker container run -d --name jenkins -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped yourdevops/jenkinsplusdocker
