process SEROTYPE {
    tag "${sample_id}"
    label 'process_medium'
    
    container 'staphb/seqsero2:latest'  // Vérifie l'image correcte

    publishDir "${params.outdir}/serotyping", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_seqsero_result.txt"), emit: serotype_result

    script:
    """
    SeqSero2_package.py -m k -t 4 -i ${reads[0]}  ${reads[0]}
    mv ${sample_id}_seqsero/SeqSero_result.txt ${sample_id}_seqsero_result.txt
    """
}

