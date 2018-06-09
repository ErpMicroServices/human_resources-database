FROM postgres:9

ENV POSTGRES_DB=human_resources-database
ENV POSTGRES_USER=human_resources-database
ENV POSTGRES_PASSWORD=human_resources-database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib
