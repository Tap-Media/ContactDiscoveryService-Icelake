FROM eclipse-temurin:21-jre-jammy

RUN apt update && apt install -y gnupg2 wget gpg software-properties-common && \
    echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main" | tee /etc/apt/sources.list.d/msprod.list && \
    wget -qO - https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu focal main' | tee /etc/apt/sources.list.d/intel-sgx.list && \
    wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add - && \
    apt update && \
    apt install -y \
          libsgx-dcap-ql=1.20.100.2-focal1 \
          libsgx-dcap-ql-dev=1.20.100.2-focal1 \
          libsgx-dcap-default-qpl=1.20.100.2-focal1 \
          libsgx-dcap-default-qpl-dev=1.20.100.2-focal1



# install openssl 1.1.1
RUN apt-get install -y build-essential
RUN cd /tmp/; wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz; tar xvf openssl-1.1.1c.tar.gz; cd openssl-1.1.1c/; ./config; make  -j8; make install -j8; ldconfig

# Tapmedia:
RUN echo "deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main" | tee /etc/apt/sources.list.d/intel-sgx.list \
    && wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add -
# RUN apt update && \
#     apt install -y \
#     libsgx-quote-ex \
#     libsgx-aesm-quote-ex-plugin

WORKDIR /home/app
COPY classes /home/app/classes
COPY dependency/* /home/app/libs/
COPY classes/sgx_default_qcnl_azure.conf /etc/sgx_default_qcnl.conf
EXPOSE 8080

# Required, along with libsgx-quote-ex, for out-of-proc attestation. See
# https://docs.microsoft.com/en-us/azure/confidential-computing/confidential-nodes-aks-addon
ENV SGX_AESM_ADDR=1

# RUN groupadd --gid 10000 cds && useradd --uid 10000 --gid 10000 cds
# USER 10000

ENTRYPOINT ["java", "-cp", "/home/app/libs/*:/home/app/classes/", "org.signal.cdsi.Application"]
