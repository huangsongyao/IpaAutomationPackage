#!/bin/sh

#  PackageScript.sh
#  IpaAutomationPackage
#
#  Created by huangsongyao on 2017/12/20.
#  Copyright © 2017年 HSY.ipa.Package.script. All rights reserved.

#使用说明:把脚本所转化的exec可执行文件放在要打包的工程的root目录下。
#注意1:打包前，必须先行配置好工程中的证书，否则打包可能会报错。
#注意2:默认的info文件路径为“工程绝对路径/工程名称文件夹/info”，例如demo工程名称为[IpaAutomationPackage]，info文件的默认路径为"/Users/xxx/xxx/IpaAutomationPackage/IpaAutomationPackage/Info.plist"

#获取要打包的工程的root目录的绝对路径
work_path=$(dirname $0)
#当前位置跳到脚本位置
cd ${work_path}
#取到脚本目录
work_path=$(pwd)
#获取工程的root路径
project_path=$work_path

#build文件夹路径
build_path=${project_path}/build

#获取target名称
project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
echo ${project_name}

#移动当前路径至工程root目录下
cd $project_path

#清除可能遗留的缓存
echo '*******************************************************'
echo clean start ...
echo '*******************************************************'

#删除bulid目录
if  [ -d ${build_path} ];then
rm -rf ${build_path}
echo clean build_path success.
fi
#清理工程
xcodebuild clean || exit

#编译工程
xcodebuild  -configuration Release  -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${project_name} \
ONLY_ACTIVE_ARCH=NO \
TARGETED_DEVICE_FAMILY=1 \
DEPLOYMENT_LOCATION=YES CONFIGURATION_BUILD_DIR=${project_path}/build/Release-iphoneos || exit

if [ -d ./ipa-build ];then
rm -rf ipa-build
fi

#获取当前打包时间
build_ipa_time=$(date +%Y%m%d)
echo ${build_ipa_time}

#获取本地工程中的info文件的绝对路径，如果本地工程配置的绝对路径不是以下的默认路径，请自行修改为正确的绝对路径
project_info_path=${project_path}/${project_name}/Info.plist

#取版本号
build_version=$(/usr/libexec/PlistBuddy -c "print :CFBundleShortVersionString" ${project_info_path})

#命名ipa的包,格式为:工程名称_版本号_打包时间
ipa_name="${project_name}_${build_version}_${build_ipa_time}"
echo ${ipa_name}

#打包
cd $build_path
mkdir -p ipa-build/Payload
cp -r ./Release-iphoneos/*.app ./ipa-build/Payload/
cd ipa-build
zip -r ${ipa_name}.ipa *

#ipa打包结束
echo '*******************************************************'
echo package ended
echo '*******************************************************'

#打印ipa所在Mac设备中的绝对路径
echo ~/Desktop/${ipa_name}.ipa

#将当前的绝对路径移动到桌面
cd ~/Desktop
#拷贝文件build文件夹中的ipa包至桌面
cp -r ${build_path}/ipa-build/${ipa_name}.ipa  $(pwd)
#清空bulid目录
cd ${build_path}/ipa-build
rm -rf Payload
if  [ -d ${build_path} ];then
rm -rf ${build_path}
fi
