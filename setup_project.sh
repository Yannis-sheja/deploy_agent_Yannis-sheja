#!/bin/bash 

set -e

# PART 1: PROCESS MANAGEMENT  

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

echo "----------------------------------------------"
echo " Student Attendance Tracker: Project Factory "
echo "----------------------------------------------" 
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
echo "----------------------" 
echo " Configuration Setup " 
echo "----------------------"
echo " Current attendance tresholds:"
echo " Warning threshold: 75% "
echo " Failure threshold: 50% "
echo ""

read -p " Do you want to update the attendance thresholds? (yes/no): " UPDATE_CONFIG 

if [ "$UPDATE_CONFIG" = "yes" ]; then 
	read -p "Enter new Warning threshold (default 75, numbers only): " NEW_WARNING 

	if ![[ "$NEW_WARNING" =~ ^[0-9]+$ ]]; then
		echo " Invalid Input: '$NEW_WARNING' is not a number. Keeping default 75. "
		NEW_WARNING=75 
	fi 
	
	if [ "$NEW_WARNING" -gt 100 ] || [ "$NEW_WARNING" -lt 0 ]; then 
		echo " Warning threshold must be between 0 and 100. Keeping default 75. " 
		NEW_WARNING=75
	fi

	read -p "Enter new Failure threshold (default 50, numbers only): " NEW_FAILURE 

	if ![[ "$NEW_FAILURE" =~ ^[0-9]+$ ]]; then
		echo " Invalid Input: '$NEW_FAILURE' is not number. Keeping default 50. " 
		NEW_FAILURE=50 
	fi
	
	if [ "$NEW_FAILURE" -gt 100 ] || [ "$NEW_FAILURE" -lt 0 ]; then
		echo " Failure threshold must be between 0 and 100. Keeping default 50. " 
		NEW_FAILURE=50 
	fi 

	if [ "$NEW_FAILURE" -ge "$NEW_WARNING" ]; then
		echo " Failure threshold must be less than the Warning threshold. Keeping defaults. " 
		NEW_WARNING=75
		NEW_FAILURE=50
	fi


	echo ""
	echo " Updating config.json using sed. "
	
	
	sed -i "s/\(\"warning_threshold\": \)[0-9]*/\1${NEW_WARNING}/" \ 
		"$PROJECT_DIR/Helpers/config.json"

	sed -i "s/\(\"failure_threshold\": \)[0-9]*/\1${NEW_FAILURE}/" \
        "$PROJECT_DIR/Helpers/config.json"

	echo " config.json updated "

	cat "$PROJECT_DIR/Helpers/config.json"
	
else 
	echo " Keeping default thresholds (warning: 75%, failure: 50%). "
fi 
#PART 7: ENVIRONMENT VALIDATION

echo "" 
echo "---------------------------------"
echo " Environment Health Check " 
echo "---------------------------------"

if commad -v python3 &>/dev/null; then 
	PYTHON_VERSION=$(python3 --version)
	echo " Python3 is installed: $PYTHON_VERSION "
else
	echo " Warning: Python3 is NOT installed in the system." 
	echo " The attendance_checker.py script will not run without Python3."
	echo " Install it with: sudo apt install python3 "
fi

echo ""
echo " Verifying Directory structure."

EXPECTED_PATHS=( 
	"$PROJECT_DIR/attendance_checker.py"
	"$PROJECT_DIR/Helpers"
	"$PROJECT_DIR/Helpers/assets.csv"
	"$PROJECT_DIR/Helpers/config/json"
	"$PROJECT_DIR/reports"
	"$PROJECT_DIR/reports/reports/log"
)

ALL_GOOD=true 

for PATH_CHECK in "${EXPECTED_PATHS[@]}"; do 
	if [ -e "$PATH_CHECK" ]; then
		echo " Found: $PATH_CHECK "
	else 
		echo " Missing: $PATH_CHECK " 
		ALL_GOOD=false
	fi

done

echo ""
if [ "$ALL_GOOD" = true ]; then
	echo " All Health checks passed! The Project is ready. "
else
	echo " Some files are missing. Please check the output above."
fi 

#PART 8: COMPLETION MESSAGE

echo"" 
echo "------------------------------"
echo " Setup Complete " 
echo "------------------------------"
echo ""
echo " Project created at: ./$PROJECT_DIR "
echo " To run the attendance checker: "
echo " cd $PROJECT_DIR "
echo " python3 attendance_checker.py " 
echo ""
echo " To trigger the archive or cleanup (simulate interrupt) "
echo " Press Ctrl+C while script is running " 
echo "-------------------------------------------
