#!/bin/bash

# Usage: bash gromacs-2019.3-install.sh

# Check it out: 
# https://www.nvidia.com/en-gb/data-center/gpu-accelerated-applications/gromacs/
# http://manual.gromacs.org/documentation/

# Note: make sure you have already installed NVIDIA-ubuntu drivers and NVIDIA-toolkit, for GPU mode.

wget ftp://ftp.gromacs.org/pub/gromacs/gromacs-2021.5.tar.gz
tar -xzvf gromacs-2021.5.tar.gz
cd gromacs-2021.5
mkdir build
cd build
#sudo cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_GPU=ON -DGMX_OPENMP=ON

sudo cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_GPU=CUDA -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-11.6

sudo make
#optionally: cmake .. -DGMX_GPU=ON -DGMX_BUILD_OWN_FFTW=ON
# if you find a problem with g++ version (7) pass the following commands:
# sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 10
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 10

sudo make check
sudo make install

# Finally, we need to export it to the PATH:
# PATH="your-dir/gromacs-2018.3/build/bin:$PATH"

# Another option is to provide an alias to the PATH:
# alias gmx='your-dir/gromacs-2018.3/build/bin/./gmx'

#C variables
#export CC=`which gcc`
#export CXX=`which g++`
