#!/bin/bash
#SBATCH --job-name="HD-BABE2"
#SBATCH --time=4:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --partition=gpu
#SBATCH --gres=gpu:A100:1

###SBATCH --gres=gpu:A100:1
###SBATCH --gres=gpu:H100:1

spack load cuda@11.8

spack load miniconda3

source ~/.bashrc

conda activate HD-BABE2

srun python ./train.py