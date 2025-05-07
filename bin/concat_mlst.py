import os
import csv

# Working directory
# Get the absolute path of the directory where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Create the absolute path to the working directory
directory = os.path.join(script_dir, '../results/mlst')

save_path = os.path.join(script_dir, '../results/mlst.csv')

# List to store the extracted lines
rows = []

# Define the custom header
header = ['Sample', 'File', 'Scheme', 'ST', 'Loci1', 'Loci2', 'Loci3', 'Loci4', 'Loci5', 'Loci6', 'Loci7']

# Add the header to the final file
rows.append(header)

# Traverse all .mlst.tsv files in the working directory
for filename in os.listdir(directory):
    if filename.endswith('.mlst.tsv'):
        file_path = os.path.join(directory, filename)
        try:
            with open(file_path, 'r') as f:
                lines = f.readlines()
                if len(lines) >= 1:
                    first_line = lines[0].strip().split('\t')  # First line of the file

                    # Add the filename as an identifier
                    sample_name = os.path.splitext(filename)[0]
                    first_line_with_id = [sample_name] + first_line

                    # Add the extracted first line
                    rows.append(first_line_with_id)
                else:
                    print(f"File {file_path} ignored (no lines)")

        except Exception as e:
            print(f"Error reading the file {file_path}: {e}")

# Save to a final CSV file
with open(save_path, 'w', newline='') as f_out:
    writer = csv.writer(f_out)
    writer.writerows(rows)

print("mlst.csv created")

