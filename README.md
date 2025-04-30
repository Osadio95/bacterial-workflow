

**NGS Illumina Data Analysis Pipeline**


![PipelineOS drawio (2)](https://github.com/user-attachments/assets/11dfbb83-5611-4d06-af26-f7969bf5f5a9)



## 📌 Project Status

The pipeline is currently under development.

## 🧬 Purpose

It is designed for the analysis of bacterial genomes, including:

- Assembly and Quality Control
- Contamination and completness 
- Detection of antibiotic resistance genes
- Serotyping
- MLST (Multi-Locus Sequence Typing)
- Plasmid identification
- Virulence factors

## ⚙️ Workflow

- The pipeline is managed using **Nextflow**.
- Output includes multiple `.csv` files.
- A Python script is used to **concatenate results** from various tools and generates a single spreadsheet (`.xlsx`) with **multiple sheets** (one per tool).
- **Non-compliant results** (e.g., low N50 values) are highlighted in **orange-colored cells**.

## 🧫 Species Identification and Typing

- **Bactinspector** is used for bacterial species identification.
- Depending on the identified species, a specific typing tool is launched:
  - `Kleborate` for *Klebsiella pneumoniae*
  - `ECtyper` for *Escherichia coli*
  - `SeqSero` for *Salmonella*

## 🧾 Annotation Option

- An annotation option is available.
- **Note**: a database must be downloaded in advance to enable this feature.

## 🧹 Contamination Handling

- In case of contamination, **KrakenTools** can be used to remove contaminant reads.

## 🛠️ Tools used


[FastQC](https://github.com/s-andrews/FastQC) version 0.11.9    
[Fastp](https://github.com/OpenGene/fastp) version 0.20.0   
[SPADES](https://github.com/ablab/spades) version  3.15.5   
[MLST](https://github.com/tseemann/mlst) version  2.23.0  
[Checkm2](https://github.com/chklovski/CheckM2) version  1.0.2  
[Kraken2](https://github.com/DerrickWood/kraken2) version  2.1.3  
[Bakta](https://github.com/oschwengers/bakta?tab=readme-ov-file#installation) version  1.9.4  
[Bactinspector](https://gitlab.com/antunderwood/bactinspector) version  
[Abricate](https://github.com/tseemann/abricate) version 1.0.1  
[Quast](https://github.com/ablab/quast) version  5.3.0  
[MASH](https://github.com/marbl/Mash) version  2.3  
[MultiQC](https://github.com/MultiQC/MultiQC) version 1.13  
[Kleborate](https://github.com/klebgenomics/Kleborate) version   
[ECtyper](https://github.com/denglab/SeqSero2) version


## Databases 
Four databases are required, stored in the data folder.
* Kraken2  
* Bakta  
* Checkm2
* MASH

Download Kraken2  
Download any kraken2 database [here](https://benlangmead.github.io/aws-indexes/k2) 
or 
`python3 download bin/krakendb.py` (minikrakenv1, 8GB)

Download Bakta database  
`bakta_db download --output <output-path> --type [light|full]`
Download Bakta database [here](https://zenodo.org/records/4662588)

Download Checkm2 database  
`checkm2 database --download`  
or  
`python3 bin/download_checkm2db.py`  

Download MASH database


## 🧑‍💻 Usage 

⚠️ Under development, release soon  
1) Method 1 :  
You can only run the nextflow pipeline by running  
`nextflow run illumina.nf`   
Then you can run the python files to concatenate your results by running  
`python3 bin/final.py`  
The advantage is you can add `-resume` to start at the last point the analysis stopped  
2) Method 2 :    
or you can run the both the nextflow pipeline and python scripts for concatenation by running :  
`python3 pipeline.py`

##  🧑‍🔬  Authors 
Adja Bousso GUEYE, Ousmane SADIO 
