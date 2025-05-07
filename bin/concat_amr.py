import os
import pandas as pd

# Get the absolute path of the file
# Get the absolute path of the folder where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Create an absolute path for the working directory
# Create an absolute path for the working directory
directory = os.path.join(script_dir, '../results/abricate')

save_path = os.path.join(script_dir, '../results/AMR.csv')

# Dictionary to keep the grouped values
# Dictionary to store the grouped values
all_data = {}

# All csv and tsv files
# Loop through all .csv and .tsv files
for filename in os.listdir(directory):
    if filename.endswith('.csv') or filename.endswith('.tsv'):
        file_path = os.path.join(directory, filename)
        sep = '\t' if filename.endswith('.tsv') else ','

        try:
            df = pd.read_csv(file_path, sep=sep)

            # Check if the '#FILE' column is present
            # Check if the '#FILE' column is present
            if '#FILE' not in df.columns:
                print(f"Column '#FILE' missing in: {filename}")
                continue

            for _, row in df.iterrows():
                file_id = row['#FILE']

                if file_id not in all_data:
                    all_data[file_id] = {'GENE': [], 'PRODUCT': []}

                # Add genes if present
                # Add genes if present
                if 'GENE' in df.columns and pd.notna(row.get('GENE')):
                    all_data[file_id]['GENE'].append(str(row['GENE']).strip())

                # Add resistances if present
                # Add resistances if present
                if 'RESISTANCE' in df.columns and pd.notna(row.get('RESISTANCE')):
                    all_data[file_id]['PRODUCT'].append(str(row['RESISTANCE']).strip())

        except Exception as e:
            print(f"Error in file {filename}: {e}")

# Cleaning and final formatting
# Cleaning and final formatting
final_rows = []
for file_id, values in all_data.items():
    gene_list = [g for g in values['GENE'] if g and g.lower() != 'nan']
    product_list = [p for p in values['PRODUCT'] if p and p.lower() != 'nan']

    # Remove duplicates while keeping order
    # Remove duplicates while keeping order
    clean_gene = ','.join(dict.fromkeys(gene_list))
    clean_product = ','.join(dict.fromkeys(product_list))

    final_rows.append({
        '#FILE': file_id,
        'GENE': clean_gene,
        'PRODUCT': clean_product
    })

# Create a final DataFrame
# Create the final DataFrame
final_df = pd.DataFrame(final_rows)

# Save the final file
# Save the final file
final_df.to_csv(save_path, index=False)

print("AMR.csv created.")

