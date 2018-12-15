#!/bin/sh
SHELLNAME2=`echo $SHELLNAME | sed 's/\.sh//g'`
RUN_DATETIME=`date +%Y%m%d-%H%M%S`
RUN_DATE=`date +%Y%m%d`

SHELLDIR=`dirname ${0}`
SHELLNAME=`basename $0`
BASE_DIR=`cd ${SHELLDIR}; pwd`

# 各種ディレクトリ定義
LOG_DIR=${BASE_DIR}/log
TMP_DIR=${BASE_DIR}/dump
PIC_DIR=${BASE_DIR}/picture
INPUT_DIR=${BASE_DIR}/input
OUTPUT_DIR=${BASE_DIR}/output

#######################################################################
# 関数名：print_msg
# 名称  ：ログファイル出力
# 概要  ：ログファイルへの出力を行う。
# 引数  ：$1=メッセージ
# 戻値  ：0=正常 / 1=処理エラー
#######################################################################
print_msg(){
        echo "`date '+%Y/%m/%d %H:%M:%S'` $1" | tee -a $LOG_FILE
}
