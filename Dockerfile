FROM postgres:12-alpine

LABEL org.opencontainers.image.source https://github.com/mfinelli/pgbackup

ARG CLOUD_SDK_VERSION=378.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

ENV PATH /google-cloud-sdk/bin:$PATH

RUN addgroup -g 1000 -S cloudsdk && \
    adduser -u 1000 -S cloudsdk -G cloudsdk

RUN if [ `uname -m` = 'x86_64' ]; then echo -n "x86_64" > /tmp/arch; else echo -n "arm" > /tmp/arch; fi;
RUN ARCH=`cat /tmp/arch` && apk --no-cache add \
        curl \
        python3 \
        py3-crcmod \
        py3-openssl \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg \
        gzip \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version
