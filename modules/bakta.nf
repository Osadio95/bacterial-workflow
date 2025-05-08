process BAKTA {
    tag "${sample_id}"
    label 'process_medium'
    
    container 'staphb/bakta:1.9.4'
    
    publishDir "${params.outdir}/bakta", mode: 'copy'
    
    input:
    tuple val(sample_id), path(contigs)
    
    output:
    path "${sample_id}/*.gff3", emit: gff3
    path "${sample_id}/*.tsv", emit: tsv
    path "${sample_id}/*.embl", emit: embl
    path "${sample_id}/*.faa", emit: faa
    path "${sample_id}/*.ffn", emit: fnn
    path "${sample_id}/*.fna", emit: fna
    path "${sample_id}/*.json", emit: json

   when:
    params.bakta 
        
    script:
    """
     bakta --db ${params.bakta_db} ${contigs} --output ${sample_id} --verbose --skip-tmrna --skip-rrna --skip-ncrna --skip-ncrna-region --skip-crispr --skip-pseudo --skip-gap
    """
}
