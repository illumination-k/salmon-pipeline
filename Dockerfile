ARG BASE_CONTAINER=conda/miniconda3
FROM ${BASE_CONTAINER}

LABEL maintainer="illumination-k <illumination.k.27@gmail.com>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# R pre-requisites
RUN apt-get update --fix-missing && \
    apt-get install -y wget && \
    apt-get autoremove && \
    apt-get autoclean

# bioconda packages
RUN conda update -n base -c defaults conda && \
    conda install \
    bedtools \
    fastp \
    bioconductor-tximport \
    multiqc \
    salmon \
    r-reader \
    r-jsonlite \
    -c bioconda -c conda-forge && \
    mkdir -p /local_volume 

ADD ./exec_files /workspace

RUN wget -O /workspace/mashmap-Linux64-v2.0.tar.gz https://github.com/marbl/MashMap/releases/download/v2.0/mashmap-Linux64-v2.0.tar.gz && \
    tar zxvf /workspace/mashmap-Linux64-v2.0.tar.gz && \
    rm -f /workspace/mashmap-Linux64-v2.0.tar.gz

WORKDIR /local_volume

RUN conda clean --all --yes && \
    rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

ENV PATH $PATH:/mashmap-Linux64-v2.0