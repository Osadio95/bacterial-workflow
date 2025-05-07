import os
import csv

# Get the absolute path of the directory where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Build the absolute path to the starting folder
start_dir = os.path.join(script_dir, '../results/checkm2')

save_path = os.path.join(script_dir, '../results/checkm2.csv')

# List to store the extracted lines
rows = []
header_written = False

# Recursively traverse subdirectories
for root, dirs, files in os.walk(start_dir):
    for file in files:
        if file == 'quality_report.tsv':
            file_path = os.path.join(root, file)
            try:
                with open(file_path, 'r') as f:
                    lines = f.readlines()
                    if len(lines) >= 2:
                        header = lines[0].strip().split('\t')
                        second_line = lines[1].strip().split('\t')

                        # Add the relative path as an identifier
                        sample_name = os.path.basename(root)
                        second_line_with_id = [sample_name] + second_line

                        # Add the header only once with "Sample" as the first column
                        if not header_written:
                            full_header = ['Sample'] + header
                            rows.append(full_header)
                            header_written = True

                        # Add the extracted line
                        rows.append(second_line_with_id)
                    else:
                        print(f"File {file_path} ignored (less than 2 lines)")
            except Exception as e:
                print(f"Error reading the file {file_path}: {e}")

# Save to a final CSV file
with open(save_path, 'w', newline='') as f_out:
    writer = csv.writer(f_out)
    writer.writerows(rows)

print("checkm2.csv created")

