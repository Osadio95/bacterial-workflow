process QUAST {
    tag "${sample_id}"
    label 'process_medium'
    
    container 'staphb/quast'
    
    publishDir "${params.outdir}/quast", mode: 'copy'
    
    input:
    tuple val(sample_id), path(contigs)
    
    output:
    path "${sample_id}_quast", emit: reports
    
    script:
    """
    quast.py \
        ${contigs} \
        -o ${sample_id}_quast \
        --threads ${task.cpus} \
        --min-contig 500
    """
}
