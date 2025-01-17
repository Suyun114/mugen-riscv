#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/07
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of cpio
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    mkdir cpiotest
    echo "Hello" >cpiotest/test1
    find . -depth -print | cpio -o >dir.cpio 2>&1
    CHECK_RESULT $? 0 0 "Failed to execute cpio"
    grep -a "Hello" dir.cpio
    CHECK_RESULT $? 0 0 "Failed to find Hello"
    grep -a "block" dir.cpio
    CHECK_RESULT $? 0 0 "Failed to find block"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf cpiotest dir.cpio
    LOG_INFO "End to restore the test environment."
}

main "$@"
