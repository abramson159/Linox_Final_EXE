#!/bin/bash

# קבלת נתוני CSV
csv_file="bugs.csv"

# קריאת כל שורה בקובץ ה-CSV
while IFS=, read -r BugID Description Branch DevName Priority RepoPath GitHubURL
do
    # דילוג על כותרת
    if [[ "$BugID" == "BugID" ]]; then
        continue
    fi

    # יצירת הודעת Commit
    curr_date=$(date +"%Y-%m-%d_%H-%M-%S")
    commit_message="${BugID}:${curr_date}:${Branch}:${DevName}:${Priority}:${Description}"

    # ביצוע commit
    if [ -d "$RepoPath" ]; then
        cd "$RepoPath" || exit
        git add .
        git commit -m "$commit_message"
        cd - > /dev/null
    else
        echo "Error: Repository path $RepoPath does not exist."
    fi

    # יצירת קובץ commits.txt
    echo "$commit_message" >> ../commits.txt

done < "$csv_file"
