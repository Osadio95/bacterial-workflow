process ECTYPER {
    tag "${sample_id}"
    container 'quay.io/biocontainers/ectyper:2.0.0--pyhdfd78af_3'    
    publishDir "${params.outdir}/ectyper", mode: 'copy'
    
    input:
    tuple val(sample_id), path(fas)
    
    output:
    tuple val(sample_id), path("${sample_id}_ectyper.tsv"), emit: ectyper_result
    
    script:
    """
    ectyper -i ${fas} -o ${sample_id}_ectyper
    mv ${sample_id}_ectyper/output.tsv ${sample_id}_ectyper.tsv
    """
}
