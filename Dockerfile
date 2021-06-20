FROM maven:3.6.0-jdk-8-alpine as builder
COPY  . /root/app/
WORKDIR /root/app
RUN mvn clean package -Dmaven.test.skip=true
FROM tomcat:9.0-alpine

#FROM tomcat:8.0-jre8
COPY --from=builder /root/app/target /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
