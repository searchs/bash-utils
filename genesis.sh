#!/usr/bin/env sh

# Create SBT project
# Usage: sh ./genesis.sh project-name

project_name=$1
mkdir $project_name
cd $project_name
mkdir -p src/{main,test}/{java,resources,scala}
mkdir lib project target
touch build.sbt
cd ..
find .
echo "Done ...."
