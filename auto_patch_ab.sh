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
    local file=$1/manifest_ab.patch
    #echo "file: $file"

    grep -q 'IBootControl' device/amlogic/$2/manifest.xml
    if [ $? != 0 ]
    then
         cd device/amlogic/$2; patch -p1 -Nls < $file
         if [ $? != 0 ]
         then
             echo 'merge failed'
             return 1
         else
             echo "merge ab update manifest ok"
         fi
    else
        echo "ab update manifest already merged"
    fi
    return 0
}

T=$(pwd)
LOCAL_PATH=$T/$(dirname $0)/
BOARD_DIR=$1

auto_patch $LOCAL_PATH/AB_update $BOARD_DIR

if [ $? != 0 ]
then
    echo "merge error"
    exit 1
fi
