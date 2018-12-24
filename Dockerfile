FROM ubuntu:18.04

# Install miniconda
ADD https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh /root/miniconda.sh
RUN /bin/bash /root/miniconda.sh -b -p /opt/conda && \
    rm /root/miniconda.sh

# Make sure conda is up to date
RUN /opt/conda/bin/conda update -y conda

# Create a user for this
ARG user=deeplearner
RUN useradd --create-home --shell /bin/bash $user

# This container assumes some directories will be bind-mounted from the host:
#    /fastai: the fastai git repo is expected to be here
#    /data: root path for datasets
#    /notebooks: this folder will hold user-modified notebooks, based on the originals from each lesson
# This is to allow them to be updated frequently without the need to rebuild the container
# and make the data and notebooks available to the host
RUN mkdir /fastai && chown $user /fastai && \
    mkdir /data && chown $user /data && \
    mkdir /notebooks && chown $user /notebooks

USER $user

# Create fastai environment
ADD fastai-cpu.env.yml /home/$user/environment.yml
RUN /opt/conda/bin/conda env create -f ~/environment.yml && \
    rm ~/environment.yml

EXPOSE 8888

ADD entrypoint.sh /home/$user/entrypoint.sh

WORKDIR /home/$user
ENTRYPOINT ["/home/deeplearner/entrypoint.sh"]
