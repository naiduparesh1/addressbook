from maven:3.8.4-openjdk-11-slim AS build-stage

WORKDIR /app
COPY ./pom.xml ./
COPY ./src ./

RUN mvn dependency:go-offline

RUN mvn package
#2nd stage

from tomcat:8.5.78-jdk11-openjdk-slim

RUN rm -rf /usr/local/tomcat/*

COPY --from=build-stage /app/target/addressbook.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh" "run"]

