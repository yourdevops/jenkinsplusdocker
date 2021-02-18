# jenkinsplusdocker
Creating this image is just about adding a docker and docker-compose binaries to the recent jenkins image.
It has two versions: lts and latest

To use docker's unix socket directly from container, ensure to mount it to the contaner. Example:

docker container run -d --name jenkins -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped yourdevops/jenkinsplusdocker:lts

Image is built by Docker Hub every time when Jenkins LTS or latest base image is updated.

https://github.com/yourdevops/jenkinsplusdocker
