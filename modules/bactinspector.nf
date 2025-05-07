process BACTINSPECTOR {
    tag "${sample_id}"
    container 'osadio95/bactinspector:latest' 
    
    publishDir "${params.outdir}/identification", mode: 'copy', pattern: '*.tsv'
        
    input:
    tuple val(sample_id), path(contigs)
    
    output:
    tuple val(sample_id), path("${sample_id}_identity.tsv"), emit: identification
    tuple val(sample_id), path("*ecoli.fas"), optional: true, emit: ecoli 
    tuple val(sample_id), path("*salmonella.fas"), optional: true, emit: salmonella  
    tuple val(sample_id), path("*klebsiella.fas"), optional: true, emit: klebsiella
    
    script:
    """
    # Run BactInspector
    bactinspector closest_match -f ${contigs} -o .
    
    # Get the most recent output file
    latest_output=\$(ls -t closest_matches_*.tsv | head -1)
    mv \$latest_output ${sample_id}_identity.tsv 
    
    # Renaming assembly files after identification
    python3 <<EOF
import os
import pandas as pd

# Configuration
species_targets = {
    "Escherichia coli": "ecoli",
    "Klebsiella pneumoniae": "klebsiella",
    "Salmonella enterica": "salmonella"
}

sample_id = "${sample_id}"
identity_file = "${sample_id}_identity.tsv"
contigs_file = "${contigs}"

try:
    # Read the TSV file
    df = pd.read_csv(identity_file, sep='\t')
    
    # Identify species column
    species_column = None
    possible_columns = ['species', 'taxon_name', 'refseq_organism_name', 'refseq_full_organism_name']
    
    for col in possible_columns:
        if col in df.columns:
            species_column = col
            break
    
    if not species_column:
        print(f"Impossible de trouver une colonne d'espèce dans {identity_file}")
        print(f"Colonnes disponibles: {', '.join(df.columns)}")
        exit(1)
        
    # Get identified species (take first row)
    if len(df) > 0:
        species = df[species_column].iloc[0]
        print(f" {sample_id}: identifié comme {species}")
    else:
        print(f"{sample_id}: aucune donnée dans le fichier identity.tsv")
        exit(1)
        
    # Check if species matches our targets
    species_suffix = None
    for target_species, suffix in species_targets.items():
        if target_species.lower() in species.lower():
            species_suffix = suffix
            break
    
    if not species_suffix:
        print(f"{sample_id}: espèce '{species}' non ciblée")
        exit(0)
    
    # Create the renamed contigs file
    contig_basename = os.path.splitext(os.path.basename(contigs_file))[0]
    new_filename = f"{contig_basename}_{species_suffix}.fas"
    
    # Copy with new name
    os.rename(contigs_file, new_filename)
    print(f" Fichier renommé: {new_filename}")

except Exception as e:
    print(f"Erreur lors du traitement: {str(e)}")
    exit(1)
EOF
    """
}
