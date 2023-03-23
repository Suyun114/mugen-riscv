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
# @Date      :   2022/06/09
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of wget
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL wget
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    cp /etc/resolv.conf /etc/resolv.conf.bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo "" >/etc/resolv.conf
    wget www.baidu.com 2>&1 | grep "unable to resolve host address"
    CHECK_RESULT $? 0 0 "Wget executed successfully"
    mv -f /etc/resolv.conf.bak /etc/resolv.conf
    wget www.baidu.com
    CHECK_RESULT $? 0 0 "Failed to execute wget"
    test -f index.html
    CHECK_RESULT $? 0 0 "Failed to check wget"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf index.html
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
