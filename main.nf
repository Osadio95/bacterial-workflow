#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Default parameters
params.reads = "$projectDir/data/*_R{1,2}.fastq.gz"
params.outdir = "$projectDir/results"
params.threads = Runtime.runtime.availableProcessors()
params.abricate_db = "resfinder"
params.kraken_db = "$projectDir/db/minikraken2_v1_8GB"
params.checkm2_db = "$projectDir/db/checkm2_database/CheckM2_db/uniref100.KO.1.dmnd"
params.mash_db = "$projectDir/db/refseq.msh"
params.bakta_db = "$projectDir/db/db_bakta"
params.help = false
params.checkm2 = false
params.mash = false
params.kraken2 = false

// Help message
def helpMessage() {
    log.info"""
    Pipeline for Bacterial Genomic Analysis
Usage:  
  nextflow run main.nf  
    --help             Display this help message   

Output:  
  Result will be in the 'results' folder  

Options:  
  --reads             Path to paired FASTQ files (default: /data/*_R{1,2}.fastq.gz)  
  --threads           Number of threads to use (default: 20)

Tools:  
  --mash              Run MASH (requires --mash_db if not using the default path)  
  --checkm2           Run CheckM2 (requires --checkm2_db if not using the default path)  
  --kraken2           Run Kraken2 (requires --kraken_db if not using the default path)  

Annotation:   
  --bakta             Annotation with Bakta (requires --bakta_db if not using the default path)  
 	
Database:    
  --kraken_db         Path to the Kraken2 database (default: /db/minikraken2_v1_8GB)  
  --checkm2_db        Path to the CheckM2 database (default: /db/checkm2_database/CheckM2_db/uniref100.KO.1.dmnd)  
  --bakta_db          Path to the Bakta database (default: /db/db_bakta)  
  --mash_db           Path to the MASH database (default: /db/refseq.msh)  
  --abricate_db       Abricate database to use (default: resfinder)	  	 
    """.stripIndent()
}

// Show help
if (params.help) {
    helpMessage()
    exit 0
}

// Import modules
include { FASTQC } from './modules/fastqc'
include { FASTP } from './modules/fastp'
include { MULTIQC } from './modules/multiqc'
include { SPADES } from './modules/spades'
include { KRAKEN2 } from './modules/kraken2'
include { CHECKM2 } from './modules/checkm2'
include { QUAST } from './modules/quast'
include { ABRICATE } from './modules/abricate'
include { MLST } from './modules/mlst'
include { BAKTA } from './modules/bakta'
include { BACTINSPECTOR } from './modules/bactinspector'
include { SEROTYPE } from './modules/serotyping'
include { KLEBORATE } from './modules/kleborate'
include { ECTYPER } from './modules/ectyper'
include { MASH } from './modules/mash'

// Main workflow
workflow {
    // Define reads files
    Channel
        .fromFilePairs(params.reads, checkIfExists: true)
        .ifEmpty { error "No file matching ${params.reads} was found" }
        .set { read_pairs_ch }
        
    // Reads QC
    FASTQC(read_pairs_ch)

    // Trimming
    FASTP(read_pairs_ch)

    // De novo assembly
    SPADES(FASTP.out.trimmed_reads)

    // Taxonomic contamination control
    KRAKEN2(SPADES.out.contigs)

    // Completeness and contamination 
    CHECKM2(SPADES.out.contigs)

    // Assembly quality control
    QUAST(SPADES.out.contigs, FASTP.out.trimmed_reads)

    // AMR genes annotation
    ABRICATE(SPADES.out.contigs)
    
    // MLST analysis
    MLST(SPADES.out.contigs)
    
    // Species identification 
    BACTINSPECTOR(SPADES.out.contigs)
    
    // Bakta annotation
    BAKTA(SPADES.out.contigs)
    
    // MASH identification
    MASH(SPADES.out.contigs)
    
    // MultiQC report
    MULTIQC(
        FASTQC.out.reports.collect(),
        FASTP.out.json.collect(),
        QUAST.out.report.collect()
    )        
     
    // E.coli typing
    ECTYPER(BACTINSPECTOR.out.ecoli)
    
    // Salmonella serotyping
    SEROTYPE(BACTINSPECTOR.out.salmonella)
         
    // K.pneumoniae serotyping
    KLEBORATE(BACTINSPECTOR.out.klebsiella)
}

// On workflow completion
workflow.onComplete {
    def scriptPath = "${projectDir}/bin/final.py"
    def proc = ["python3", scriptPath].execute()

    def stdout = new StringBuffer()
    def stderr = new StringBuffer()
    proc.waitForProcessOutput(stdout, stderr)

    // Useful logs
    log.info "Standard output:\n${stdout}"
    log.info "Error output:\n${stderr}"

    if (proc.exitValue() == 0) {
        log.info "Report successfully created."
    } else {
        log.error "Error during report creation (code ${proc.exitValue()})."
    }
}

