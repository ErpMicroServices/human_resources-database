FROM postgres:latest

ENV POSTGRES_DB=human_resources
ENV POSTGRES_USER=human_resources
ENV POSTGRES_PASSWORD=human_resources

# Copy all migration files to init directory
# PostgreSQL will execute these in alphabetical order on first run
COPY sql/V_huma*.sql /docker-entrypoint-initdb.d/

# Ensure the container uses UTF-8 encoding
ENV LANG=en_US.utf8
