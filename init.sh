#!/usr/bin/bash
if [ ! -d /home/jovyan/conda/user ]; then
  echo "creating user env";
  conda create -p /home/jovyan/conda/user --clone base
else
  echo "user env already created";
fi

if [ ! -f /home/jovyan/.bash_profile ]; then
    echo "setting up bash_profile";
    echo 'source /home/jovyan/.bashrc' >> .bash_profile;
else
    echo "bash_profile done";
fi

if [ ! -f /home/jovyan/.bashrc ]; then
    echo "setting up conda";
    conda init;
    echo "conda activate /home/jovyan/conda/user" >> /home/jovyan/.bashrc
else
    echo "conda env done";
fi
conda config  --prepend envs_dirs /home/jovyan/conda/user > /dev/null 2>&1