FROM jenkins/jenkins:latest

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc

COPY --chown=jenkins:jenkins plugins.txt "${REF}"/plugins.txt

RUN jenkins-plugin-cli --plugin-file "${REF}"/plugins.txt