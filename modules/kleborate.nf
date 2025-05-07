process KLEBORATE {
    tag "${sample_id}"
    container 'staphb/kleborate:latest'
    publishDir "${params.outdir}/kleborate", mode: 'copy'
    

    input:
    tuple val(sample_id), path(fas)

    output:
    tuple val(sample_id), path("${sample_id}_kleborate.tsv"), emit: kleborate_result

    script:
    """
    kleborate -a ${fas} -p kpsc -o ${sample_id}
    mv ${sample_id}/*_output.txt ${sample_id}_kleborate.tsv
    
    """
}
