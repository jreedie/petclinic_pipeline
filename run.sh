docker run -d \
  --rm \
  -u root \
  -p 8080:8080 -p 8200:8200 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$HOME":/home \
  jenkinsci/blueocean
