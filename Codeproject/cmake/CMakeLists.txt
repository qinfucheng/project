CMAKE_MINIMUM_REQUIRED(VERSION 2.8) #最低版本要求
SET(CMAKE_CXX_COMPILER "g++") #设置g++编译器
PROJECT(Hello) #设置工程名
MESSAGE(STATUS "Project Hello") #打印消息
ADD_EXECUTABLE(hello hello.cpp) #生成可执行文件