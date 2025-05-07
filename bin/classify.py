#!/usr/bin/env python3
import os
import pandas as pd
import shutil
import glob

# Get the absolute path of the folder where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Configuration with absolute paths
identity_dir = os.path.join(script_dir, "../results/identification")  # Folder containing identity.tsv files
source_dir = os.path.join(script_dir, "../results/spades")  # Folder with SPAdes files
output_dir = os.path.join(script_dir, "../results/identification")  # Destination folder

# Create the output folder if it does not exist
os.makedirs(output_dir, exist_ok=True)

# Target species and their associated suffixes
species_targets = {
    "Escherichia coli": "ecoli",
    "Klebsiella pneumoniae": "klebsiella",
    "Salmonella enterica": "salmonella"
}

# Counter to track operations
stats = {species: 0 for species in species_targets.keys()}
errors = 0
processed = 0

# Search for all identity.tsv files
identity_files = glob.glob(os.path.join(identity_dir, "*_identity.tsv"))
print(f"Number of identity.tsv files found: {len(identity_files)}")

for identity_file in identity_files:
    # Extract the sample ID from the file name
    basename = os.path.basename(identity_file)
    sample_id = basename.split("_identity.tsv")[0]
    
    try:
        # Read the TSV file
        df = pd.read_csv(identity_file, sep='\t')
        
        # Identify the column containing the species name
        species_column = None
        possible_columns = ['species', 'taxon_name', 'refseq_organism_name', 'refseq_full_organism_name']
        
        for col in possible_columns:
            if col in df.columns:
                species_column = col
                break
        
        if not species_column:
            print(f"Unable to find a species column in {basename}")
            print(f"   Available columns: {', '.join(df.columns)}")
            errors += 1
            continue
            
        # Get the identified species (take the first line)
        if len(df) > 0:
            species = df[species_column].iloc[0]
            print(f"{sample_id}: identified as {species}")
        else:
            print(f" {sample_id}: no data in the identity.tsv file")
            errors += 1
            continue
            
        # Check if the species matches one of our targets
        matched_species = None
        species_suffix = None
        
        # Exact match check
        if species in species_targets:
            matched_species = species
            species_suffix = species_targets[species]
        else:
            # Partial match check
            for target_species, suffix in species_targets.items():
                if suffix.lower() in species.lower():
                    matched_species = target_species
                    species_suffix = suffix
                    break
        
        if not species_suffix:
            print(f"{sample_id}: species '{species}' not targeted, ignored")
            continue
            
        # Search for the corresponding contig file
        matching_file = None
        for f in os.listdir(source_dir):
            if f.startswith(sample_id) and f.endswith(".fas"):
                matching_file = f
                break
                
        if not matching_file:
            print(f"Contig file for {sample_id} not found in {source_dir}")
            errors += 1
            continue
            
        # Extract the base name and create the new name
        contig_basename, ext = os.path.splitext(matching_file)
        new_filename = f"{contig_basename}_{species_suffix}{ext}"
        
        # Check if the file already exists
        dest_path = os.path.join(output_dir, new_filename)
        if os.path.exists(dest_path):
            print(f" {new_filename} already exists, ignored")
            continue
            
        # Copy with the new name
        src_path = os.path.join(source_dir, matching_file)
        shutil.copy2(src_path, dest_path)
        print(f"{matching_file} → {new_filename}")
        stats[matched_species] += 1
        processed += 1
            
    except Exception as e:
        print(f"Error processing {basename}: {str(e)}")
        errors += 1

# Display the summary
print("\n--- Summary ---")
for species, count in stats.items():
    print(f"{species}: {count} files processed")
print(f"Errors: {errors} files with issues")
print(f"Total: {processed} files successfully copied")

