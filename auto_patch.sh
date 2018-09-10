#opyright (C) 2018 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


function auto_patch()
{
    local patch_dir=$1
    echo -e "patch_dir $patch_dir\n"

    for file in $patch_dir/*
    do
        if [ -f "$file" ] && [ "${file##*.}" == "patch" ]
        then
            local file_name=${file%.*};           #echo file_name $file_name
            local resFile=`basename $file_name`;  #echo resFile $resFile
            local dir_name1=${resFile//#/\/};     #echo dir_name $dir_name
            local dir_name=${dir_name1%/*};       #echo dir_name $dir_name
            local dir=$T/$dir_name;               #echo $dir
            local change_id=`grep 'Change-Id' $file | cut -f 2 -d " "`
            if [ -d "$dir" ]
            then
                cd $dir; git log | grep $change_id 1>/dev/null 2>&1;
                if [ $? -ne 0 ]; then
                    echo -e "patch $file\n"
                    cd $dir; git am $file;
                    if [ $? != 0 ]
                    then
                        return 1
                    fi
                else
                    echo $file" has patched"
                fi
            fi
        fi
    done
}

function traverse_patch_dir()
{
    T=$(pwd)
    local local_dir=$T/vendor/amlogic/tools/auto_patch/
    echo $local_dir
    for file in `ls $local_dir`
    do
        if [ -d $local_dir$file ]
        then
            local dest_dir=$local_dir$file
            auto_patch $dest_dir
        fi
    done
    cd $T
}

traverse_patch_dir

if [ $? != 0 ]
then
    echo "patch error"
    return 1
fi
