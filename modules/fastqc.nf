process FASTQC {
    tag "${sample_id}"
    // label 'process_low'
    
    
    // Use specified Docker container for FastQC
    container 'biocontainers/fastqc:v0.11.9_cv8'
    
    
    // Copy output files in the specified output result
    publishDir "${params.outdir}/fastqc", mode: 'copy'
    
    input:
    tuple val(sample_id), path(reads)
    
    output:
    path "*.html", emit: html // Emit the HTML report
    path "*.zip", emit: zip // Emit the FastQC zipped output
    path "*", emit: reports // Emit all files
    
    script:
    """
    fastqc -q ${reads}
    """
}
