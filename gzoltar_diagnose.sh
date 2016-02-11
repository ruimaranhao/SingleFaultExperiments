#!/bin/bash
# --------------------------------------------------------------------
#
# This script checkouts and compiles a specific Defects4J project/bug,
# and runs GZoltar on it.
#
# Usage:
# ./gzoltar_diagnose.sh <pid> <vid> <coefficient> <data dir>
#
# Parameters:
# - <pid>         Defects4J's project ID: Chart, Closure, Lang, Math, or Time.
# - <vid>         Version ID
# - <coefficient> TARANTULA, OCHIAI, OPT2, BARINEL, DSTAR
# - <data dir>    Directory where data will be saved by GZoltar
#
# Examples:
#
# - Executing GZoltar on project Chart-5 with Ochiai coefficient enabled
#   $ ./gzoltar_diagnose.sh Chart 5 OCHIAI /home/user/exps/Chart-5/Ochiai
#
# Environment variables:
# - D4J_HOME      Needs to be set and must point to the Defects4J
#                 installation.
# - GZOLTAR_JAR   GZoltar jar file
#
# --------------------------------------------------------------------

PWD=`pwd`

##
# Print error message and exit
##
die() {
  echo $1
  rm -rf $TMP_DIR
  exit 1
}

export JAVA_HOME=`/usr/libexec/java_home -v 1.7`

JAVA_VERSION=$(java -version 2>&1 | sed 's/java version "\(.*\)\.\(.*\)\..*"/\1\2/; 1q')
echo "$JAVA_VERSION"
if [[ "$JAVA_VERSION" != "17" ]]; then
  die "You need Java-7 to run this script!"
fi

##
# Print usage message and exit
##
usage() {
  die "usage: $0 <pid> <vid> <coefficient> <data dir>"
}

# Check arguments and set PID and VID range
[ $# -eq 4 ] || usage
PID=$1
VID=$2
COEFFICIENT=$3
DATA_DIR=$4

# Check whether D4J_HOME is set
[ "$D4J_HOME" != "" ] || die "D4J_HOME is not set!"
[ "$GZOLTAR_JAR" != "" ] || die "GZOLTAR_JAR is not set!"

export TZ='America/Los_Angeles'

# Set temporary directory used to checkout the project versions
TMP_DIR="/tmp/run_gzoltar_"$$"_$PID-$VID"

# Clean and create the temporary directory, if necessary
rm -rf $TMP_DIR
mkdir -p $TMP_DIR
rm -rf $DATA_DIR
mkdir -p $DATA_DIR

# --------------------------------------------------------------------
# Prepare Project under test

# Defects4J directories for given project id (PID)
DIR_LOADED_CLASSES="$D4J_HOME/framework/projects/$PID/loaded_classes"
DIR_RELEVANT_TESTS="$D4J_HOME/framework/projects/$PID/relevant_tests"

# Obtain buggy project version
echo "* Checking out $PID-$VID to $TMP_DIR"
defects4j checkout -p $PID -v ${VID}b -w $TMP_DIR

pushd . > /dev/null 2>&1
cd $TMP_DIR

# Collect loaded classes and convert new line "\n" to ":"
LOADED_CLASSES=$(cat "$DIR_LOADED_CLASSES/$VID.src" | tr '\n' ':')

# Collect relevant tests (i.e., those that touch at least one of the modified sources)
RELEVANT_TESTS=$(cat "$DIR_RELEVANT_TESTS/$VID" | tr '\n' ':')

# Get project classpah (classes directory, test-classes directory, and jar files)
CP=$(defects4j export -p cp.test)

# Compile project under test
echo "* Compiling $PID-$VID"
defects4j compile

popd > /dev/null 2>&1

# --------------------------------------------------------------------
# Run GZoltar

echo "* Running GZoltar"
java -Xmx5120M -jar $GZOLTAR_JAR \
  -Dproject_cp=$CP \
  -Dgzoltar_data_dir=$DATA_DIR \
  -Dcoefficient=$COEFFICIENT \
  -Dtargetclasses=$LOADED_CLASSES \
  -Dtestclasses=$RELEVANT_TESTS \
  -DprojectID="$PID-$VID" \
  -DconfigurationID="$PID-$VID-$COEFFICIENT" \
  -Dtimelimit=14400 \
  -Dtest_case_timeout=-1 \
  -Dmax_client_memory=5120 \
  -Dmax_perm_size=512 \
  -diagnose

# Remove temporary directory
rm -rf $TMP_DIR

echo "DONE!"

# EOF
