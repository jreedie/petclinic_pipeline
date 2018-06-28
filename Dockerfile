FROM maven:3.5.2-jdk-8

RUN \
    cd /usr/local && \
    curl -L https://services.gradle.org/distributions/gradle-3.4.1-bin.zip -o gradle-3.4.1-bin.zip && \
    unzip gradle-3.4.1-bin.zip && \
	rm gradle-3.4.1-bin.zip

ENV GRADLE_HOME=/usr/local/gradle-3.4.1
ENV PATH=$GRADLE_HOME/bin:$PATH


RUN \
	cd ~/ && \
	curl https://releases.hashicorp.com/vault/0.10.3/vault_0.10.3_linux_amd64.zip -o
	vault.zip && \
	unzip vault.zip && \
	rm vault.zip


RUN useradd jenkinsUser
USER jenkinsUser

