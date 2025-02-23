#!/bin/bash

# שם מסד הנתונים
DB_FILE="animal_data.db"

# מחיקת מסד נתונים קודם (אם קיים)
if [ -f "$DB_FILE" ]; then
    echo "🔄 מחיקת מסד נתונים קיים..."
    rm $DB_FILE
fi

# יצירת מסד הנתונים והטבלה
echo "📦 יצירת מסד הנתונים SQLite..."
sqlite3 $DB_FILE <<EOF
CREATE TABLE IF NOT EXISTS animals (
    date_collected TEXT,
    species TEXT,
    sex TEXT,
    weight REAL
);
EOF

# בדיקה אם קובץ ה-CSV קיים
if [ ! -f "animal_data.csv" ]; then
    echo "❌ שגיאה: קובץ animal_data.csv לא נמצא!"
    exit 1
fi

# ייבוא הנתונים מה-CSV לטבלה
echo "📥 מייבא נתונים מ-animal_data.csv ל-SQLite..."
sqlite3 $DB_FILE <<EOF
.mode csv
.import --skip 1 animal_data.csv animals
EOF

# הצגת נתוני הטבלה
echo "📊 הצגת תוכן הטבלה:"
sqlite3 $DB_FILE "SELECT * FROM animals;"

# שמירת פלט לקובץ
sqlite3 $DB_FILE "SELECT * FROM animals;" > sqlite_output.txt

echo "✅ הנתונים הוזנו ונשמרו בהצלחה. פלט נשמר ב-sqlite_output.txt."

