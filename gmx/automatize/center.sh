#!/usr/bin/env bash

TRAJIN=traj.trr

TRAJOUT=traj_rot_center_dry.xtc

TPR_FILE=4jfe_TCR_250ns.tpr


# delete the trajectory so gromacs wont display silly backup messages
if [ -e $TRAJOUT ]
then
  rm -f $TRAJOUT
fi


# center molecule (you will be asked!)
# --> select 1 as ""protein"" for centering
# --> select 0 as ""system"" for output 
gmx trjconv -s $TPR_FILE -f $TRAJIN -o centered_tmp.xtc -center -pbc mol -ur compact 
gmx trjconv -s $TPR_FILE -f centered_tmp.xtc -o startframe.pdb -dump 0 

# make everything rotate and translate around that molecule (you will be asked!)
# --> select 4 for "backbone"
# --> select 0 for "system"
gmx trjconv -s $TPR_FILE -f centered_tmp.xtc -o $TRAJOUT -fit rot+trans 

rm -f centered_tmp.xtc