import pandas as pd
import os

# Get the absolute path of the folder where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Folder containing the CSV files
folder = os.path.join(script_dir, '../results')

# List of CSV files with optional file management
csv_files = []
required_files = ['quast.csv', 'identification.csv', 'mlst.csv', 'AMR.csv']
optional_files = ['serotyping.csv', 'kleborate.csv', 'ectyper.csv', 'checkm2.csv']

# Check required files
for fname in required_files:
    file_path = os.path.join(folder, fname)
    if os.path.exists(file_path):
        csv_files.append(file_path)
    else:
        print(f" Missing required file: {fname}")
        # For required files, you might choose to exit with an error
        # exit(1)

# Check optional files
for fname in optional_files:
    file_path = os.path.join(folder, fname)
    if os.path.exists(file_path):
        csv_files.append(file_path)
    else:
        print(f" Optional file not found: {fname} - ignored")

if not csv_files:
    print(" No valid CSV files found. Script stopped.")
    exit(1)

# Output path of the Excel file
excel_path = os.path.join(script_dir, '../results.xlsx')

try:
    # Create an Excel file
    with pd.ExcelWriter(excel_path, engine='openpyxl') as writer:
        for csv_file in csv_files:
            try:
                df = pd.read_csv(csv_file)
                sheet_name = os.path.splitext(os.path.basename(csv_file))[0]
                df.to_excel(writer, sheet_name=sheet_name[:31], index=False)
                print(f" {os.path.basename(csv_file)} added to the Excel file")
            except Exception as e:
                print(f"Error while processing {csv_file}: {str(e)} - sheet ignored")
    
    print(f"\n Excel file successfully created: {excel_path}")
    print(f"Included sheets: {', '.join([os.path.basename(f) for f in csv_files])}")

except Exception as e:
    print(f" Critical error while creating the Excel file: {str(e)}")
    exit(1)

