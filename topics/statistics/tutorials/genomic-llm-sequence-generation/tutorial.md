---
layout: tutorial_hands_on
title: Generating Artificial Yeast DNA Sequences using a DNA LLM
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
  - genomic-llm-zeroshot-prediction
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
priority: 4
notebook:
  language: python
  pyolite: true
---

We will use a pretrained LLM from huggingface (https://huggingface.co/RaphaelMourad/Mistral-DNA-v1-138M-yeast) to generate artificial yeast DNA sequences.

Script to generate artificial sequences (using directly a model pretrained on 1000 yeast genomes, see https://huggingface.co/RaphaelMourad/Mistral-DNA-v1-138M-yeast).


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
# IMPORT LIBRARIES
import torch

from transformers import pipeline

from Bio import SeqIO

import itertools
from collections import defaultdict
from sklearn.decomposition import PCA
```


```python
torch.backends.cudnn.benchmark=True
```

## Specify parameters

look at pipeline function
Mistral-DNA-v1-138M-yeast is a model pretrained on 1000 yeast genomes from https://www.nature.com/articles/s41586-018-0030-5.
The model and its tokenizer is downloaded from huggingface https://huggingface.co/RaphaelMourad.

```python
model_name="RaphaelMourad/Mistral-DNA-v1-138M-yeast"
#model_name="RaphaelMourad/Mistral-DNA-v1-138M-hg38"
generator = pipeline(model=model_name)
generator
```

    Device set to use cuda:0

    <transformers.pipelines.text_generation.TextGenerationPipeline at 0x7d09992dad50>

## Generate random sequences


```python
synthetic_dna=generator(
  "",
  max_length=30,
  do_sample=True,
  top_k=50,
  temperature=0.1,
  repetition_penalty=1.2,
  num_return_sequences=100,
  eos_token_id=0
)
```
look at all parameters, understand them and play with them.
              
print sequences

```python
artificial_sequences=[]
for seq in synthetic_dna:
        artificial_sequences.append(seq['generated_text'].replace(" ", ""))

artificial_sequences[0:5]
```

    ['CCTTGAATACCCGATGACGAAAAAAGTTCGTTCAACAGAAGAAAGATTTCAAGGAATGAAGACGAAACTATCGAGAAGAGGCAAAGAAAACTGGCGAATT',
     'TCTTCGACTATCGATGATTAGCAAGTAGCGTAAACGGGTTCAAAACTTCGTTCAATATCATTTTTCAATTTAAAAATCACGCTAACGAAGAATAATTTGA',
     'GTACGATAGAACGTTGTTGCTACAAGAATTGGCAATTTCAATTTGCTTTCGTCAATAACGAAAAAATTAATGAGCGTAAATTACCAATCTTCGGTATT',
     'CTTTCGTTGTACGATCTTCCAACGGTTTTTGAAGATTCCGATACTAACTTACAAAGAACGTTTCATCATTAAAATATTGGTTTGACGAATTATCTGTAAA',
     'TCAAGAATCTATACGATACGCATTTATCATATAATTTTTGATTATTGTATATTATTAATAACTTATGCAATAATAATAATATATTTATTAATTATAATTTATATTATAAATATAAA']

these are 5 artificial yeast DNA sequences


length of the first 5 sequences

```python
for i in range(4):
  print(len(artificial_sequences[i]))
```

    111
    112
    111
    111

go to BLAST and check that the generated sequence is novel.


get real sequences from yeast genome to compare to artificial yeast sequence

```python
# S
if os.path.isfile("sacCer3.fa")==False:
  !wget http://hgdownload.soe.ucsc.edu/goldenPath/sacCer3/bigZips/sacCer3.fa.gz
  !gunzip sacCer3.fa.gz

# Function to extract random sequences of a given length from the genome
def extract_random_sequences(genome_file, seq_length=100, num_seqs=100):
    # Load genome sequences from the FASTA file
    genome = []
    for record in SeqIO.parse(genome_file, "fasta"):
        genome.append(str(record.seq))

    # Join all chromosomes or scaffolds into one large sequence
    genome_seq = ''.join(genome)

    # List to store extracted sequences
    extracted_seqs = []

    genome_size = len(genome_seq)

    # Extract random sequences
    for _ in range(num_seqs):
        start_pos = random.randint(0, genome_size - seq_length)  # Random start position
        sequence = genome_seq[start_pos:start_pos + seq_length]  # Extract sequence
        extracted_seqs.append(sequence)

    return extracted_seqs

# EXTRACT RANDOM YEAST SEQUENCES
genome_file = "sacCer3.fa"  # Path to the yeast genome FASTA file
yeast_sequences = extract_random_sequences(genome_file, seq_length=100, num_seqs=1000)

# THESE ARE 5 REAL YEAST DNA SEQUENCES
yeast_sequences[0:5]
```

    ['GGGATATATAGGCACTTGATGTTTTATTTTCTTGTTCTTATCATATATCCGATGGAATAAAATGTTCTATTTTGCTGGCTTTTTCCAAAAATATTGTTTA',
     'TTTTTCAGTTTTTTGTCAAGCGAAAAACTACAGTTTCTACAGAAAAACACGTCAAGCTACAGTATAAGAACGGATTGTGAAGAACTCGGTGGAGAACATA',
     'TTGCACCGTTGGACTCATTTCCATTGCTGCTCTTGCTTCTTTTCATTGGATTGCCACCTAGAGATTTTAGAAGGTGACCACCTTTCTTTAAACCACCAGT',
     'CCATTATCAATCACAATGGGTGGTGTTTCCATAGTTTAAATTATCTTGTCCACGATTCTGCGCTTCTTCTCCTTTGGTCTTGCATTAATTCTCTTGTTCT',
     'CAAGGTTAATTCATCGACAGTGCCCAAACTTTGGCCTGATAATACGTTCATGTTTCTACTTGCTCCTTTTTTTCATCATGGAATGGGCCACGTTTCTAAG']


here we will use kmer counts as a way to numerically describe dna sequences.
It will allow to compare sequences assuming that sequences that very similar have similar kmer counts
kmers can be seen as DNA words. If two dna sequences (=two paragraphs) are similar, then they are expected to share many words.


code to compute kmer counts from a dna sequence

```python
# Function to generate all possible k-mers of a given length
def generate_all_kmers(k):
    return [''.join(p) for p in itertools.product('ACGT', repeat=k)]

# Function to compute k-mer counts for a list of sequences
def kmer_counts_matrix(sequences, k=6):
    all_kmers = generate_all_kmers(k)
    kmer_index = {kmer: idx for idx, kmer in enumerate(all_kmers)}  # Map k-mers to column indices
    matrix = np.zeros((len(sequences), len(all_kmers)), dtype=int)  # Initialize count matrix

    for seq_idx, seq in enumerate(sequences):
        kmer_dict = defaultdict(int)
        for i in range(len(seq) - k + 1):
            kmer = seq[i:i+k]
            kmer_dict[kmer] += 1

        # Fill in the matrix for this sequence
        for kmer, count in kmer_dict.items():
            if kmer in kmer_index:
                matrix[seq_idx, kmer_index[kmer]] = count

    return matrix, all_kmers
```

count kmers from both types of sequences
As written above, kmer counts will be used to describre a DNA sequence

```python
k=4
kmer_counts_artifseq, kmers = kmer_counts_matrix(artificial_sequences, k=k)
print(kmer_counts_artifseq)
```
    [[0 1 0 ... 2 1 1]
     [0 1 0 ... 2 1 1]
     [0 1 0 ... 2 1 1]
     ...
     [0 1 0 ... 2 1 1]
     [0 1 0 ... 2 1 1]
     [0 1 0 ... 2 1 1]]

```python
kmer_counts_yeastseq, kmers = kmer_counts_matrix(yeast_sequences, k=k)
print(kmer_counts_yeastseq)
```

    [[3 0 0 ... 2 1 5]
     [4 2 0 ... 2 1 5]
     [0 1 0 ... 3 0 2]
     ...
     [1 0 1 ... 1 4 1]
     [0 1 1 ... 2 0 8]
     [4 1 0 ... 0 0 0]]



PCA

```python
# kmer counts
set1 = kmer_counts_yeastseq
set2 = kmer_counts_artifseq

# Fit PCA on set1 only
pca = PCA(n_components=2)
pca.fit(set1)  # Fit using only set1

# Project both set1 and set2 into the PCA space
pca_set1 = pca.transform(set1)  # Projection of set1
pca_set2 = pca.transform(set2)  # Projection of set2

# Plot the first two principal components
plt.figure(figsize=(8, 6))
plt.scatter(pca_set1[:, 0], pca_set1[:, 1], color='blue', label='Real sequences', alpha=0.7)
plt.scatter(pca_set2[:, 0], pca_set2[:, 1], color='red', label='Artificial sequences', alpha=0.7)

# Add labels and legend
plt.xlabel('Principal Component 1')
plt.ylabel('Principal Component 2')
plt.title('PCA Projection of Set1 and Set2 (PCA built from Set1)')
plt.legend()

# Show the plot
plt.show()
```

    
<!--![png](output_16_0.png)-->
    
change temperature and check variance between sequences
for a temp=1, i obtained a mean var=0.374619
for a temp=0.001, i obtained a mean var=0.025463
here we see that the higher the temperature, the higher the variance (=the higher the variability)

```python
np.mean(np.var(kmer_counts_artifseq,axis=0))
```

    0.025463671874999993


generate random sequences from a sequence seed
Here let's generate a DNA sequence starting by TATA

```python
synthetic_dna=generator("TATA", max_length=30, do_sample=True, top_k=50, temperature=0.4,
                            repetition_penalty=1.2, num_return_sequences=100, eos_token_id=0)

# PRINT SEQUENCES
artificial_sequences=[]
for seq in synthetic_dna:
        artificial_sequences.append(seq['generated_text'].replace(" ", ""))

# THESE ARE 5 ARTIFICIAL YEAST DNA SEQUENCES
artificial_sequences[0:5]
```

    ['TATACTATCCAACTTATAACGAATTTTTGAAGTTAGTAGCGCTAAGCCGAAACCGAAAAGTGGACCGAGATGACGTTGTAACAAAGATTCACGAAATAAAAGTC',
     'TATATCCGTGGTATACACTTCATTATCAACCGAATTTGAATCTATCTTCCAATAAATGTGCAGACGACAAACTCGTCTAAAATTCATTACAAAACGGTACCAAA',
     'TATACTACTTTTTGAAGTTATATTGCGAAGAATCACAGCGGAATCTTTCTACGATCGGAAAGATTGGGTCTTCTTTCCAAGTATCCACTTAGTCATAAAGCTATCC',
     'TATATCCTTAATCATATAAAGTCGTAACGACATTGGAATACCATTCGCTTTTGCGGAAAGGAGTTTTCTATGCCTACATCAATTCATATTGAAAATAACATCGATT',
     'TATAGGACACCACCTTGCTTCGACCAATGAAGCAACTTCATTAGCATAGAGCCTCCAACCGGAAAGGGCGGCAACGAAGAACTTGAACAAAGACGTCACAAAATA']


make synthetic genes (here we generate longer sequences)

```python
synthetic_dna=generator("", max_length=100, do_sample=True, top_k=50, temperature=0.4,
                            repetition_penalty=1.2, num_return_sequences=100, eos_token_id=0)

# PRINT SEQUENCES
artificial_sequences=[]
for seq in synthetic_dna:
        artificial_sequences.append(seq['generated_text'].replace(" ", ""))

print(artificial_sequences[0:5])
```

    ['CCTTTTTTTTCGGCGATGAATCTGGCCGCTGGTACAATTTCTTCTCATTAATCAAAAATTGCATAGTTGTGGTGAATTTATCACTTAACTTGGAAACCAAGAGATCCCGAATTTGGCTTCGTTGGGTATTCAAATCGTCTTGTTGTTTGGATTGGTTCTACTTCTTCAACATCGGTGATGTACTTTTCCTTTCTTCCATCGAAGACACTGATTTATTCTCGAAACAGCTTCATCCAAATATTCATTTCCTAAACCTAGTTTGTTCATCACCTGCAATATTCACACTTTGAAAATATCATGTTGTTACCGCTGCCACAACCTGGGTAGGTGCTAAGCAATACCACCTTCTTAGTAATGGATTACGTCTTCATGACACCTGTGTCATGATATATCCATAATTGAATACCGTTTTGGCACCATTGGAA', 'GTACGACAAAGCTTCGGTATTCTCCGGATATCGCACGTTTCATCGAGAATTTTCTCGGTGGCAACGCTAAACACAACTTTGATTGCCGTCATGTTGATTTGGACATTTAACATCATTACATAGTCTTCTATAGTTCAGACTGATGTGTTTATCTTTCAAGGAACCGAGCGAAGCCAAAGTAATGAGCTACCAATTTGCAACATTAGATAGTTGCGGGAATACGTTCTTTTCTCACATCAAAATATGTCCCAAAATATATCCAGTGAGAGGTTCACCAAATGGAAACGGATAGATGAAGGTTCTAACGTGTTAACGAATAAAACTGGAATTGGGTATTGTTTTGACGTTATGCGCATTAAAGCCATACGCCAAAGAGACCA', 'GTTCTAACTTAGTGCCGGTATAATCGTCAATATTGGATAAAATCTTCGATGAAGATGGTAGCGGTAAATAATTTGATATTAGCTTGCACTTTTTTTACTCTAGTTTCAATGTTTGTACTTCGAATTATCTGTAATATCATTATTATAGCTAATTTGGCCCAATTCTAGCCAGTAACAAACCAATTAAGGTTCTGCGCTATGTCCAAATTCCTTGTCGTCATTCAGTGTGTTCTAATTGGGACCATTTTTTTCCATAATAATTGCAATACCTTTTCTTTGGGAACGGCGTAGATTGAAAGTTTGTATGGAATATCATCTAGTAAACAATAGAAGAAGTCAAAATATATTGAATTGATCTTTTTTTTACTTTATCTTACATTAAATGAAAAGAAAAGAGATAGAGCTA', 'TCTTCGTAGATTTCCGATGGTTATGTTGTCGCTTGTTTGCCCGATGACGAACTGCCTATATTGGTTGGATACACCAACTTCTTGGCTCATCATCTTTTCAAAGACATATGTCTGCTAATCAATTTGCTATCATTGATACCTTGGCACCATATTTTCTTTTTTAATGTATCGTCTTCAACGTTGTGCTCTTTGTGTAAATACTAGCACCATTGTATAATTGCCTTTTTGCCATAATCGCCATTACGCTAATCTCTAGATCCATCTGGGTCAATTTGAATTGTGATGCACCTTATGGAAACATCTCCAATTTGAACTGAGGTATCTAGGTAATAGAAGTTTTCAGTTAAACTTAGCGTATTGGTGTTTTCTCCATCATAGCCTTTATATCCTT', 'GTCGATACAAACCGGTACTAACGATAAACAGATCTGGATTTGTTCCATTTTGTTACAAGAGTTGGATAGGGTTTAGTTTGACGTTCATATCACGCTAACGTATCAAGTCATTTGCCAAGCCGAATACCTTAGAAAAGGAAGATGGTGGCAAAGTATATTACTTCTGAACTGAAAATTTCCCAAAATATGGGTTCGAATTTATTATTGAAATTCAGCATGTGCAAGATTGCAGAGAACTCCACCATGAAACATAAACGGGCAATATTGCCACCAAATGAAAAGGCTCAATACAAAGACTTGTAACTGATAGATTATGAAAAAAATTGATATTTGGTGATACTAAAATCGATTACTTATCCAGAGATGATGGCTTCTCATGACATATATATGAAGAGGATTAA']

these are 5 artificial yeast dna sequences

```python
len(artificial_sequences[0])
```

    425


detect orfs (ie genes inside the generated sequences)

```python
import orfipy_core
seq=artificial_sequences[0] # Look at ORFs in first DNA sequence
start_l=[]
stop_l=[]
for start,stop,strand,description in orfipy_core.orfs(seq,minlen=100,maxlen=1000):
  start_l.append(start)
  stop_l.append(stop)
  print(start,stop,strand,description)
```

    89 287 + ID=Seq_ORF.1;ORF_type=complete;ORF_len=198;ORF_frame=3;Start:TTG;Stop:TGA
    168 276 - ID=Seq_ORF.2;ORF_type=complete;ORF_len=108;ORF_frame=-3;Start:TTG;Stop:TGA


get first orf

```python
ORFseq=seq[start_l[0]:stop_l[0]]
print(ORFseq)
```

    TTGGAAACCAAGAGATCCCGAATTTGGCTTCGTTGGGTATTCAAATCGTCTTGTTGTTTGGATTGGTTCTACTTCTTCAACATCGGTGATGTACTTTTCCTTTCTTCCATCGAAGACACTGATTTATTCTCGAAACAGCTTCATCCAAATATTCATTTCCTAAACCTAGTTTGTTCATCACCTGCAATATTCACACTT


convert to peptide sequence (here it is a peptide as the amino acid sequence is small)

```python
from Bio.Seq import Seq
protein_seq = str(Seq(ORFseq).translate())
protein_seq
```

    'LETKRSRIWLRWVFKSSCCLDWFYFFNIGDVLFLSSIEDTDLFSKQLHPNIHFLNLVCSSPAIFTL'


# DNA sequence optimization

We will use a finetuned LLM for promoter or transcription factor binding.

