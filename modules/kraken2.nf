process KRAKEN2 {
    tag "${sample_id}"
    // label 'process_medium'
    
    container 'staphb/kraken2'
    
    publishDir "${params.outdir}/kraken2", mode: 'copy'
    
    input:
    tuple val(sample_id), path(contigs)
    
    output:
    tuple val(sample_id), path("${sample_id}_kraken2_report.tsv"), emit: report
    tuple val(sample_id), path("${sample_id}_kraken2.txt"), emit: classified
    
    when:
      params.kraken2 
        
    
    script:
    """
    kraken2 \
        --db ${params.kraken_db} \
        --threads 5 \
        --output ${sample_id}_kraken2.txt \
        --report ${sample_id}_kraken2_report.tsv \
        ${contigs}
    """
}
