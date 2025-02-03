# Organização do repositório

Esse textinho é uma descrição breve da organização do repositório original, pra que a gente saiba onde procurar os pedaços que precisarem ser modificados. Por simplicidade, estou escrevendo em português mesmo. Mantive o README original embaixo do texto, caso seja necessário consultá-lo.

### Pasta `conf`

Essa pasta contém os arquivos de configuração que o modelo lê na hora de rodar treinamento e inferência. O Hydra lê um `.yaml` de configuração "pai", que aponta para diferentes `.yaml` com as configurações de partes diferentes do código.

Por exemplo, o arquivo `conf_piano.yaml` possui um dicionário de `defaults`. Nesse dicionário, a chave `dset` está associada ao valor `maestro_allyears`, o que significa que as configurações de leitura e tratamento do dataset se encontrarão no arquivo `conf/dset/maestro_allyears.yaml`.

As configurações relacionadas ao processo de difusão (sequência de ruídos, procedimento de resolução da EDO / SDE, etc) estão na sub-pasta `diff_params`. A sub-pasta `dset` tem as informações relacionadas ao dataset sendo usado. A sub-pasta `exp` parece controlar os parâmetros de treino, e a pasta `logging` o log do treinamento (incluindo quando salvar checkpoints). Em `network` estão as configurações da rede. Por fim, `tester` parece controlar os parâmetros dos experimentos que ele fez.

### Pasta `datasets`

Apesar do nome, essa pasta contém as classes do pytorch responsáveis por carregar e tratar os diferentes conjuntos de dados que ele usou no artigo. Durante o treinamento ele provavelmente importa esses módulos.

Vale a pena passar os olhos rapidamente na documentação do PyTorch pra datasets e dataloaders em caso de dúvidas.

### Pasta `diff_params`

No módulo que está nessa pasta estão as funções relacionadas aos processos forward e backward de difusão. Isso inclui o resolvedor da EDO, a função que cria a sequência de ruídos, etc.

### Pasta `network`

Aqui está a rede. O arquivo com a CQTDiff+ é o `cqtdiff.py`. Criei uma cópia dele como ponto de partida pra arquitetura nova.

### Pasta `testing`

Essa pasta tem dois scripts que ele parece ter usado pra inferência. As funções parecem servir pra automatizar o processo de avaliação. Preciso investigar mais pra poder entrar em detalhes. 

### Pasta `training`

O módulo dessa pasta contém o loop de treinamento do modelo. Acho que não vai ser preciso fazer grandes mudanças por aqui.

### Pasta `utils`

Aqui estão todas as funções que ele precisou chamar nos outros módulos e que não entravam necessariamente nas divisões acima. Isso inclui a implementação dele da CQT. 

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



