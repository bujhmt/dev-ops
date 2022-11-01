FROM jenkins/jenkins:latest

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc

COPY --chown=jenkins:jenkins casc /var/jenkins_home/casc
COPY --chown=jenkins:jenkins plugins.txt "${REF}"/plugins.txt
COPY --chown=jenkins:jenkins utilities "${JENKINS_HOME}"

RUN jenkins-plugin-cli --plugin-file "${REF}"/plugins.txt