process CHECKM2 {
    tag "${sample_id}"
    label 'process_medium'
    
    container 'staphb/checkm2'
    

    
    publishDir "${params.outdir}/checkm2", mode: 'copy'
    
    input:
    tuple val(sample_id), path(contigs)
    
    output:
    path "${sample_id}_checkm2/*", emit: results
    path "${sample_id}_checkm2/quality_report.tsv", emit: report
    
    when:
      params.checkm2 
            
    script:
    """
    # Créer un dossier pour les fichiers de contigs et pour la base de données
    mkdir -p input
    
    
    # Copier les contigs dans le dossier d'entrée
    cp ${contigs} input/
    
    
    # Exécuter CheckM2 avec la base de données téléchargée
    checkm2 predict \
        --threads ${task.cpus} \
        --input input/*fas \
        --output-directory ${sample_id}_checkm2 \
        --force \
        --database_path ${params.checkm2_db}
        
    """
}
