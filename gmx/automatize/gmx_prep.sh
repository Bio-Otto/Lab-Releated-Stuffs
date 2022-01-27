#!/usr/bin/env bash

# ---> JUST CHANGE "pdb_file" VARIABLE ACCORDING TO YOUR FILE.
pdb_file=3o4l.pdb



pdb_name=${pdb_file%.*}
gro="${pdb_name}_clean.gro"



# delete the clean fro file so gromacs wont display silly backup messages
if [ -e $gro ]
then
  rm -f $gro
fi


# --> select force-field 15
gmx pdb2gmx -f $pdb_file -o $gro -water spce

# --> set the box
gmx editconf -f $gro -o "${gro%.*}_box.gro" -c -d 1.0 -bt cubic


# --> solvate
gmx solvate -cp "${gro%.*}_box.gro" -cs spc216.gro -o "${gro%.*}_solv.gro" -p topol.top


# --> ionize
gmx grompp -f mdp_files/ions.mdp -c "${gro%.*}_solv.gro" -p topol.top -o ions.tpr -maxwarn 3


# --> select 13 for ions to replace SOL
gmx genion -s ions.tpr -o "${gro%.*}_ionized.gro" -p topol.top -pname NA -neutral


# --> energy minimization
gmx grompp -f mdp_files/minim.mdp -c "${gro%.*}_ionized.gro" -p topol.top -o em.tpr
gmx mdrun -v -deffnm em


# --> stabilize the temperature 
gmx grompp -f mdp_files/nvt.mdp -c em.gro -p topol.top -o nvt.tpr -r em.gro
gmx mdrun -v -deffnm nvt


# --> stabilize the pressure
gmx grompp -f mdp_files/npt.mdp -c nvt.gro -t nvt.cpt -p topol.top -o npt.tpr -r nvt.gro
gmx mdrun -v -deffnm npt


# --> mdrun
gmx grompp -f mdp_files/md.mdp -c npt.gro -t npt.cpt -p topol.top -o "${gro%.*}_run".tpr
gmx mdrun -v -deffnm "${gro%.*}_run"