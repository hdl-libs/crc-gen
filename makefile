# GCC 目录
CC := gcc
CXX := g++

# 自动搜索目录
VPATH := src:example:build

# 目标文件目录
OBJ_PATH := ./build/

# 目标文件
TARGET_FILE := crc-gen.exe

# G++编译参数
CXXFLAGS :=

# GCC编译参数
CFLAGS :=
CFLAGS += -DULOG_ENABLED
# CFLAGS += -Wall
# CFLAGS += -g

# 链接参数
LDPFLAGS :=

# 头文件目录
INCLUDE_PATH := -I ./ \
				-I ./src \
				-I ./example

# 库文件目录
LIB_PATH := -L ./ \
			-L ./lib/

# 源文件
SRC_FILES :=
SRC_FILES += ./src/crc-gen.cpp

OBJ_FILES :=  $(notdir $(SRC_FILES:.cpp=.obj))
OBJ_FILES :=  $(notdir $(OBJ_FILES:.c=.obj))

all:$(TARGET_FILE)

$(TARGET_FILE):${OBJ_FILES}
	$(CC) $(CFLAGS) ${INCLUDE_PATH} $(LDPFLAGS) -o $(addprefix $(OBJ_PATH),$@) $(addprefix $(OBJ_PATH),$^)

$(OBJ_FILES):%.obj:%.cpp
	$(CC) $(CFLAGS) ${INCLUDE_PATH} $(LDPFLAGS) -c -o $(addprefix $(OBJ_PATH),$@) $<

clean:
	$(RM) $(OBJ_PATH)/*

.PHONY: all clean
