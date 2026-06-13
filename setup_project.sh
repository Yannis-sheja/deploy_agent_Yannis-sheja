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


