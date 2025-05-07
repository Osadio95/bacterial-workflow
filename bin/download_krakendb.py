import os
import urllib.request
import tarfile

# Define the absolute path of the script folder
script_dir = os.path.dirname(os.path.abspath(__file__))

# Target folder: ../db/kraken
target_dir = os.path.join(script_dir, '..', 'db', 'kraken')
os.makedirs(target_dir, exist_ok=True)

# Archive name and path
archive_name = 'minikraken2_v1_8GB_201904.tgz'
archive_path = os.path.join(target_dir, archive_name)

# URL of the file
url = 'https://genome-idx.s3.amazonaws.com/kraken/minikraken2_v1_8GB_201904.tgz'

# Download if not already present
if not os.path.exists(archive_path):
    print(f'Downloading {archive_name} to {target_dir}...')
    urllib.request.urlretrieve(url, archive_path)
    print('Download complete.')
else:
    print('Archive already present, download skipped.')

# Extract the archive
print('Extracting the archive...')
with tarfile.open(archive_path, 'r:gz') as tar:
    tar.extractall(path=target_dir)
print('Extraction complete.')

# Delete the archive
os.remove(archive_path)
print('Archive deleted.')

