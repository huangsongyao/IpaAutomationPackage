
自动打包脚本说明

一、xcode 8.3以后，移除了PackageApplication文件，需要手动添加该文件，步骤如下：
1、把下载好的PackageApplication文件复制到目录：/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ 
2、终端执行指令：sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer/
3、终端执行指令：chmod +x /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/PackageApplication

二、已经编辑好的PackageScript.sh脚本可能需要赋予权限
终端输入：mv PackageScript.sh PackageScript
移除.sh的后缀名称
终端输入：sudo chmod +x PackageScript
把移除后缀后的PackageScript文件转为exec可执行文件

三、把PackageScript可执行的exec文件放在要打包的工程的root目录下，双击PackageScript文件，即可进行打包
