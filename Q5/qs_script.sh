#!/bin/bash

# קובץ ה-CSV
csv_file="animal_data.csv"
output_file="5_output.txt"
log_file="qs_script.log"

# פתיחת הלוג
echo "==== QS Script Log - $(date) ====" > "$log_file"

# בדיקה אם קובץ ה-CSV קיים
if [ ! -f "$csv_file" ]; then
    echo "❌ Error: CSV file '$csv_file' not found." | tee -a "$log_file"
    exit 1
fi

# תפריט לביצוע פעולות
while true; do
    echo -e "\n📊 Animal Data Management System"
    echo "1. Create CSV by name"
    echo "2. Display CSV with row index"
    echo "3. Add new row"
    echo "4. Display species and AVG weight"
    echo "5. Filter by species and sex"
    echo "6. Save output to new CSV"
    echo "7. Delete row by index"
    echo "8. Update weight by row index"
    echo "9. Exit"
    read -p "Choose an option (1-9): " option

    case $option in
        1)  # יצירת קובץ CSV חדש לפי שם
            read -p "Enter new CSV file name: " new_csv
            echo "Date Collected,Species,Sex,Weight" > "$new_csv"
            echo "✅ New CSV file created: $new_csv" | tee -a "$log_file"
            ;;

        2)  # הצגת נתוני CSV עם אינדקס שורות
            echo -e "\n📄 Displaying CSV with Row Index:"
            awk 'BEGIN{FS=OFS=","} {print NR-1, $0}' "$csv_file"
            ;;

        3)  # הוספת שורה חדשה
            read -p "Enter Date Collected (e.g., 1/8): " date
            read -p "Enter Species (e.g., OT): " species
            read -p "Enter Sex (M/F): " sex
            read -p "Enter Weight: " weight
            echo "$date,$species,$sex,$weight" >> "$csv_file"
            echo "✅ New row added: $date, $species, $sex, $weight" | tee -a "$log_file"
            ;;

        4)  # הצגת מין ומשקל ממוצע
            read -p "Enter species to filter by (e.g., OT): " species
            echo -e "\n🔍 Items of species '$species' with AVG weight:"
            awk -F, -v sp="$species" '$2==sp && $4!="" {sum+=$4; count++} 
            END {if(count > 0) print "Average Weight for", sp, ":", sum/count; else print "No data found for", sp}' "$csv_file"
            ;;

        5)  # סינון לפי מין ומין
            read -p "Enter species to filter by (e.g., OT): " species
            read -p "Enter sex to filter by (M/F): " sex
            echo -e "\n🔍 Filtering by species '$species' and sex '$sex':"
            awk -F, -v sp="$species" -v sx="$sex" '$2==sp && $3==sx' "$csv_file"
            ;;

        6)  # שמירת פלט לקובץ חדש
            cp "$csv_file" "$output_file"
            echo "✅ Output saved to '$output_file'" | tee -a "$log_file"
            ;;

        7)  # מחיקת שורה לפי אינדקס
            read -p "Enter row index to delete: " row_index
            awk -v idx="$row_index" 'NR!=idx+1' "$csv_file" > temp.csv && mv temp.csv "$csv_file"
            echo "✅ Row $row_index deleted." | tee -a "$log_file"
            ;;

        8)  # עדכון משקל לפי אינדקס
            read -p "Enter row index to update weight: " row_index
            read -p "Enter new weight: " new_weight
            awk -v idx="$row_index" -v weight="$new_weight" 'BEGIN {FS=OFS=","} NR==idx+1 {$4=weight} {print}' "$csv_file" > temp.csv && mv temp.csv "$csv_file"
            echo "✅ Weight updated for row $row_index." | tee -a "$log_file"
            ;;

        9)  # יציאה
            echo "👋 Exiting script. Bye!"
            break
            ;;

        *)  # אפשרות לא חוקית
            echo "❌ Invalid option. Please choose 1-9."
            ;;
    esac
done
