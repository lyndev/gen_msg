# !/usr/bin/python
# -*- coding: utf-8 -*-

# =====================================================================
#
# author    : lyn
# date      : 2017-04-07    
# function  : compare folder file
# name      : folder_files_compare.py
# 
#
# =====================================================================

import md5
import sys
import os
import os.path
import json
import shutil
import zipfile
import copy

def genJs():

def genLua():


# =====================================================================
# 创建一个目录
# =====================================================================
def create_dir(path):
    if not os.path.exists(path):
        os.makedirs(path, 0777)
# =====================================================================
# 获取文件扩展名
# =====================================================================
def file_extension(path): 
  return os.path.splitext(path)[1]

 # =====================================================================
# 读取目录下的所有文件并保存到obj
# =====================================================================
def read_dir_with_proto(dir, obj):
    for parent,dirnames,filenames in os.walk(dir): 
        for filename in filenames:                     
            file_path = os.path.join(parent,filename)
            file_path = file_path.replace("\\", '/')
            file_object = file(file_path,'rb')
            size = os.path.getsize(file_path)
            file_byte = file_object.read(size)
            if file_byte:
                _extname = file_extension(file_path)
                if _extname == '.proto':
                    obj[file_path]['content'] = file_byte 
    return obj