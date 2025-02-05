# A Diffusion-Based Generative Equalizer for Music Restoration

This repository houses the official implementation of BABE-2, an advanced algorithm designed for the enhancement of historical music recordings. 

> E. Moliner, M. Turunen, F. Elvander and V. Välimäki,, "A Diffusion-Based Generative Equalizer for Music Restoration", submitted to DAFx24, Mar, 2022



![](manuscript/figures/hawaii-trend.png)


![alt text](http://research.spa.aalto.fi/publications/papers/dafx-babe2/media/pipeline.png)

## Abstract

This paper presents a novel approach to audio restoration, focusing on the enhancement of low-quality music recordings, and in particular historical ones. 
Building upon a previous algorithm called BABE, or Blind Audio Bandwidth Extension, we introduce BABE-2, which presents a series of significant improvements.
This research broadens the concept of bandwidth extension to \emph{generative equalization}, a novel task that, to the best of our knowledge, has not been explicitly addressed in previous studies. 
BABE-2 is built around an optimization algorithm utilizing priors from diffusion models, which are trained or fine-tuned using a curated set of high-quality music tracks. The algorithm simultaneously performs two critical tasks: estimation of the filter degradation magnitude response and hallucination of the restored audio. The proposed method is objectively evaluated on historical piano recordings, showing a marked enhancement over the prior version. The method yields similarly impressive results in rejuvenating the works of renowned vocalists Enrico Caruso and Nellie Melba. 
This research represents an advancement in the practical restoration of historical music.

Listen to our [audio samples](http://research.spa.aalto.fi/publications/papers/dafx-babe2/)

Read the pre-print in [arXiv](https://arxiv.org/abs/2403.18636)

## Restore a recording with a pretrained model

The pretrained checkpoints used in the paper experiments are available  [here](http://research.spa.aalto.fi/publications/papers/dafx-babe2/checkpoints/)

```bash
python test.py  --config-name=conf_singing_voice.yaml tester=singer_evaluator_BABE2 tester.checkpoint="path/to/checkpoint.pt" id="BABE2_restored" tester.evaluation.single_recording="path/to/recording.wav"
```

## Test unconditional sampling

```bash
python test.py  --config-name=conf_piano.yaml tester=only_uncond_maestro tester.checkpoint="path/to/checkpoint.pt" id="BABE2" tester.modes=["unconditional"]
```


## Train or fine-tune your own diffusion model

Train a model from scratch:

```bash
python train.py  --config-name=conf_custom.yaml model_dir="experiments/model_dir" exp.batch=$batch_size dset.path="/path/to/dataset"
```

Fine-tune from pre-trained model:

```bash
python train.py  --config-name=conf_custom.yaml  model_dir="experiments/finetuned_model_dir" exp.batch=$batch_size dset.path="/path/to/dataset" exp.finetuning=True exp.base_checkpoint="/link/to/pretrained/checkpoint.pt" 
```



# NOTES

# Repository organization

This little text is a brief description of the organization of the original repository, so that we know where to look for the bits that need to be modified. I've kept the original README below the text, in case you need to consult it.

### `conf` folder

This folder contains the configuration files that the model reads when running training and inference. Hydra reads a “parent” `.yaml` configuration file, which points to different `.yaml` files with the configurations for different parts of the code.

For example, the file `conf_piano.yaml` has a `defaults` dictionary. In this dictionary, the `dset` key is associated with the `maestro_allyears` value, which means that the dataset reading and processing settings will be found in the `conf/dset/maestro_allyears.yaml` file.

The settings related to the diffusion process (noise sequence, ODE / SDE resolution procedure, etc.) are in the `diff_params` sub-folder. The `dset` sub-folder contains information related to the dataset being used. The `exp` sub-folder seems to control the training parameters, and the `logging` folder the training log (including when to save checkpoints). In `network` are the network settings. Finally, `tester` seems to control the parameters of the experiments it has done.

### `datasets` folder

Despite its name, this folder contains the pytorch classes responsible for loading and processing the different datasets he used in the article. During training he will probably import these modules.

It's worth taking a quick look at the PyTorch documentation for datasets and dataloaders if you have any doubts.

### Folder `diff_params`

The module in this folder contains the functions related to the forward and backward diffing processes. This includes the ODE solver, the function that creates the noise sequence, etc.

### `network` folder

Here is the network. The file with CQTDiff+ is `cqtdiff.py`. I created a copy of it as a starting point for the new architecture.

### `testing` folder

This folder has two scripts that he seems to have used for inference. The functions seem to be used to automate the evaluation process. I need to investigate further to be able to go into more detail. 

### `training` folder

The module in this folder contains the model's training loop. I don't think I need to make any major changes here.

### `utils` folder

Here are all the functions he needed to call in the other modules that didn't necessarily go into the divisions above. This includes his implementation of CQT. 
