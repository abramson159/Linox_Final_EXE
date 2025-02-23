import argparse
import matplotlib.pyplot as plt

# יצירת פרסר לקריאת פרמטרים
parser = argparse.ArgumentParser(description="Plant data plotting script")

# הגדרת הפרמטרים
parser.add_argument("--plant", type=str, required=True, help="Plant name")
parser.add_argument("--height", type=float, nargs='+', required=True, help="Height data (cm)")
parser.add_argument("--leaf_count", type=int, nargs='+', required=True, help="Leaf count data")
parser.add_argument("--dry_weight", type=float, nargs='+', required=True, help="Dry weight data (g)")

# פרמטרים שהוזנו
args = parser.parse_args()

# הדפסת הנתונים
print(f"Plant: {args.plant}")
print(f"Height data: {args.height} cm")
print(f"Leaf count data: {args.leaf_count}")
print(f"Dry weight data: {args.dry_weight} g")

# **תרשים 1: Scatter Plot - Height vs Leaf Count**
plt.figure(figsize=(10, 6))
plt.scatter(args.height, args.leaf_count, color='b')
plt.title(f'Height vs Leaf Count for {args.plant}')
plt.xlabel('Height (cm)')
plt.ylabel('Leaf Count')
plt.grid(True)
plt.savefig(f"{args.plant}_scatter.png")
plt.close()

# **תרשים 2: Histogram - Distribution of Dry Weight**
plt.figure(figsize=(10, 6))
plt.hist(args.dry_weight, bins=5, color='g', edgecolor='black')
plt.title(f'Histogram of Dry Weight for {args.plant}')
plt.xlabel('Dry Weight (g)')
plt.ylabel('Frequency')
plt.grid(True)
plt.savefig(f"{args.plant}_histogram.png")
plt.close()

# **תרשים 3: Line Plot - Plant Height Over Time**
weeks = [f'Week {i+1}' for i in range(len(args.height))]
plt.figure(figsize=(10, 6))
plt.plot(weeks, args.height, marker='o', color='r')
plt.title(f'{args.plant} Height Over Time')
plt.xlabel('Week')
plt.ylabel('Height (cm)')
plt.grid(True)
plt.savefig(f"{args.plant}_line_plot.png")
plt.close()

# סיום והודעה למשתמש
print(f"✅ Generated plots for {args.plant}:")
print(f"- Scatter plot saved as {args.plant}_scatter.png")
print(f"- Histogram saved as {args.plant}_histogram.png")
print(f"- Line plot saved as {args.plant}_line_plot.png")
