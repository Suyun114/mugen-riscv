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
# @Date      :   2022/06/27
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of rpmrebuild
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL rpmrebuild
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpmrebuild --comment-missing=y --keep-perm -b -d /tmp/test_$$ curl
    CHECK_RESULT $? 0 0 "Failed to execute rpmrebuild"
    test -f /tmp/test*/${NODE1_FRAME}/curl*
    CHECK_RESULT $? 0 0 "Failed to find curl"
    curr_path=$(
        cd $(dirname $0) || exit 1
        pwd
    )
    cd /tmp/test*/${NODE1_FRAME}/ || exit 1
    rpm2cpio curl-*.rpm | cpio -di
    CHECK_RESULT $? 0 0 "Failed to execute rpm2cpio"
    test -f usr/bin/curl
    CHECK_RESULT $? 0 0 "Failed to  find /usr/bin/curl"
    diff usr/bin/curl /usr/bin/curl
    CHECK_RESULT $? 0 0 "Failed to execute diff"
    ls -l /usr/bin/curl | grep "\\$(ls \-l usr/bin/curl | awk '{print $1}')"
    CHECK_RESULT $? 0 0 "The two files have different permissions"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd $curr_path || exit 1
    rm -rf /tmp/test* /root/rpmbuild
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
