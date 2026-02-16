#!/usr/bin/env bash 

trap '
echo
echo "Terminated! Archiving current state..."
	if [ -n "$input" ]; then
		cd ..	
		archive_name="attendance_tracker_${input}_archive"
		tar -czf "$archive_name" "attendance_tracker_$input_archive" 2>/dev/null
		echo "Archive has been created: $archive_name"
		rm -rf "attendance_tracker_$input"
		echo "Incomplete directory removed"
	else
	       echo "No directory to archive"
	
	fi
	echo "Cleanup complete. Exiting now"

	exit
' SIGINT

echo "Starting attendance tracker setup ....."

#Creating the parent directory due to the input of the user"
echo " Enter a name for your attendance tracker:"
read input
par_dir="attendance_tracker_$input"
echo "Creating $par_dir directory ..."
mkdir $par_dir
cd "$par_dir" || exit 1
mkdir Helpers
mkdir reports
touch attendance_checker.py
touch Helpers/assets.csv
touch Helpers/config.json
touch reports/reports.log
cat > attendance_checker.py << 'EOF'
print("attendance checker running...")
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
	# 1. Load Config
	with open('Helpers/config.json', 'r') as f:
		config = json.load(f)
	# 2. Archive old reports.log if it exists
	if os.path.exists('reports/reports.log'):
		timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
		os.rename('reports/reports.log',
f'reports/reports_{timestamp}.log.archive')

	# 3. Process Data
	with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log',
'w') as log:
	reader = csv.DictReader(f)
	total_sessions = config['total_sessions']

	log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")

	for row in reader:
		name = row['Names']
		email = row['Email']
		attended = int(row['Attendance Count'])

		# Simple Math: (Attended / Total) * 100
		attendance_pct = (attended / total_sessions) * 100

		message = ""
		if attendance_pct < config['thresholds']['failure']:
			message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}
%. You will fail this class."
	elif attendance_pct < config['thresholds']['warning']:
		message = f"WARNING: {name}, your attendance is
{attendance_pct:.1f}%. Please be careful."

	if message:
		if config['run_mode'] == "live":
			log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}
\n")
			print(f"Logged alert for {name}")
		else:
			print(f"[DRY RUN] Email to {email}: {message}")
if __name__ == "__main__":
	run_attendance_check()
EOF

cat > Helpers/assets.csv << 'EOF'
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
EOF

cat > Helpers/config.json << 'EOF'
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
EOF

echo "Do you want to update the attendance thresholds?(y/n)"
read response

if [[ "$response" == "y" || "$response" == "yes" ]]
then
	echo "Enter warning threshold(default=75):"
	read warning_value
	if [[ -z "$warning_value" ]]
	then 
		warning_value=75
		echo "Applying default warning: 75"
	fi
	
	echo "Enter failure threshold(default=50):"
	read failure_value
	if [[ -z "$failure_value" ]]
	then
		failure_value=50
		echo "Applying default failure: 50"
	fi
        echo "Thresholds are updating..."

	warning_pattern='s/"warning": [0-9]\+/"warning": '$warning_value'/g'
	sed -i "$warning_pattern" Helpers/config.json

	failure_pattern='s/"failure": [0-9]\+/"failure": '$failure_value'/g'
	sed -i "$failure_pattern" Helpers/config.json
	cat Helpers/config.json
	echo "Thresholds have been updated successfully"
		

else 
	echo "Maintained default thresholds(warning 75, failure 50)"
fi

cd ..

echo "Performing Health check"
echo "......................."

if command -v python3 &> /dev/null; then
	version=$(python3 --version)
	echo "$version is installed"
	echo "the set up has been completed successfully"
else
	echo "Python 3 is not installed"
	echo "The attendance tracker requires Python 3 to run"
	
fi


