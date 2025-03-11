#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Paramètres par défaut
params.reads = "$projectDir/data/*R{1,2}.fastq.gz"
params.outdir = "$projectDir/results"
params.threads = Runtime.runtime.availableProcessors()
params.abricate_db = "resfinder"
params.help = false

// Message d'aide
def helpMessage() {
    log.info"""
    Pipeline d'analyse génomique bacterienne

    Usage:
      nextflow run main.nf --reads '/chemin/vers/reads/*_{1,2}.fastq.gz' --outdir '/chemin/vers/resultats'

    Options:
      --reads         Chemin vers les fichiers FASTQ (paires) (défaut: $params.reads)
      --outdir        Dossier de sortie pour les résultats (défaut: $params.outdir)
      --threads       Nombre de threads à utiliser (défaut: $params.threads)
      --kraken_db     Chemin vers la base de données Kraken2 (défaut: $params.kraken_db)
      --checkm2_db    Chemin vers la base de données CheckM2 (défaut: $params.checkm2_db)
      --abricate_db   Base de données Abricate à utiliser (défaut: $params.abricate_db)
      --help          Affiche ce message d'aide
      --bakta	      Annotation avec bakta
    """.stripIndent()
}

// Afficher l'aide si demandé
if (params.help) {
    helpMessage()
    exit 0
}

// Importer les modules
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
// include { SEROTYPE } from './modules/serotyping'
include { MASH } from './modules/mash'

// Workflow principal
workflow {
    // Récupération des fichiers FASTQ
    Channel
        .fromFilePairs(params.reads, checkIfExists: true)
        .ifEmpty { error "Aucun fichier correspondant à ${params.reads} n'a été trouvé" }
        .set { read_pairs_ch }

    // Contrôle qualité avec FastQC
    FASTQC(read_pairs_ch)

    // Trimming avec Fastp
    FASTP(read_pairs_ch)

    // Assemblage avec SPAdes
    SPADES(FASTP.out.trimmed_reads)

    // Classification taxonomique avec Kraken2
    KRAKEN2(SPADES.out.contigs)

    // Évaluation de l'assemblage avec CheckM2
    CHECKM2(SPADES.out.contigs)

    // Évaluation de l'assemblage avec QUAST
    QUAST(SPADES.out.contigs)

    // Annotation des gènes de résistance avec Abricate
    ABRICATE(SPADES.out.contigs)
    
    // Realisation de la MLST
    MLST(SPADES.out.contigs)
    
    // Realisation du serotypage
    // SEROTYPE(FASTP.out.trimmed_reads)
    
    // Annotation Bakta
     BAKTA(SPADES.out.contigs)
    
    // MASH Identification
      MASH(SPADES.out.contigs)
    

    // Rapport MultiQC
    MULTIQC(
        FASTQC.out.reports.collect(),
        FASTP.out.json.collect(),
        QUAST.out.reports.collect(),
       
        
          
      )
}
