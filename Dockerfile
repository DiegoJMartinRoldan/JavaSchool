FROM maven:3.8.5-openjdk-18

WORKDIR /JavaSchool-main
COPY .. .
RUN mvn clean install

CMD mvn spring-boot:run