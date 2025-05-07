import os
import glob
import pandas as pd

# Get the absolute path of the folder where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Create absolute paths for the input folder and output file
input_dir = os.path.join(script_dir, "../results/identification")
output_file = os.path.join(script_dir, "../results/identification.csv")

# Initialize a list to store the extracted data
extracted_data = []

# Search for all .tsv files in the input directory
tsv_files = glob.glob(os.path.join(input_dir, "*identity.tsv"))

# Iterate through each .tsv file
for filepath in tsv_files:
    print(f"Processing file: {filepath}")
    
    # Load the TSV file into a DataFrame with sep='\t'
    try:
        df = pd.read_csv(filepath, sep='\t')
        # Check that the file has columns H and L
        if df.shape[1] >= 12:  # Ensure there are at least 12 columns
            # Extract the strain name from the file name (e.g., 12_S43)
            sample_name = os.path.basename(filepath).split('_')[0] + "_" + os.path.basename(filepath).split('_')[1]
            
            # Extract columns H (index 7) and L (index 12)
            h_column = df.iloc[:, 7]
            l_column = df.iloc[:, 12]
            
            # Create a new DataFrame with the extracted columns and sample name
            temp_df = pd.DataFrame({
                'sample_name': [sample_name] * len(h_column),  # Ensure sample_name is repeated for each row
                'refseq_full_organism_name': h_column,
                'taxid': l_column
            })
            
            extracted_data.append(temp_df)
        else:
            print(f"File {filepath} does not have enough columns.")
    except Exception as e:
        print(f"Error reading {filepath}: {e}")

# If data has been extracted, combine and save it into a single file
if extracted_data:
    combined_df = pd.concat(extracted_data, ignore_index=True)
    combined_df.to_csv(output_file, index=False)
    print(f"Data saved to {output_file}")
else:
    print("No data extracted.")

