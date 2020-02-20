#!/usr/bin/env sh

# Create SBT based project
# Usage: sh ./genesis.sh project-name

project_name=$1
mkdir $project_name
cd ${project_name}

mkdir -p src/main/java
mkdir -p src/main/resources
mkdir -p src/main/scala

mkdir -p src/test/java
mkdir -p src/test/resources
mkdir -p src/test/scala

mkdir lib/ project/ target/

git init
echo 'target/
project/target
lib_managed/
project/boot/
project/build/target/
project/plugins/target/
project/plugins/lib_managed/
project/plugins/src_managed/
.vscode
.idea
' > .gitignore

echo 'name := "project_name"

version := "0.0.1"

scalaVersion := "2.13.1"
resolvers += "Artima Maven Repository" at "http://repo.artima.com/releases"


libraryDependencies ++= Seq(
    "org.scalatest" %% "scalatest" % "3.2.0-M1" % "test",
"org.scalamock" %% "scalamock-scalatest-support" % "3.6.0" % "test"

)' > build.sbt
ls -lah $project_name
printf "\n=========== SEE THE GENERATED PROJECT STRUCTURE =============\n"
cat build.sbt
printf "\n=========== NOW CODE!!! =============\n"

sleep 1
echo "project structure generated ...."
echo "Now update the build.sbt file accordingly! "
