# jenkinsplusdocker
Creating this image is just about adding docker binary to the recent jenkins:lts image.
To use then docker's unix socket directly from container, ensure to mount it to the contaner. Example:

docker container run -d --name jenkins -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped tandrews9/jenkinsplusdocker

Jenkinsfile here features a parametrized build with persistance of changes made in Job Parameters from Jenkins UI.
