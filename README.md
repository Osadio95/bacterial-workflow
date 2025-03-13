**NGS Illumina Data Analysis Pipeline**

[FastQC](https://github.com/s-andrews/FastQC) version 0.11.9    
[Fastp](https://github.com/OpenGene/fastp) version 0.20.0   
[SPADES](https://github.com/ablab/spades) version  3.15.5   
[MLST](https://github.com/tseemann/mlst) version  2.23.0  
[Checkm2](https://github.com/chklovski/CheckM2) version  1.0.2  
[Kraken2](https://github.com/DerrickWood/kraken2) version  2.1.3  
[Bakta](https://github.com/oschwengers/bakta?tab=readme-ov-file#installation) version  1.9.4  
[Abricate](https://github.com/tseemann/abricate) version 1.0.1  
[Quast](https://github.com/ablab/quast) version  5.3.0  
[MASH](https://github.com/marbl/Mash) version  2.3  
[MULTIQC](https://github.com/MultiQC/MultiQC) version 1.13  




**Databases :**  
Four databases are required, stored in the data folder.
* Kraken2  
* Bakta  
* Checkm2
* MASH

Download Kraken2  
You can download any kraken2 database [here](https://benlangmead.github.io/aws-indexes/k2)  

Download Bakta database  
`bakta_db download --output <output-path> --type [light|full]`  

Download Checkm2 database  
`checkm2 database --download`

**Utitlisation**  
`nextflow run main.nf`  
`--bakta`  Annotation with Bakta

Author : Adja Bousso Gueye, Ousmane SADIO 
