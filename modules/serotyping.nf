process SEROTYPE {
    tag "${sample_id}"
    container 'staphb/seqsero2:latest'
    publishDir "${params.outdir}/serotyping", mode: 'copy'

    input:
    tuple val(sample_id), path(fas)

    output:
    tuple val(sample_id), path("${sample_id}_seqsero.tsv"), emit: serotype_result

    script:
    """
    SeqSero2_package.py -m k -t 4 -i "${fas}" -d "${sample_id}"
    mv "${sample_id}/SeqSero_result.tsv" "${sample_id}_seqsero.tsv"
    """
}
