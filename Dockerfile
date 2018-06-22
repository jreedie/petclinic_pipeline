FROM maven:3.5.2-jdk-8

RUN \
    cd /usr/local && \
    curl -L https://services.gradle.org/distributions/gradle-3.4.1-bin.zip -o gradle-3.4.1-bin.zip && \
    unzip gradle-3.4.1-bin.zip && \
	rm gradle-3.4.1-bin.zip

ENV GRADLE_HOME=/usr/local/gradle-3.4.1
ENV PATH=$GRADLE_HOME/bin:$PATH

ADD /home/ssh_test/id_rsa /home/ssh_test/id_rsa