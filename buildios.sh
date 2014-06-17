#!/bin/bash 

set -x

version="0.2.0"


PROJECT_HOME=$PWD
PROJECT_DIRNAME=`basename $PROJECT_HOME`
OUTPUT="$PROJECT_HOME/output"
OUTPUT_BUILD="$OUTPUT/build"
OUTPUT_DIST="$OUTPUT/dist"
XCODEBUILD="/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild"
SDK="iphoneos7.1"

#build target ios
function build_ios()
{
    cd $PROJECT_HOME
	para_device="QiXin"  #iPad, iPhone
	para_target="${para_device}" #iPad, iPhone
    para_configuration=$1 #Debug, Release
    app_base_name="QiXin"
    app_dsym_name="${app_base_name}.app.dSYM"

	$XCODEBUILD -sdk $SDK -target $para_target -configuration $para_configuration SYMROOT=$OUTPUT_BUILD build

    cd "${OUTPUT_BUILD}/${para_configuration}-iphoneos"
    tar zcvf "${OUTPUT_DIST}/${para_configuration}/${app_dsym_name}.tar.gz" "${app_dsym_name}"
    md5 "${OUTPUT_DIST}/${para_configuration}/${app_dsym_name}.tar.gz" > "${OUTPUT_DIST}/${para_configuration}/${app_dsym_name}.tar.gz.md5"
    #mv  "${app_dsym_name}.tar.gz" "${OUTPUT_DIST}/${para_configuration}/${app_dsym_name}.tar.gz" 
    #mv  "${app_dsym_name}.tar.gz.md5" "${OUTPUT_DIST}/${para_configuration}/${app_dsym_name}.tar.gz.md5" 

xcrun -sdk iphoneos PackageApplication -v "${app_base_name}.app" -o "${OUTPUT_DIST}/${para_configuration}/${app_base_name}.ipa" #--sign "iPhone Distribution: Huawei Technologies Co.,Ltd./"
	cd ${OUTPUT_DIST}/${para_configuration}
    md5 "${app_base_name}.ipa" > "${app_base_name}.ipa.md5"
}


function prepare_dir_source()
{
    rm -rf $OUTPUT
    svn update
    svnrevision=`svn info |grep '^Revision:' | sed -e 's/^Revision: //'`
    	
    cd ..
    tar zcvf ${PROJECT_DIRNAME}_r${svnrevision}.tar.gz $PROJECT_DIRNAME
    mkdir $OUTPUT
    mkdir $OUTPUT_BUILD
    mkdir $OUTPUT_DIST
    mkdir "${OUTPUT_DIST}/Release"
    #mkdir "${OUTPUT_DIST}/Release"
	mkdir "${OUTPUT_DIST}/src"

    mv "${PROJECT_DIRNAME}_r${svnrevision}.tar.gz" "${OUTPUT_DIST}/src"

    cd "${OUTPUT_DIST}/src"
    md5 "${PROJECT_DIRNAME}_r${svnrevision}.tar.gz" >"${PROJECT_DIRNAME}_r${svnrevision}.tar.gz.md5"
    cd $PROJECT_HOME


    $XCODEBUILD clean
	#replace version number
	find . -name project.pbxproj |xargs perl -i -pe "s/ v\d\.\d\.\d/ v${version}/g"
}

function main()
{
    prepare_dir_source

    #build iphone debug and release
    build_ios Release 
    #build_ios iPhone  Release 
    #build_ios iPad  Release 
}

main


