#!/bin/bash

START=$(date +"%s")
PROJECT_PATH="$(PWD)"

# 
# PARAMS TO CHANGE
#

BRANCH='develop'

COMPANY='dobrain'
APP_NAME='dobrain-verified'
BUNDLE='com.dobrain.verified'

LOGS_PATH=$PROJECT_PATH'/Logs'
ANDROID_PATH=$PROJECT_PATH'/Builds/Android'
BUILDS_PATH=$PROJECT_PATH'/Builds'
IOS_PATH=$PROJECT_PATH'/Builds/iOS'
IOS_BUILD_PATH=$PROJECT_PATH'/Builds/iOS/Output/Build/Products/Release-iphoneos'
IOS_DEVELOPMENT=$PROJECT_PATH'/Builds/iOS/build/development'
IOS_RELEASE=$PROJECT_PATH'/Builds/iOS/build/release'
GDRIVE_BUILD_PATH=$HOME/'Google 드라이브/Jenkins Builds/dobrain-verified'
USYM_UPLOAD_AUTH_TOKEN='89f9cba6-fec7-478a-99c0-7880c093d95e'
UNITY='/Applications/Unity/Hub/Editor/2019.4.13f1/Unity.app/Contents/MacOS/Unity'

[ -d $LOGS_PATH ] || /bin/mkdir $LOGS_PATH
[ -d $BUILDS_PATH ] || /bin/mkdir $BUILDS_PATH

[ -d $IOS_PATH ] || /bin/mkdir $IOS_PATH
[ -d $ANDROID_PATH ] || /bin/mkdir $ANDROID_PATH

# [ -d $IOS_BUILD_PATH ] || mkdir $IOS_BUILD_PATH
# [ -d $IOS_DEVELOPMENT ] || mkdir $IOS_DEVELOPMENT
# [ -d "$IOS_RELEASE" ] || mkdir "$IOS_RELEASE"

# function UpdateRepo {
# echo ''
# echo "update branch $BRANCH..." 
# echo ''     
# git fetch > "$LOGS_PATH/git.log" 2>&1
# git reset --hard HEAD >> "$LOGS_PATH/git.log" 2>&1
# git checkout $BRANCH >> "$LOGS_PATH/git.log" 2>&1
# git pull >> "$LOGS_PATH/git.log" 2>&1
# echo ''
# echo "$BRANCH updated" 
# echo ''     
# }

# function ShowElapsedTime {
# echo '' 
# end=$(date +"%s")
# elapsed=$(($end-$START))
# echo "$(($elapsed / 60)) minutes $(($elapsed % 60)) seconds"
# echo '' 
# }

# function AndroidDevelopment {
# echo '' 
# echo '|||||||||||||||||||||||||||||||' 
# echo '|                             |' 
# echo '|     Android development     |' 
# echo '|                             |' 
# echo '|||||||||||||||||||||||||||||||' 
# echo ''
# echo ''
# echo 'build unity and archive APK...' 
# echo '' 
# $UNITY -batchmode -quit -projectPath "$PROJECT_PATH" -executeMethod DoBrain.BuildActions.AndroidDevelopment -buildTarget android -logFile "$LOGS_PATH/android_development.log"
# if [ $? -ne 0 ]; then
# echo ''
# echo 'Operation failed!'
# echo '' 
# exit 1
# fi
# echo ''
# echo 'install devices...'
# echo ''
# adb devices | sed "1 d" | cut -f 1 | xargs -I serial adb -s serial install -r "$ANDROID_PATH/$APP_NAME.apk"
# adb devices | sed "1 d" | cut -f 1 | xargs -I serial adb -s serial shell am start -n $BUNDLE/com.google.firebase.MessagingUnityPlayerActivity
# echo ''
# echo 'build completed' 
# echo ''
# }

# # xcodebuild 에서 발생시 아래 명령어 실행!
# # $ sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
# function iOSDevelopment {
# echo '' 
# echo '|||||||||||||||||||||||||||||||' 
# echo '|                             |' 
# echo '|       iOS development       |' 
# echo '|                             |' 
# echo '|||||||||||||||||||||||||||||||' 
# echo ''
# if [ -d "$IOS_PATH" ]; then
# echo ''
# echo 'clean ios directory...' 
# echo ''
# rm -r $IOS_PATH
# fi
# echo ''
# echo 'build unity...' 
# echo '' 
# $UNITY -batchmode -quit -projectPath "$PROJECT_PATH" -executeMethod DoBrain.BuildActions.iOSDevelopment -buildTarget ios -logFile "$LOGS_PATH/ios_unity_export.log"
# if [ $? -ne 0 ]; then
# echo ''
# echo 'Operation failed!'
# echo '' 
# exit 1
# fi
# echo ''
# echo 'build xcode...' 
# echo '' 
# xcodebuild -workspace "$IOS_PATH/Unity-iPhone.xcworkspace" -scheme "Unity-iPhone" -configuration "Release" -derivedDataPath "$IOS_PATH/Output" -quiet > "$LOGS_PATH/ios_xcode_build.log" 2>&1
# echo ''
# echo 'install device...'
# echo ''
# ios-deploy -L -b "$IOS_BUILD_PATH/verified.app"
# echo ''
# echo 'build completed' 
# echo ''
# }

