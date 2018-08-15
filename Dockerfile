FROM maven:3.5.2-jdk-8



RUN apt-get update && apt-get install -y lsb-release

RUN apt-get update && \
	apt-get -y install  \
	    apt-transport-https \
	    ca-certificates \
	    curl \
	    gnupg2 \
	    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/debian \
	   $(lsb_release -cs) \
	   stable" && \
	apt-get update && \
	apt-get -y install docker-ce

RUN useradd jenkins
RUN usermod -aG docker jenkins

RUN \
    cd /usr/local && \
    curl -L https://services.gradle.org/distributions/gradle-3.4.1-bin.zip -o gradle-3.4.1-bin.zip && \
    unzip gradle-3.4.1-bin.zip && \
	rm gradle-3.4.1-bin.zip

ENV GRADLE_HOME=/usr/local/gradle-3.4.1
ENV PATH=$GRADLE_HOME/bin:$PATH


RUN \
	mkdir /usr/local/vault && \
	cd /usr/local/vault && \
	curl https://releases.hashicorp.com/vault/0.10.3/vault_0.10.3_linux_amd64.zip -o vault.zip && \
	unzip vault.zip && \
	rm vault.zip

ENV PATH=$PATH:/usr/local/vault

RUN \ 
	mkdir /usr/local/terraform && \
	cd /usr/local/terraform && \
	curl -L https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip -o terraform_0.11.7_linux_amd64.zip && \
	unzip terraform_0.11.7_linux_amd64.zip && \
	rm terraform_0.11.7_linux_amd64.zip 

ENV PATH=/usr/local/terraform:$PATH

RUN \
	cd /usr/local && \
	curl -L https://github.com/Azure/acs-engine/releases/download/v0.20.2/acs-engine-v0.20.2-linux-amd64.zip -o acs-engine-v0.20.2-linux-amd64.zip && \
	unzip acs-engine-v0.20.2-linux-amd64.zip && \
	rm acs-engine-v0.20.2-linux-amd64.zip

ENV PATH=/usr/local/acs-engine-v0.20.2-linux-amd64:$PATH

RUN \
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
	chmod +x ./kubectl && \
	mv ./kubectl /usr/local/bin/kubectl


