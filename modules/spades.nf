process SPADES {
    tag "${sample_id}"
    label 'process_high'
    
    container 'staphb/spades:3.15.5'
    
    publishDir "${params.outdir}/spades", mode: 'copy'
    
    input:
    tuple val(sample_id), path(reads)
    
    output:
    tuple val(sample_id), path("${sample_id}/contigs.fasta"), emit: contigs
    path "${sample_id}/assembly_graph_with_scaffolds.gfa", optional: true, emit: graph
    path "${sample_id}/spades.log", emit: log
    
    script:
    """
    spades.py \
        --isolate \
        -1 ${reads[0]} \
        -2 ${reads[1]} \
        -o ${sample_id} \
        -t ${task.cpus} \
        --memory ${task.memory.toGiga()}
    """
}