# function JenkinsBuild {
# echo '' 
# echo '|||||||||||||||||||||||||||||||' 
# echo '|                             |' 
# echo '|     Jenkins build...        |' 
# echo '|                             |' 
# echo '|||||||||||||||||||||||||||||||' 
# echo ''
# echo ''
# echo 'build unity android...' 
# echo ''
# $UNITY -batchmode -quit -projectPath "$PROJECT_PATH" -executeMethod DoBrain.BuildActions.AndroidDevelopment -buildTarget android -logFile "$LOGS_PATH/android_unity_export.log"
# if [ $? -ne 0 ]; then
# echo ''
# echo 'Operation failed!'
# echo '' 
# exit 1
# fi
# echo ''
# echo 'build unity ios...' 
# echo '' 
# $UNITY -batchmode -quit -projectPath "$PROJECT_PATH" -executeMethod DoBrain.BuildActions.iOSDevelopment -buildTarget ios -logFile "$LOGS_PATH/ios_unity_export.log"
# if [ $? -ne 0 ]; then
# echo ''
# echo 'Operation failed!'
# echo '' 
# exit 1
# fi
# echo ''
# echo 'build xcode...' 
# echo '' 
# xcodebuild -workspace "$IOS_PATH/Unity-iPhone.xcworkspace" -scheme "Unity-iPhone" -configuration "Release" -derivedDataPath "$IOS_PATH/Output" -quiet > "$LOGS_PATH/ios_xcode_build.log" 2>&1
# echo ''
# echo 'build number...' 
# echo ''
# CFBundleVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $IOS_PATH/Info.plist)
# VersionCode=`aapt dump badging $ANDROID_PATH/$APP_NAME.apk | grep versionCode | awk '{print $3}' | sed s/versionCode=//g | sed s/\'//g`
# echo ''
# echo 'copy files...' 
# echo ''
# cp "$ANDROID_PATH/$APP_NAME.apk" "$GDRIVE_BUILD_PATH/Android/$(date +"%Y_%m%d_%I%M")_$VersionCode.apk"
# cp -r "$IOS_BUILD_PATH/verified.app" "$GDRIVE_BUILD_PATH/iOS/$(date +"%Y_%m%d_%I%M")_$CFBundleVersion.app"
# echo ''
# echo 'zip xcode project...' 
# echo ''
# zip -r "$GDRIVE_BUILD_PATH/iOS/$(date +"%Y_%m%d_%I%M")_$CFBundleVersion.zip" $IOS_PATH
# echo ''
# echo 'Jenkins build completed' 
# echo ''
# }

# function Tests {
# echo '' 
# echo '|||||||||||||||||||||||||||||||' 
# echo '|                             |' 
# echo '|        Project test         |' 
# echo '|                             |' 
# echo '|||||||||||||||||||||||||||||||' 
# echo ''
# echo ''
# echo 'test unity...' 
# echo '' 
# $UNITY -runTests -batchmode -projectPath "$PROJECT_PATH" -testResults "$LOGS_PATH/test.xml"
# echo ''
# echo 'tests completed' 
# echo ''
# }

# if [ "$1" = "jenkins" ]; then
#     JenkinsBuild
#     exit 0
# fi
# echo '' 
# echo '' 
# echo '' 
# echo '|||||||||||||||||||||||||||||||' 
# echo '|                             |' 
# echo '|       Build pipeline        |' 
# echo '|                             |' 
# echo '|||||||||||||||||||||||||||||||' 
# echo ''
# echo ''
# echo "0 – Update branch $BRANCH"
# echo ''
# echo '1 – Run tests'
# echo ''
# echo '2 – Android development'
# echo '3 – iOS development'
# echo '' 
# echo '4 – iOS & Android development'
# echo '' 
# echo '' 
# read -n 1 -s -r -p 'Select build type, ESC to cancel...' key
# echo ''
# if [ "$key" == $'\e' ]; then
# echo '' 
# echo '' 
# echo 'Operation canceled!'
# echo '' 
# echo '' 
# exit 1
# fi
# clear
# case $key in
# 0)
# UpdateRepo
# ;; 
# 1)
# Tests
# ;; 
# 2)
# AndroidDevelopment
# ;;
# 3)
# iOSDevelopment
# ;;
# 4)
# AndroidDevelopment
# iOSDevelopment
# ;;
# *)
# echo '' 
# echo '' 
# echo 'Unknown operation type!'
# echo '' 
# echo '' 
# exit 1
# ;;
# esac
# ShowElapsedTime
