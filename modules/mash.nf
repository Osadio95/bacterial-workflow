process MASH {
    tag "${sample_id}"
    label 'process_medium'
    
    container 'staphb/mash:latest'
    
    publishDir "${params.outdir}/mash", mode: 'copy'
    
    input:
    tuple val(sample_id), path(contigs)
    
    output:
    path "${sample_id}.mash.tsv", emit: report
    
    script:
    """
    mash sketch -o ${sample_id} -s 10000 -k 21 ${contigs} && \
    mash dist /db/refseq_khoudia.msh ${sample_id}.msh > ${sample_id}.mash.tsv
    """
}

