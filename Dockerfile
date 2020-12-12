FROM postgres:10

ENV POSTGRES_DB=human-resources_database
ENV POSTGRES_USER=human-resources_database
ENV POSTGRES_PASSWORD=human-resources_database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib

ADD *.sql /docker-entrypoint-initdb.d/
