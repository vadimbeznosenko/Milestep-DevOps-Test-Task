FROM ubuntu:latest as build
RUN apt update
RUN apt -y install \
    ca-certificates openssl fontconfig npm maven wget unzip openjdk-8-jdk
WORKDIR /usr/src/app/
RUN wget "https://github.com/vadimbeznosenko/lavagna/archive/refs/heads/master.zip" -O lavagna.zip && \
    unzip ./lavagna.zip && \
    rm -rf ./lavagna.zip
WORKDIR /usr/src/app/lavagna-master/
RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && export PATH=$PATH:$JAVA_HOME/bin && npm install && \
    npm run-script lint --fix && mvn clean install

FROM openjdk:8-jre-alpine
WORKDIR /usr/src/app/
COPY --from=build /usr/src/app/lavagna-master/target/lavagna-jetty-console.war /usr/src/app/
CMD java -jar /usr/src/app/lavagna-jetty-console.war