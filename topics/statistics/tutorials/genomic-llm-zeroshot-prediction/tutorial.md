---
layout: tutorial_hands_on
title: Predicting Mutation Impact with Zero-shot Learning using a pretrained DNA LLM
level: Intermediate
draft: true
requirements:
-
  type: "internal"
  topic_name: data-science
  tutorials:
  - python-basics
  - python-warmup-stat-ml
-
  type: "internal"
  topic_name: statistics
  tutorials:
  - intro-to-ml-with-python
  - neural-networks-with-python
  - deep-learning-without-gai-with-python
  - genomic-llm-pretraining
  - genomic-llm-finetuning
questions:
- to do
objectives:
- pretraining LLM for DNA
- finetuning LLM
- zeroshot prediction for DNA variants and synthetic DNA sequence generation.
time_estimation: 3H
key_points:
- To be added
contributions:
  authorship:
  - raphaelmourad
  - bebatut
tags:
- ELIXIR
- AI & ML
- Large Language Model
subtopic: gai-llm
priority: 3
notebook:
  language: python
  pyolite: true
---

We will use a pretrained LLM from huggingface (https://huggingface.co/RaphaelMourad/Mistral-DNA-v1-17M-hg38) to predict the impact of mutations with zeroshot learning (directly using the pretrained model for DNA sequences). Here, we compute the embedding of the wild type sequence and compare it to the embedding of the mutated sequence, and then compute a L2 distance between the two embeddings. We expect that the higher the distance, the larger the mutation effect.

Script to predict the impact of mutations with zeroshot learning (directly using the pretrained model for DNA sequences).
Here, we compute the embedding of the wild type sequence and compare it to the embedding of the mutated sequence and then compute a L2 distance between the two embeddings.
We expect that the higher the distance, the larger the mutation effect.


# Prepare resources 

## Install dependencies


```python
!pip install datasets==3.0.1
!pip install torch==2.5.0
!pip install transformers -U
!pip install accelerate==1.1.0
!pip install peft==0.13.2
!pip install bitsandbytes==0.44.1
!pip install flash-attn==2.6.3
!pip install Bio==1.7.1
!pip install orfipy
```

## Import Python libraries

- `torch`
- `flash_attn`
- `numpy`
- `transformers`
  - `AutoTokenizer`
  - `EarlyStoppingCallback`
  - `Trainer`
  - `TrainingArguments`
  - `AutoModelForCausalLM`
  - `AutoConfig`
  - `DataCollatorForLanguageModeling`
- `datasets`
- `accelerate`


```python
# 
# During the class, 
import os

import sys
import time
from os import path
import gc


import flash_attn
import torch
import numpy as np
import pandas as pd
import scipy as sp
import matplotlib.pyplot as plt

import transformers

from transformers import AutoTokenizer
from transformers import EarlyStoppingCallback, Trainer, TrainingArguments
from transformers import AutoModelForCausalLM, AutoConfig
from transformers import DataCollatorForLanguageModeling
from datasets import load_dataset

import accelerate
```

## Check versions

Numpy version > 1.26.4

```python
np.__version__
```

transformers version > 4.47.1

```python
transformers.__version__
```

flash_attn > 2.6.0.post1 and 2.7.0.post2

```python
flash_attn.__version__
```

accelerate > 0.32.1

```python
# Tested with accelerate==0.32.1

accelerate.__version__
```

## Prepare GPU


```python
# CHECK GPU
# We can see how many VRAM is used and how much the GPU is used.
!nvidia-smi
```

    Thu Feb  6 07:59:23 2025       
    +-----------------------------------------------------------------------------------------+
    | NVIDIA-SMI 550.54.15              Driver Version: 550.54.15      CUDA Version: 12.4     |
    |-----------------------------------------+------------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
    |                                         |                        |               MIG M. |
    |=========================================+========================+======================|
    |   0  Tesla T4                       Off |   00000000:00:04.0 Off |                    0 |
    | N/A   36C    P8              9W /   70W |       0MiB /  15360MiB |      0%      Default |
    |                                         |                        |                  N/A |
    +-----------------------------------------+------------------------+----------------------+
                                                                                             
    +-----------------------------------------------------------------------------------------+
    | Processes:                                                                              |
    |  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
    |        ID   ID                                                               Usage      |
    |=========================================================================================|
    |  No running processes found                                                             |
    +-----------------------------------------------------------------------------------------+


```python
# LOOK AT GPU USAGE AND RAM
!nvidia-smi
```

    Thu Feb  6 16:49:41 2025       
    +-----------------------------------------------------------------------------------------+
    | NVIDIA-SMI 550.54.15              Driver Version: 550.54.15      CUDA Version: 12.4     |
    |-----------------------------------------+------------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
    |                                         |                        |               MIG M. |
    |=========================================+========================+======================|
    |   0  Tesla T4                       Off |   00000000:00:04.0 Off |                    0 |
    | N/A   54C    P8             10W /   70W |       2MiB /  15360MiB |      0%      Default |
    |                                         |                        |                  N/A |
    +-----------------------------------------+------------------------+----------------------+
                                                                                             
    +-----------------------------------------------------------------------------------------+
    | Processes:                                                                              |
    |  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
    |        ID   ID                                                               Usage      |
    |=========================================================================================|
    |  No running processes found                                                             |
    +-----------------------------------------------------------------------------------------+



Control the use of ram by CUDA

```python
torch.backends.cudnn.benchmark=True
os.environ["PYTORCH_CUDA_ALLOC_CONF"] = "max_split_size_mb:32 "
```

```python
# Check GPU
import torch
torch.device('cuda' if torch.cuda.is_available() else 'cpu')
```

    device(type='cuda')

# Get the model 

Mistral-DNA-v0.1 was derived from Mixtral-8x7B for the human genome. Mixtral-8x7B was simplified for DNA: the number of layers and the hidden size were reduced. The model was pretrained using the human genome hg38 with 200b DNA sequences.

The model can be downloaded on HuggingFace: https://huggingface.co/RaphaelMourad/Mistral-DNA-v0.1

```python
!git clone https://github.com/raphaelmourad/Mistral-DNA.git
```


```python
!ls
```

    Mistral-DNA  sample_data


```python
# SET DIRECTORY
os.chdir("Mistral-DNA/")
print(os.getcwd())
```

/content/Mistral-DNA



## Load extra Python modules


```python
import tensorflow as tf

import gzip
from Bio import SeqIO
```


Function to read fasta

```python
def readRegularFastaFile(fasta_file):
  seql_list=[]
  with gzip.open(fasta_file, "rt") as handle:
      for record in SeqIO.parse(handle, "fasta"):
          seqj=str(record.seq)
          seql_list.append(seqj)

  return seql_list
```

## Prepare model

Model

```python
#model_name="RaphaelMourad/Mistral-DNA-v1-422M-hg38"
#model_name="RaphaelMourad/Mistral-DNA-v1-138M-hg38"
model_name="RaphaelMourad/Mistral-DNA-v1-17M-hg38"
#model_name="RaphaelMourad/Mistral-DNA-v1-1M-hg38"
#model_name="RaphaelMourad/ModernBert-DNA-v1-37M-hg38"
```

Load tokenizer


```python
tokenizer = transformers.AutoTokenizer.from_pretrained(
    model_name,
    #padding_side="left",
    use_fast=True,
    trust_remote_code=True,
)
#tokenizer.eos_token='[EOS]'
#tokenizer.pad_token = '[PAD]'
```


    tokenizer_config.json:   0%|          | 0.00/158 [00:00<?, ?B/s]

    tokenizer.json:   0%|          | 0.00/168k [00:00<?, ?B/s]

Load model

```python
model=transformers.AutoModelForCausalLM.from_pretrained(
    model_name,
)
model.config.pad_token_id = tokenizer.pad_token_id
model
```


    config.json:   0%|          | 0.00/793 [00:00<?, ?B/s]



    model.safetensors:   0%|          | 0.00/33.6M [00:00<?, ?B/s]



    generation_config.json:   0%|          | 0.00/111 [00:00<?, ?B/s]





    MixtralForCausalLM(
      (model): MixtralModel(
        (embed_tokens): Embedding(4096, 256)
        (layers): ModuleList(
          (0-7): 8 x MixtralDecoderLayer(
            (self_attn): MixtralAttention(
              (q_proj): Linear(in_features=256, out_features=256, bias=False)
              (k_proj): Linear(in_features=256, out_features=256, bias=False)
              (v_proj): Linear(in_features=256, out_features=256, bias=False)
              (o_proj): Linear(in_features=256, out_features=256, bias=False)
            )
            (block_sparse_moe): MixtralSparseMoeBlock(
              (gate): Linear(in_features=256, out_features=8, bias=False)
              (experts): ModuleList(
                (0-7): 8 x MixtralBlockSparseTop2MLP(
                  (w1): Linear(in_features=256, out_features=256, bias=False)
                  (w2): Linear(in_features=256, out_features=256, bias=False)
                  (w3): Linear(in_features=256, out_features=256, bias=False)
                  (act_fn): SiLU()
                )
              )
            )
            (input_layernorm): MixtralRMSNorm((256,), eps=1e-05)
            (post_attention_layernorm): MixtralRMSNorm((256,), eps=1e-05)
          )
        )
        (norm): MixtralRMSNorm((256,), eps=1e-05)
        (rotary_emb): MixtralRotaryEmbedding()
      )
      (lm_head): Linear(in_features=256, out_features=4096, bias=False)
    )


Number of model parameters

```python
pytorch_total_params = sum(p.numel() for p in model.parameters())
print(f"Model size: {pytorch_total_params/1000**2:.1f}M parameters")
```

    Model size: 16.8M parameters

## Compute sequence embedding

- discuss the need to use detach() to delete the gradient which is taking a lot of memory
- look at the embedding (hidden_states)
- discuss the mean / max pooling

```python
dna = "ACGTAGCATCGGATCTATCTATCGACACTTGGTTATCGATCTACGAGCATCTCGTTAGC"
inputs = tokenizer(dna, return_tensors = 'pt')["input_ids"]
hidden_states = model(inputs)[0].detach() # [1, sequence_length, 768]
print(hidden_states)
```

embedding with mean pooling

```python
embedding_mean = torch.mean(hidden_states[0], dim=0)
print(embedding_mean.shape) # expect to be 768
```

embedding with max pooling

```python
embedding_max = torch.max(hidden_states[0], dim=0)[0]
print(embedding_max.shape) # expect to be 768

```

    tensor([[[-5.7822, -2.6941,  0.2004,  ..., -0.8346, -0.4331, -2.4413],
             [-5.9302, -3.0826, -1.7779,  ..., -0.4484, -0.2522, -1.7841],
             [-6.4070, -3.5369, -0.8623,  ..., -0.4834, -0.2303, -1.4513],
             ...,
             [-6.7136, -4.0397, -0.2811,  ...,  0.0941,  0.0367, -1.0994],
             [-4.1983, -0.5584,  7.8823,  ..., -1.6618, -5.4440, -4.1521],
             [-6.5815, -4.2742, -0.0318,  ..., -0.2478, -2.5161, -0.3905]]])
    torch.Size([4096])
    torch.Size([4096])



```python
embedding_mean
```




    tensor([-6.1499, -3.4025,  1.3927,  ...,  0.0232, -1.7535, -1.1487])


## Compute Cystic fibrosis mutation effect (Gene CFTR)

```python
dna_wt= "ATTAAAGAAAATATCATCTTTGGTGTTTCCTAT"
dna_mut="ATTAAAGAAAATATCATTGGTGTTTCCTAT"

inputs_seqs = tokenizer([dna_wt,dna_mut], return_tensors = 'pt', padding=True)["input_ids"]
hidden_states_seqs = model(inputs_seqs)[0].detach() # [1, sequence_length, 768]
```

```python
embedding_max = torch.max(hidden_states_seqs, dim=1)[0]
print(embedding_max)
```

    tensor([[-5.6724, -2.3842,  5.1578,  ...,  1.9340,  1.4729,  3.9054],
            [-2.0535,  0.7848,  4.8104,  ...,  0.7478,  0.9392,  1.6499]])
          
```python
distL2=torch.norm(embedding_max[0]-embedding_max[1])
print(distL2) # Mutation effect (unnormalized)
```

    tensor(145.7797)


## Compare with a mutation that does not impact the CFTR protein sequence

```python
dna_wt= "ATTAAAGAAAATATCATCTTTGGTGTTTCCTAT" # ATT = Isoleucine
dna_mut="ATAAAAGAAAATATCATCTTTGGTGTTTCCTAT" # ATA = Isoleucine

inputs_seqs = tokenizer([dna_wt,dna_mut], return_tensors = 'pt', padding=True)["input_ids"]
hidden_states_seqs = model(inputs_seqs)[0].detach() # [1, sequence_length, 768]
```

```python
embedding_max = torch.max(hidden_states_seqs, dim=1)[0]
print(embedding_max)
```
    tensor([[-5.6724, -2.3842,  5.1578,  ...,  1.9340,  1.4729,  3.9054],
            [-5.5415, -2.3247,  5.0079,  ...,  1.9292,  1.7426,  3.8457]])

```python
distL2=torch.norm(embedding_max[0]-embedding_max[1])
print(distL2) # Mutation effect (unnormalized)
```

    tensor(27.4657)


```python
ls Mistral-DNA/data/SNP
```

     SNPexon_alt_201b.fasta.gz     SNPintron_ref_201b.fasta.gz  'SNPprot_R->K.fasta.gz'
     SNPexon_ref_201b.fasta.gz    'SNPprot_I->L.fasta.gz'
     SNPintron_alt_201b.fasta.gz   SNPprot_ref.fasta.gz


## Load SNPs at exons and SNPs at introns

```python
win=201
file_SNPexon_ref="Mistral-DNA/data/SNP/SNPexon_ref_"+str(win)+"b.fasta.gz"
file_SNPexon_alt="Mistral-DNA/data/SNP/SNPexon_alt_"+str(win)+"b.fasta.gz"
file_SNPintron_ref="Mistral-DNA/data/SNP/SNPintron_ref_"+str(win)+"b.fasta.gz"
file_SNPintron_alt="Mistral-DNA/data/SNP/SNPintron_alt_"+str(win)+"b.fasta.gz"

kseq=100
exon_ref_seq=readRegularFastaFile(file_SNPexon_ref)[0:kseq]
exon_alt_seq=readRegularFastaFile(file_SNPexon_alt)[0:kseq]
intron_ref_seq=readRegularFastaFile(file_SNPintron_ref)[0:kseq]
intron_alt_seq=readRegularFastaFile(file_SNPintron_alt)[0:kseq]
```

```python
print(len(exon_ref_seq))
```

    100



```python
exon_ref_seq[0:5]
```

    ['AAGGAAATTTCTCAAGGCACTGGGGTGATTTTGTGTTTCTTTAGCATGAGTTACCGGAAAGCTTCCTGTGTTTTCTTTACTATCTTTAGGTGGTGGTTCCCAGCATCAAAAAACAGCAAAAACAGCAGCAAGCAAAGGCGCTGATACTCTGAAAAGTTATGTTGAAAACACATGGTTTAGGTACAGAATGGCTTCCCCGTT',
     'AACTGTACAACTCAAGCTGTGAGAGCTCACCATCTCGAGACATCCCTACGGCAAGGCATTTCTGTAATCGACAGTGTTGGCAGCGGTTTCTACTGGTTCGATCAATCAAACAGTTCTTCTGACGAGGACAGGAGTAGGTGGCATTGCTTTGCTGACTTCTCCTGAAAAAGCCCTGTGATATGGTTATAAAATATAAAACAG',
     'AAGTAATAAAGAAAAGAAAAAGCCTTACCAATAAGGTACTAGAAAAGATTTCTTTAAAATGGAACATTACCTCTTCACATTTCTTTCTTGTGTGCTCCATGAATACAGCAGACTATAGCTTGTGCATTCTTGAAATGTCTGAATTATTTCTCAGCCATTGGCCCCCATCTCTACTCAGTATGTGTTTTGTTTGATCTACCA',
     'TCCCCTCAGCAAGTTCCTTTTCTATTTATCCCCTGTGCCATAGATTCTGGATTTTGGGCTGGCGCGACATGCAGACGCCGAGATGACTGGCTACGTGGTGACCCGCTGGTACCGAGCCCCCGAGGTGATCCTCAGCTGGATGCACTACAACCAGACAGGTCAGTGGTCAATGCCTGAGAGGGCGGTCCTGGGGCCATCTGG',
     'CCCAGTGCAACAGCACGGGCGGCGACTGCTTTTACCGAGGCTACACGTCAGGCGTGGCGGCTGTCCAGGACTGGTACCACTTCCACTATGTGGATATCCTGGCCCTGCTGCCCGCGGCATGGGAGGACAGCCACGGGAGCCAGGACGGCCACTTCGTCCTCTCCTGCAGTTACGATGGCCTGGACTGCCAGGCCCGGTGAG']


## Compute effect of SNPs at exons and SNPs at introns

Function to compute embdedding of DNA sequences

```python
def compEmbed(seq_list):
  inputs_seqs = tokenizer(seq_list, return_tensors = 'pt', padding=True)["input_ids"]
  hidden_states_seqs = model(inputs_seqs)[0].detach().cpu().numpy() # [1, sequence_length, 768]

  embedding_max = np.max(hidden_states_seqs, axis=1)
  return embedding_max
```

Function to compute the mutation effect


```python
def compMutEffect(seq_ref_list,seq_alt_list):
  embedding_ref = compEmbed(seq_ref_list)
  embedding_alt = compEmbed(seq_alt_list)

  distL2=np.linalg.norm(embedding_alt-embedding_ref,axis=1,ord=2)
  return distL2
```

Compute effect of SNPs:

```python
distL2_exonSNPs=compMutEffect(exon_ref_seq,exon_alt_seq)
distL2_intronSNPs=compMutEffect(intron_ref_seq,intron_alt_seq)
print(distL2_exonSNPs)
```

    [63.03533  31.044062 39.03304  18.192963 49.824776 42.6142   52.09813
     32.992977 38.43193  58.492188 42.631645 25.4937   47.488388 42.742947
     31.181976 47.507042 51.119743 63.313705 62.88535  47.90212  50.48273
     35.023632 28.446203 28.12215  44.225407 28.844336 36.26753  40.782993
     40.14231  17.92508  36.52797  51.53251  45.59117  48.17041  39.370457
     34.84904  44.72748  43.82959  42.151596 32.28389  61.660637 20.260353
     38.978493 39.021168 27.663502 54.135887 63.96045  68.519394 52.40091
     46.57779  34.09115  40.967434 69.61329  34.248413 43.132214 44.491436
     42.415916 35.666916 40.655163 60.04139  47.282223 50.254944 20.797426
     26.721064 29.771858 49.376625 28.954895 66.75657  28.626053 20.787262
     46.005753 83.693375 59.110897 55.72293  57.147964 27.528046 36.52566
     31.78258  37.451008 57.891357 27.69302  52.93007  47.42123  42.52999
      6.284218 27.65697  26.294455 38.709187 34.24312  47.073757 44.79574
     68.08153  18.459845 52.39343  63.923344 36.26927  38.631157 43.43258
     52.406296 26.43025 ]


Boxplot of predicted SNP effects

```python
distL2SNPs = {'exonSNPs': distL2_exonSNPs, 'intronSNPs': distL2_intronSNPs}

fig, ax = plt.subplots()
ax.boxplot(distL2SNPs.values())
ax.set_xticklabels(distL2SNPs.keys())
```

We see that the L2 distance is higher for SNPs that are expected to have a stronger effect (SNPs in exons) as compared to SNPs in introns


    
Test if the difference is significant


```python
print(sp.stats.ttest_ind(distL2_exonSNPs,distL2_intronSNPs))
print(sp.stats.wilcoxon(distL2_exonSNPs,distL2_intronSNPs))
```

    TtestResult(statistic=5.110050602329565, pvalue=7.558007031764205e-07, df=198.0)
    WilcoxonResult(statistic=1164.0, pvalue=2.874910625498527e-06)

