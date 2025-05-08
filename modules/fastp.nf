process FASTP {
    tag "${sample_id}"
    // label 'process_medium'
    
    container 'nanozoo/fastp'
    
    publishDir "${params.outdir}/fastp", mode: 'copy'
    
    input:
    tuple val(sample_id), path(reads)
    
    output:
    tuple val(sample_id), path("${sample_id}_trimmed_{1,2}.fastq.gz"), emit: trimmed_reads
    path "${sample_id}.fastp.json", emit: json
    path "${sample_id}.fastp.html", emit: html
    
    script:
    """
    fastp \
        --in1 ${reads[0]} \
        --in2 ${reads[1]} \
        --out1 ${sample_id}_trimmed_1.fastq.gz \
        --out2 ${sample_id}_trimmed_2.fastq.gz \
        --json ${sample_id}.fastp.json \
        --html ${sample_id}.fastp.html \
        -f 18 \
        -F 18 \
        --cut_mean_quality 20 \
        --detect_adapter_for_pe \
    """
}
