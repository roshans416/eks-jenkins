FROM public.ecr.aws/s5f4f9y1/maven:3.6-jdk-8 as builder
COPY  . /root/app/
WORKDIR /root/app
RUN mvn clean package -Dmaven.test.skip=true
FROM tomcat:9.0-alpine

#FROM tomcat:8.0-jre8
COPY --from=builder /root/app/target /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
