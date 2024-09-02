FROM postgres:latest

ENV POSTGRES_DB gw
ENV POSTGRES_USER gw-backend
ENV POSTGRES_PASSWORD I_KNOW_WHAT_I_AM_DOING

RUN apt-get update \
    && apt-get install -y make git \
    && git clone https://github.com/michelp/pgjwt.git --depth=1 \
    && cd pgjwt \
    && make install

COPY A_initial_migration.sql /docker-entrypoint-initdb.d/
COPY auth.sql /docker-entrypoint-initdb.d/
COPY demo_data.sql /docker-entrypoint-initdb.d/

EXPOSE 5432
