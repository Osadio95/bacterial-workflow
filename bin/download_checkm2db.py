import os
import urllib.request
import tarfile

# Get the absolute path of the folder containing the script
script_dir = os.path.dirname(os.path.abspath(__file__))

# db/ folder located at the root of the project
target_dir = os.path.join(script_dir, '..', 'db')
archive_name = 'checkm2_database.tar.gz'
archive_path = os.path.join(target_dir, archive_name)

# URL of the database
url = "https://zenodo.org/records/14897628/files/checkm2_database.tar.gz?download=1"

# Create the ../db/ folder if it doesn't exist
os.makedirs(target_dir, exist_ok=True)

# Download the archive if it doesn't exist
if not os.path.exists(archive_path):
    print(f"Downloading {archive_name} to {target_dir}...")
    urllib.request.urlretrieve(url, archive_path)
    print("Download complete.")
else:
    print("Archive already exists, download skipped.")

# Extract the archive to ../db/
print("Extracting...")
with tarfile.open(archive_path, 'r:gz') as tar:
    tar.extractall(path=target_dir)
print("Extraction complete.")

# Delete the archive
os.remove(archive_path)
print("Archive deleted.")

