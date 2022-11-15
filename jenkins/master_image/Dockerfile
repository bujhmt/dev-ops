FROM base-jenkins-image

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV JAVA_OPTS -Dpermissive-script-security.enabled=true
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc

COPY --chown=jenkins:jenkins casc /var/jenkins_home/casc
COPY --chown=jenkins:jenkins utilities "${JENKINS_HOME}"
