#!/bin/bash
#

dir=$1
dirout=$2
port=$3

if [[ -z $1 ]] || [[ -z $2 ]] ; then

  echo ""
  echo "Variables empty, usage is ${0} (1) (2)"
  echo ""
  echo "(1) = Relion directory in"
  echo "(2) = Backup directory out"
  echo "(3) = port number for scp (optional)"
  exit

fi

if [[ -z $3 ]] ; then
  port=22
fi

# Get directory full path
cwd=$(pwd)
dirin=$(cd ${dir}; pwd -P) #This is the true path, ignoring symbolic links
dirname=$(cd ${dir}; pwd) #This is the path including symbolic links
cd ${cwd}

# Directory and folder names
ext=$(echo ${dirin##*.})
name=$(basename $dirin .${ext})
dir=$(dirname $dirin)
rlnpath=$(echo $dirname | sed -n -e 's/^.*Relion//p')

#Report what's going to happen
echo ''
echo '#########################################################################'
echo ''
echo 'Relion directory name to be backed up:'
echo ${rlnpath}
echo ''
echo 'Relion directory to be backed up (ignoring symbolic links):'
echo ${dirin}
echo ''
echo 'Backup location is:'
echo ${dirout}
echo ''
echo 'The following directory structure will be created:'
echo ${dirout}/Relion${rlnpath}
echo ''
echo '#########################################################################'
echo ''
echo 'Hit Enter to continue or ctrl-c to quit...'
read p

#Write a README to the backup location with the original location of the files
echo "host information:" > $dirin/README
hostname -s >> $dirin/README
echo "" >> $dirin/README
echo "Refine3D location:" >> $dirin/README
echo $(ls -d -1 $dirin) >> $dirin/README
echo "" >> $dirin/README
cat $dirin/note.txt >> $dirin/README

#Set up directory on remote end
mkdir -p ${dirout}/Relion${rlnpath}

#Copy files from specified Refine3D directory to backup location
#rsync -aP --rsh=\'ssh -p ${port}\' $dirin/run.job \
scp -P $port -r $dirin \
${dirout}/Relion/${rlnpath}

rm -rf $dirin/README

# Finish
echo ""
echo "Done!"
echo "Script written by Kyle Morris"
echo ""
