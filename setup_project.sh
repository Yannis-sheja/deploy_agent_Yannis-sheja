#!/bin/bash 

set -e

# PART 1: SIGNAL TRAP 

cleanup() {

	echo ""
	echo " Script Interrupted! Performing Emergency Cleanup.. "

if [ -d "$PROJECT_DIR" ]; then
	echo " Archiving Current state to: $PROJECT_DIR_archive.tar.gz"

	tar -czf "$PROJECT_DIR_archive.tar.gz" "$PROJECT_DIR"

	echo "Deleting Incomplete Directory: $PROJECT_DIR"

	rm -rf "$PROJECT_DIR"

	echo "Archive saved as: $PROJECT_DIR_archive.tar.gz"
else

echo "There is no directory to archive. Now Exiting Cleanly."

fi 

exit 1 
}

trap cleanup SIGINT 

# PART 2: WELCOME BANNER

echo ""
echo " Student Attendance Tracker: Project Factory "
echo "" 
echo ""

#PART 3: GETTING USER INPUT 

read -p " Enter the Project Name(i.e Name of directory eg; semester 1): " INPUT

if [ -z "$INPUT" ]; then 
	echo " Error: Project Name cannot be empty. Exiting "

	exit 1
fi 

PROJECT_DIR= "attendance_tracker_{$INPUT}"

echo ""
echo "Project Directory will be: $PROJECT_DIR"
echo ""

# PART 4: CREATION OF DIRECTORY

if [ -d "$PROJECT_DIR" ]; then 
	echo " Warning: Directory '$PORJECT_DIR' already exists "
	read -p "Do you want to overwrite it? (yes/no): " OVERWRITE

	if [ "$OVERWRITE" != "yes" ]; then 

	echo " Exiting without making changes. "
	exit 0
	
fi

rm -rf "$PROJECT_DIR"
 
echo " Creating The Directory Structure.." 

mkdir "$PROJECT_DIR"

mkdir -p "$PROJECT_DIR/Helpers"

mkdir -p "$PROJECT_DIR/reports"

echo " Directory Structure Created."

#PART 5: COPYING SOURCE FILES INTO THE DIRECTORIES  

echo " Copying Source Files " 

cp attendance_checker.py "$PROJECT_DIR/attendance_checker.py"

cp assets.csv "$PROJECT_DIR/Helpers/assets.csv"

cp config.json "$PROJECT_DIR/Helpers/config.json"

cp reports.log "$PROJECT_DIR/reports/reports.log"

echo "All files have been copied successfully" 

echo ""
echo "Project Directory Architecture" 

find "$PROJECT_DIR" -not name ".*" | sort 

#PART 6: DYNAMIC CONFIGURATION 

echo ""
echo "" 
echo " Configuration Setup " 
echo ""
echo " Current attendance tresholds:"
echo " Warning threshold: 75% "
echo " Failure threshold: 50% "
echo ""

read -p " Do you want to update the attendance thresholds? (yes/no): " UPDATE_CONFIG 


