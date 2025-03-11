process MULTIQC {
    label 'process_low'
    
    container 'quay.io/biocontainers/multiqc:1.13--pyhdfd78af_0'
    
    publishDir "${params.outdir}", mode: 'copy'
    
    input:
    path fastqc_reports
    path fastp_reports
    path quast_reports
 
       
         
    output:
    path "multiqc_report.html", emit: report
    path "multiqc_data", emit: data
    
    script:
    """
    multiqc --force .
    """
}
