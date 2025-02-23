#!/bin/bash

# ============================
# Plant Data Processing Script
# ============================

# קובץ לוג לרישום התהליך
log_file="plant_script.log"
echo "==== Plant Script Log - $(date) ====" > "$log_file"

# בדיקה אם ניתן קובץ CSV כפרמטר
if [ "$#" -ne 1 ]; then
    echo "❌ Error: Usage: $0 <path_to_csv>" | tee -a "$log_file"
    exit 1
fi

csv_file="$1"

# בדיקה אם קובץ ה-CSV קיים
if [ ! -f "$csv_file" ]; then
    echo "❌ Error: CSV file '$csv_file' not found." | tee -a "$log_file"
    exit 1
fi

echo "✔ CSV file found: $csv_file" | tee -a "$log_file"

# ============================
# יצירת סביבת VENV
# ============================
venv_path=~/Q4_ENV

# בדיקה אם הסביבה כבר קיימת
if [ ! -d "$venv_path" ]; then
    echo "🔧 Creating virtual environment at $venv_path" | tee -a "$log_file"
    python3 -m venv "$venv_path"
else
    echo "✔ Virtual environment already exists at $venv_path" | tee -a "$log_file"
fi

# הפעלת הסביבה
source "$venv_path/bin/activate"
echo "✔ Virtual environment activated" | tee -a "$log_file"

# ============================
# התקנת חבילות אם לא קיימות
# ============================
echo "🔄 Checking required packages..." | tee -a "$log_file"

if ! pip show matplotlib &>/dev/null; then
    echo "📦 Installing matplotlib..." | tee -a "$log_file"
    pip install matplotlib >> "$log_file" 2>&1
else
    echo "✔ matplotlib is already installed" | tee -a "$log_file"
fi

# ============================
# קריאת CSV והרצת plant.py
# ============================
echo "🚀 Processing plants from CSV..." | tee -a "$log_file"

tail -n +2 "$csv_file" | while IFS=, read -r Plant Height LeafCount DryWeight
do
    Plant=$(echo "$Plant" | tr -d '"')
    Height=$(echo "$Height" | tr -d '"')
    LeafCount=$(echo "$LeafCount" | tr -d '"')
    DryWeight=$(echo "$DryWeight" | tr -d '"')

    # יצירת תיקייה לכל צמח
    plant_dir="./$Plant"
    if [ ! -d "$plant_dir" ]; then
        mkdir -p "$plant_dir"
        echo "📁 Created directory: $plant_dir" | tee -a "$log_file"
    else
        echo "✔ Directory already exists: $plant_dir" | tee -a "$log_file"
    fi

    # הרצת plant.py עם הפרמטרים
    echo "🌿 Running Python script for plant: $Plant" | tee -a "$log_file"

    python3 plant.py \
    --plant "$Plant" \
    --height $Height \
    --leaf_count $LeafCount \
    --dry_weight $DryWeight >> "$log_file" 2>&1

    # בדיקה אם ההרצה הצליחה
    if [ $? -eq 0 ]; then
        echo "✅ Successfully generated plots for $Plant" | tee -a "$log_file"
        # העברת קבצי התרשימים לתיקיית הצמח
        mv ${Plant}_scatter.png ${Plant}_histogram.png ${Plant}_line_plot.png "$plant_dir" 2>/dev/null
    else
        echo "❌ Error: Failed to process plant: $Plant" | tee -a "$log_file"
    fi

done

# ============================
# סיום הסקריפט
# ============================
echo "🎉 Script completed successfully!" | tee -a "$log_file"
deactivate
echo "✔ Virtual environment deactivated" | tee -a "$log_file"
