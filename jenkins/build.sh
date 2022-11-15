cd base_image
docker build -t base-jenkins-image .

cd ../master_image
docker build -t master-jenkins-image .

docker run --name master-jenkins --rm -p 8080:8080 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password master-jenkins-image