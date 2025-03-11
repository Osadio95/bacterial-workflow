process KRAKEN2 {
    tag "${sample_id}"
    label 'process_high'
    
    container 'staphb/kraken2'
    
    publishDir "${params.outdir}/kraken2", mode: 'copy'
    
    input:
   tuple val(sample_id), path(contigs)
    
    
    output:
    tuple val(sample_id), path("${sample_id}_kraken2_report.tsv"), emit: report
    tuple val(sample_id), path("${sample_id}_kraken2.txt"), emit: classified
    // --classified-out ${sample_id}.classified#.fastq \
    
    script:
    """
    kraken2 \
        --db /db/minikraken2_v1_8GB \
        --threads ${task.cpus} \
        --output ${sample_id}_kraken2.txt \
        --report ${sample_id}_kraken2_report.tsv \
        ${sample_id}_scaffolds.fasta
    """
}
