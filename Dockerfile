FROM flyio/postgres-flex:15.3

# Set the pgvector version
ARG PGVECTOR_VERSION=0.4.4

# Download and extract the pgvector release, build the extension, and install it
RUN curl -L -o pgvector.tar.gz "https://github.com/ankane/pgvector/archive/refs/tags/v${PGVECTOR_VERSION}.tar.gz" && \
    tar -xzf pgvector.tar.gz && \
    cd "pgvector-${PGVECTOR_VERSION}" 


RUN apt-get update && \
        apt-mark hold locales && \
        apt-get install -y --no-install-recommends build-essential postgresql-server-dev-$PG_MAJOR && \
        cd "pgvector-${PGVECTOR_VERSION}" && \
        make clean && \
        make OPTFLAGS="" && \
        make install && \
        mkdir /usr/share/doc/pgvector && \
        cp LICENSE README.md /usr/share/doc/pgvector && \
        cd .. \
        rm -rf pgvector-${PGVECTOR_VERSION} && \
        apt-get remove -y build-essential postgresql-server-dev-$PG_MAJOR && \
        apt-get autoremove -y && \
        apt-mark unhold locales && \
        rm -rf /var/lib/apt/lists/*