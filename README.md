1)

качаем и он просто всё готово

wget https://repo1.maven.org/maven2/io/lavagna/lavagna/1.1.9/lavagna-1.1.9-distribution.zip

unzip lavagna-1.1.9-distribution.zip

./lavagna-1.1.9/bin/lavagna.sh






2)

обновляем зависимости 

sudo apt-get update

устанавливаем яву

sudo apt-get install openjdk-8-jdk

проверяем версию 

java -version

добавляем JAVA_HOME чтобы мавен работал 

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

export PATH=$PATH:$JAVA_HOME/bin

устанавливаем npm

sudo apt install npm -y

устанавливаем мавен

sudo apt install maven -y

mvn -version

клоним репозиторий

git clone https://github.com/vadimbeznosenko/lavagna.git

cd ./lavagna/

устанавливаем зависимости 

npm install

npm run-script lint

тестим код 

mvn test

собираем артифакт 

mvn clean install

запускаем артифакт

java -jar lavagna-jetty-console.war


3) 

докер файл мульти стейдж билд

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

docker build . -t lavagna:v1

docker run -d -p8080:8080 --name=lavagna lavagna:v1

5,6)

тут всё вместе

version: "3"

services:

  lavagna:
  
    build:
	
      context: .
	  
      dockerfile: ./Dockerfile
	  
    restart: always
	
    container_name: lavagna
	
    networks:
	
    - lavagnaNetwork
	
    ports:
	
    - 8080:8080
	
    environment:
	
      LAVAGNA_DB_HOST: Mysql
	  
      LAVAGNA_DB_USER: exampleuser
	  
      LAVAGNA_DB_PASSWORD: q1q1q1q1
	  
      LAVAGNA_DB_NAME: exampledb
	  
    depends_on:
	
    - Mysql
	
  Mysql:
  
    image: mysql:5.7
	
    restart: always
	
    networks:
	
    - lavagnaNetwork
	
    environment:
	
      MYSQL_DATABASE: exampledb
	  
      MYSQL_USER: exampleuser
	  
      MYSQL_PASSWORD: q1q1q1q1
	  
      MYSQL_RANDOM_ROOT_PASSWORD: '1'
	  
    volumes:
	
      - db:/var/lib/mysql
	  
networks:

  lavagnaNetwork:
  
    driver: bridge

volumes:
  db
  
  
  
  плюс ещё сделал ci/cd на коленках
