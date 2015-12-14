#!/bin/sh

#exec > /tmp/${PROJECT_NAME}_archive.log 2>&1

WORKSPACE_PATH=../IMMSlackerClient.xcworkspace
SCHEME_NAME=IMMSlackerClient
BUILD_ROOT=.
BUILD_DIR=./build
CONFIGURATION=Release
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal
EXECUTABLE_PATH=IMMSlackerClient.framework/IMMSlackerClient
EXECUTABLE=IMMSlackerClient

if [ "true" == ${ALREADYINVOKED:-false} ]
then
echo "RECURSION: Detected, stopping"
else
export ALREADYINVOKED="true"

# make sure the output directory exists
echo "Creating Universal Build Output folder"
#mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
mkdir -p ".${UNIVERSAL_OUTPUTFOLDER}"

echo "Building for iPhoneSimulator"
xcodebuild -workspace "${WORKSPACE_PATH}" -scheme "${SCHEME_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build TEST_AFTER_BUILD=YES GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES ENABLE_BITCODE=YES OTHER_CFLAGS='-fembed-bitcode' | xcpretty

#echo "Building for iPhone"
xcodebuild -workspace "${WORKSPACE_PATH}" -scheme "${SCHEME_NAME}" -configuration ${CONFIGURATION} -sdk iphoneos9.1 ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build ENABLE_BITCODE=YES OTHER_CFLAGS='-fembed-bitcode' | xcpretty


# Step 1. Copy the framework structure (from iphoneos build) to the universal folder
echo "Copying to output folder"
cp -R ".${BUILD_DIR}/${CONFIGURATION}-iphoneos/" ".${UNIVERSAL_OUTPUTFOLDER}"

echo ".${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${EXECUTABLE_PATH}"
echo ".${BUILD_DIR}/${CONFIGURATION}-iphoneos/${EXECUTABLE_PATH}"

# Step 2. Create universal binary file using lipo and place the combined executable in the copied framework directory
echo "Combining executables"
lipo -create -output ".${UNIVERSAL_OUTPUTFOLDER}/${EXECUTABLE_PATH}" ".${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${EXECUTABLE_PATH}" ".${BUILD_DIR}/${CONFIGURATION}-iphoneos/${EXECUTABLE_PATH}"

# Step 3. Convenience step to copy the framework to the project's directory
#echo "Copying to project dir"
#yes | cp -Rf "${UNIVERSAL_OUTPUTFOLDER}/${FULL_PRODUCT_NAME}" "${ARCHIVE_PRODUCTS_PATH}${INSTALL_PATH}"

fi
