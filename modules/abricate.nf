process ABRICATE {
    tag "${sample_id}"
    // label 'process_medium'
    
    container 'quay.io/biocontainers/abricate:1.0.1--ha8f3691_1'
    
    publishDir "${params.outdir}/abricate", mode: 'copy'
    
    input:
    tuple val(sample_id), path(contigs)
    
    output:
    path "${sample_id}.${params.abricate_db}.tsv", emit: report
    
    script:
    """
    abricate \
        --db ${params.abricate_db} \
        --threads ${task.cpus} \
        --nopath \
        ${contigs} > ${sample_id}.${params.abricate_db}.tsv
    """
}
