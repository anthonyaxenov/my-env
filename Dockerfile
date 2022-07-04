FROM ubuntu:22.04

RUN apt update && \
    apt -y install \
        apt-transport-https \
        apt-utils \
        bsdmainutils \
        curl \
        dialog \
        grep \
        make \
        man \
        sudo \
        wget

RUN adduser ivan \
    --quiet \
    --home=/home/ivan \
    --ingroup=sudo \
    --disabled-password \
    --disabled-login

COPY ./ /home/ivan/my-env
RUN echo "ivan ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ivan
WORKDIR /home/ivan/my-env
