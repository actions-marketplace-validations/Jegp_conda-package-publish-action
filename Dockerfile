FROM continuumio/miniconda3:4.10.3

LABEL "repository"="https://github.com/jegp/conda-package-publish-action"
LABEL "maintainer"="Jens E. Pedersen <jens@jepedersen.dk>"

RUN conda install -y -c conda-forge anaconda-client boa conda-verify gxx_linux-64

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
