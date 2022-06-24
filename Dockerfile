FROM jupyterhub/singleuser:1.5

USER root

WORKDIR /tmp
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean
RUN apt update -y && apt install -y \
    build-essential \
    vim \
    libmumps-dev \
    gmsh \
    cmake \
    petsc-dev \
    git \
    libeigen3-dev

RUN sudo apt-get install manpages-dev
COPY ./ jupyter_c_kernel/

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install -U Cython --install-option="--no-cython-compile"
RUN pip install --no-cache-dir jupyter_c_kernel/
RUN pip install --no-cache-dir \
    gmsh \
    numpy \
    scipy \
    matplotlib \
    vtk \
    meshpy \
    pyamg \
    meshio \
    mpi4py \
    PyMUMPS

RUN cd jupyter_c_kernel && install_c_kernel --user
RUN cd /root/
RUN conda install nb_conda_kernels -y
RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
RUN conda create -n cling
RUN conda install -n cling jupyter notebook -y
RUN conda config --set channel_priority flexible
RUN conda install -n cling xeus-cling nb_conda_kernels -y
WORKDIR /home/$NB_USER/
USER $NB_USER
COPY ./init.sh /etc/condaenv/init.sh
RUN pip install conda-pack