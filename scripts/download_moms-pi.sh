!/bin/bash

# Download directory
DIR=/Users/mdozmorov/Documents/Data/GitHub/HMP2/MOMS-PI/
# Make directory, if not exist
mkdir -p $DIR
# Download URLs
URL01=http://vmc.vcu.edu/static/downloads/MOMS-PI_POP1.zip
# Actual download
curl -o $DIR`basename $URL01` $URL01
# Extract files
unzip -d $DIR  $DIR`basename $URL01`
# Remove the original file 
rm $DIR`basename $URL01`

