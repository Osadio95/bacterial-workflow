import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

# Load the data
script_dir = os.path.dirname(os.path.abspath(__file__))
file_path = os.path.join(script_dir, '../results.xlsx')
df = pd.read_excel(file_path, sheet_name='identification')

# Clean the data
df = df.dropna(subset=['refseq_full_organism_name'])

# Count and proportion
species_counts = df['refseq_full_organism_name'].value_counts()
species_proportions = (species_counts / species_counts.sum()) * 100

# Combined DataFrame
summary_df = pd.DataFrame({
    'Organism': species_counts.index,
    'Count': species_counts.values,
    'Proportion (%)': species_proportions.values
})

# Sort for display
summary_df = summary_df.sort_values(by='Count', ascending=True)

# Dynamic figure size based on the number of species
fig_height = max(6, len(summary_df) * 0.3)

# Elegant color palette
colors = sns.color_palette("tab20c", len(summary_df))

# Plot
plt.figure(figsize=(10, fig_height))
bars = plt.barh(summary_df['Organism'], summary_df['Count'], color=colors)

# Add labels (count and proportion)
for i, (count, prop) in enumerate(zip(summary_df['Count'], summary_df['Proportion (%)'])):
    plt.text(count + 0.5, i, f"{count} ({prop:.1f}%)", va='center', fontsize=9)

# Axes and title
plt.xlabel("Number of samples", fontsize=12)
plt.ylabel("RefSeq Organism", fontsize=12)
plt.title("Species distribution based on closest RefSeq match", fontsize=14, weight='bold')
plt.tight_layout()

# Output directory
output_dir = "data_analysis"
os.makedirs(output_dir, exist_ok=True)

# Save to data_analysis folder
plt.savefig(os.path.join(output_dir, "species_barplot.png"), dpi=300)
plt.savefig(os.path.join(output_dir, "species_barplot.pdf"))

