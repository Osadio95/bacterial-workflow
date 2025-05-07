import subprocess
import os

# Execute all the Python files in this order. First concatenate all the output from tools, create an Excel file with makereport.py, then perform data analysis
# List of scripts to execute in the specified order
scripts = [
    "concat_checkm2.py", 
    "concat_identification.py",
    "concat_mlst.py",
    "concat_amr.py",
    "concat_quast.py",
    "concat_kleborate.py",
    "concat_seqsero.py",
    "concat_ectyper.py",
    "makereport.py",
    "transform.py",
    "data_analysis.py"
]

# Absolute path to the bin folder
# Path to the bin folder
bin_dir = "./bin"

# Function to run each script
def run_scripts(scripts, directory):
    for script in scripts:
        script_path = os.path.join(directory, script)
        try:
            print(f"Running {script_path}...")
            result = subprocess.run(['python', script_path], check=True, text=True, capture_output=True)
            print(result.stdout)  # Display the script's output
        except subprocess.CalledProcessError as e:
            print(f"Error executing {script_path}: {e}")
            print(f"Error output: {e.stderr}")
        except FileNotFoundError:
            print(f"File not found: {script_path}")

# Execute all the scripts
run_scripts(scripts, bin_dir)

