# Dockerfile

FROM ubuntu:24.04 as build
#COPY build_osqprovider.sh build_oqsprovider.sh
RUN apt-get update -y
RUN apt-get install -y  git wget build-essential libssl-dev cmake astyle cmake gcc ninja-build libssl-dev python3-pytest python3-pytest-xdist unzip xsltproc doxygen graphviz python3-yaml valgrind checkinstall zlib1g-dev
#RUN ./build_oqsprovider.sh

WORKDIR /app

RUN wget https://github.com/openssl/openssl/releases/download/openssl-3.4.0/openssl-3.4.0.tar.gz && tar xzf openssl-3.4.0.tar.gz
RUN cd openssl-3.4.0 && ./Configure --openssldir=/app/ssl --prefix=/app/ssl && make -j && make install

ENV PATH="/app/ssl/bin:$PATH"
ENV LD_LIBRARY_PATH="/app/ssl/lib:$LD_LIBARY_PATH"
ENV OPENSSL_ROOT_DIR="/app/ssl"
ENV liboqs_DIR="/app/liboqs-bin"

# Build liboqs and install in /app/liboqs-bin
RUN mkdir liboqs-bin
RUN git clone --depth=1 https://github.com/open-quantum-safe/liboqs.git liboqs
RUN cmake -S liboqs -B liboqs/build -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=/app/liboqs-bin -DOQS_BUILD_ONLY_LIB=ON
RUN cmake --build liboqs/build --parallel 4
RUN cmake --build liboqs/build --target install

# Build liboqs to /app/oqsprovider-bin
RUN git clone --depth=1 https://github.com/open-quantum-safe/oqs-provider.git oqs-provider
RUN cd oqs-provider && cmake -S . -B _build
RUN cd oqs-provider && cmake --build _build
RUN mkdir /app/oqsprovider-bin
ENV DESTDIR=/app/oqsprovider-bin
RUN cd oqs-provider && cmake --install _build

ADD openssl.conf /app/pqc-openssl.conf
ENV OPENSSL_CONF=/app/pqc-openssl.conf
