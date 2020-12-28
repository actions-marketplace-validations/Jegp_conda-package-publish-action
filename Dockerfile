FROM continuumio/miniconda3:4.9.2

LABEL "repository"="https://github.com/jegp/conda-package-publish-action"
LABEL "maintainer"="Jens E. Pedersen <jens@jepedersen.dk>"

RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*
RUN conda install -y anaconda-client conda-build conda-verify gxx_linux-64

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
