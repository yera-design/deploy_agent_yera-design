Student Attendance Tracker Script Overview

A simple script that automatically creates the complete project structure for the Student Attendance Tracker.

How to Run

1.Make the script executable:

chmod +x setup_project.sh

Run it:

./setup_project.sh

2.Follow the prompts:

  a)Enter a name for your project

  b)Choose whether to update warning/failure thresholds
   (If yes, enter new percentage values)
   And if no input, the thresholds are going to be automatically set to the default values

That's it! The script creates everything you need.

What Gets Created

After running, you'll have a folder called attendance_tracker_(input) containing:

attendance_checker.py – The main Python program

Helpers/ folder with assets.csv and config.json

reports/ folder with an empty reports.log

3.Archive Feature (Ctrl+C)

If you press Ctrl+C while the script is running, it will:

a)Create a backup archive of everything created so far
b)Delete the incomplete project folder
c)Exit cleanly

How to test it:

I.Run 
 ./setup_project.sh

II.Enter a name
While files are being created, press Ctrl+C
You'll see an archive file named attendance_tracker_yourname_archive

The archive saves your work so nothing is lost if you need to cancel.


4.Final Check

The script automatically checks if Python 3 is installed and shows:

 Python 3.x.x installed is  (if found)

Python 3 is not installed   (if missing)


https://www.youtube.com/watch?v=heGXlUDQlYY(Link to the video)
