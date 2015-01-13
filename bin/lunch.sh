#! /bin/bash

## 全局变量

# 1. 需要配置部分--begin
APP_NAME=spp
APP_PATH=.
APP_ARGS="--cs2 sample/demo/hulu/start.js"
#APP_ARGS="--cs2 --debug --verbose sample/demo/hulu/start.js"

# 动态库寻找路径配置，动态库寻找目前靠CS->靠系统解决,插件寻找过程是用代码解决的。
export LD_LIBRARY_PATH=$spp_dep_libs/release/lib:$spp_dep_libs/V8:$spp_dep_libs/boost_V1.49.0/stage/lib

# 1. 需要配置部分--end

# 程序动态库依赖关系列表

## 全局函数

# 暂停函数
function pause()
{
        read -n 1 -p "$*" INP
        if [[ $INP != '' ]] ; then
                echo -ne '\b \n'
        fi
}
 


# 3. 启动前确认信息
echo 程序名称为：$APP_NAME
echo -n 程序路径为：&& cd "$APP_PATH" && pwd
echo 启动参数： $APP_ARGS
#echo 动态链接库的寻找路径为：$LD_LIBRARY_PATH
#echo 程序的运行时动态链接库依赖情况如下：&& ldd ${APP_PATH}/${APP_NAME}
echo 程序的版本是: && ${APP_PATH}/${APP_NAME} --version
# 3. 启动
${APP_PATH}/${APP_NAME} $APP_ARGS

# 4. 为了在错误的情况下输出错误信息
echo
pause '		Press any key to continue...'
