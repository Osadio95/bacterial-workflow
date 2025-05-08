process QUAST {
    tag "${sample_id}"
    // label 'process_medium'
    
    container 'staphb/quast'
    
    publishDir "${params.outdir}/quast", mode: 'copy'
    
    input:
    tuple val(sample_id), path(contigs)
    tuple val(sample_id_reads), path(trimmed_reads)
    
    output:
    path "${sample_id}_quast", emit: report
    
    script:
    def (read1, read2) = trimmed_reads
    """
    quast.py \
        ${contigs} \
        -o ${sample_id}_quast \
        --min-contig 200 \
        --pe1 ${read1} \
        --pe2 ${read2}
    """
}
