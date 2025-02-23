#!/bin/bash

# קובץ ה-CSV
csv_file="bugs.csv"

# בדיקה אם קובץ ה-CSV קיים
if [ ! -f "$csv_file" ]; then
    echo "❌ Error: CSV file '$csv_file' not found in the current directory."
    exit 1
fi

# פרמטרים אופציונליים
custom_description=""
custom_priority=""
custom_githuburl=""
dev_note=""

# קריאת פרמטרים
while getopts d:p:g:n: flag
do
    case "${flag}" in
        d) custom_description=${OPTARG};;  # תיאור חדש
        p) custom_priority=${OPTARG};;     # עדיפות חדשה
        g) custom_githuburl=${OPTARG};;    # URL חדש
        n) dev_note=${OPTARG};;            # הערה נוספת
    esac
done

# קריאת כל שורה בקובץ ה-CSV (ללא כותרת)
tail -n +2 "$csv_file" | while IFS=, read -r BugID Description Branch DevName Priority RepoPath GitHubURL
do
    # דילוג על שורות ריקות
    if [ -z "$BugID" ]; then
        continue
    fi

    # דריסת ערכים אם ניתנו כפרמטרים
    Description="${custom_description:-$Description}"
    Priority="${custom_priority:-$Priority}"
    GitHubURL="${custom_githuburl:-$GitHubURL}"

    # יצירת הודעת Commit
    curr_date=$(date +"%Y-%m-%d_%H-%M-%S")
    commit_message="${BugID}:${curr_date}:${Branch}:${DevName}:${Priority}:${Description}"

    # הוספת הערת המפתח הבכיר אם ניתנה
    if [ -n "$dev_note" ]; then
        commit_message="${commit_message} | DevNote: ${dev_note}"
    fi

    # ביצוע commit אם התיקייה קיימת
    if [ -d "$RepoPath" ]; then
        cd "$RepoPath" || { echo "❌ Error: Failed to navigate to $RepoPath"; exit 1; }
        git add .

        # ניסיון לבצע commit
        if git commit -m "$commit_message"; then
            echo "✅ Commit successful for BugID $BugID"
        else
            echo "❌ Error: Commit failed for BugID $BugID"
            continue
        fi

        # ניסיון לבצע push
        if git push origin "$Branch"; then
            echo "✅ Push successful for branch $Branch"
        else
            echo "❌ Error: Push failed for branch $Branch"
            continue
        fi

        cd - > /dev/null
    else
        echo "❌ Error: Repository path $RepoPath does not exist."
        continue
    fi

    # הוספת הודעת ה-commit לקובץ commits.txt
    echo "$commit_message | GitHubURL: $GitHubURL" >> commits.txt

done

echo "✅ All tasks completed. Check 'commits.txt' for details."
