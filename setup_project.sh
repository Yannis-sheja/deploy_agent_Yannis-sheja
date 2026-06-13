#!/bin/bash 

set -e 

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


echo ""
echo " Student Attendance Tracker: Project Factory "
echo "" 
echo ""

read -p " Enter the Project Name(i.e Name of directory eg; semester 1): " INPUT

if [ -z "$INPUT" ]; then 
	echo " Error: Project Name cannot be empty. Exiting "

	exit 1
fi 

PROJECT_DIR= "attendance_tracker_{$INPUT}"

echo ""
echo "Project Directory will be: $PROJECT_DIR"
echo ""
