process MLST {
    tag "${sample_id}"
   // label 'process_medium'
    
    container 'staphb/mlst'  // 
    
    publishDir "${params.outdir}/mlst", mode: 'copy'
    
    input:
    tuple val(sample_id), path(contigs)
    
    output:
    tuple val(sample_id), path("${sample_id}.mlst.tsv"), emit: mlst_result
    
    script:
    """
    mlst ${contigs} > ${sample_id}.mlst.tsv
    """
}


