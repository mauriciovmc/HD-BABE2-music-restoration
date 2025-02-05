#!/bin/bash
#SBATCH --job-name="HD-BABE2"
#SBATCH --time=6:00:00
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=80G
#SBATCH --partition=gpu
#SBATCH --gres=gpu:4

#### GPU OPTIONS ####
###SBATCH --gres=gpu:1
###SBATCH --gres=gpu:A100:1
###SBATCH --gres=gpu:H100:1

spack load cuda@11.8

spack load miniconda3

eval "$(conda shell.bash hook)"
# source ~/.bashrc

conda activate HD-BABE2

which python
python --version
python -c "import torch; print(torch.cuda.is_available())"

srun python ./train.py --config-name=conf_piano.yaml model_dir="/home/staff/m/madovalemade/Diffusion/experiments/maestro" exp.batch=4 dset.path="/home/staff/m/madovalemade/Datasets/maestro-v3.0.0"