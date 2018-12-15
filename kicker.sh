#!/bin/sh
#######################################################################
#######################################################################
SHELLDIR=`dirname ${0}`
SHELLNAME=`basename $0`
BASE_DIR=`cd ${SHELLDIR}; pwd`
CONF_DIR=${BASE_DIR}/conf

# load to common.sh
source ${CONF_DIR}/common.sh
S3_INPUT_PATH=s3://${OUTPUT_BUCKET_NAME}/project/hpb/step_mail/${RUN_DATE}/model_used_list
S3_OUTPUT_PATH=s3://${OUTPUT_BUCKET_NAME}/project/hpb/step_mail/${RUN_DATE}/model_output_list
echo $OUTPUT_BUCKET_NAME
echo $S3_INPUT_PATH
echo $S3_OUTPUT_PATH
LOG_FILE="kicker.log"

#######################################################################
# 関数名：get_file_from_s3
# 名称  ：s3からのファイル取り込み
# 概要  ：
# 引数  ：$1=ファイル名 $2=S3Path(設定がなければ、S3_INPUT_PATH）
# 戻値  ：0=正常 / 1=処理エラー
#######################################################################
get_file_from_s3() {
  print_msg "[INFO] JOB_START get_file_from_s3"
  file_name=$1
  if [ $# -lt 1 ]; then
    print_msg "[ERROR] Invalid argument : ${file_name}"
    exit 1
  fi
  if [ $# -ge 2 ]; then
    s3_path=$2
  else
    s3_path=${S3_INPUT_PATH}
  fi
  echo ${s3_path}/${file_name}
  echo ${INPUT_DIR}
  exists_file=`aws s3 ls ${s3_path}/${file_name}  | wc -l`
  if [ ${exists_file} -eq 0 ]; then
    print_msg "[ERROR] Not Exists : ${file_name}"
    exit 1
  fi
  aws s3 cp ${s3_path}/${file_name} ${INPUT_DIR}/
  if [ $? -ne 0 ]; then
    print_msg "[ERROR] Failed to Load : ${file_name}"
    exit 1
  fi
  print_msg "[INFO] JOB_END get_file_from_s3"
}

#######################################################################
# 関数名：send_file_to_s3
# 名称  ：s3へのファイル配置
# 概要  ：環境変数にてS3_BUCKET_NAME, RUN_DATEを設定する
# 引数  ：$1=ファイル名 $2=S3Path(設定がなければ、S3_OUTPUT_PATH）
# 戻値  ：0=正常 / 1=処理エラー
#######################################################################
send_file_to_s3() {
  print_msg "[INFO] JOB_START send_file_to_s3"
  file_name=$1
  if [ $# -lt 1 ]; then
    print_msg "[ERROR] Invalid argument : ${file_name}"
    exit 1
  fi
  if [ $# -ge 2 ]; then
    s3_path=$2
  else
    s3_path=${S3_OUTPUT_PATH}
  fi
  echo ${OUTPUT_DIR}/${file_name}
  echo ${s3_path}/${file_name}
  aws s3 cp ${OUTPUT_DIR}/${file_name} ${s3_path}/${file_name}
  if [ $? -ne 0 ]; then
    print_msg "[ERROR] Failed to send :${file_name}"
    exit 1
  fi
  print_msg "[INFO] JOB_END send_file_to_s3"
}

#######################################################################
run_task(){
  print_msg "[INFO] JOB_START test "
  python test.py
  # dump
  if [ $? -ne 0 ]; then
    print_msg "[ERROR] Cannot test"
    exit 1
  fi
  print_msg "[INFO] JOB_END test"
}

#######################################################################
#メイン処理
#######################################################################

print_msg "[INFO] JOB_START ${SHELLNAME}"
START_TIME=`date '+%s'`
# get exclude file from s3 bucket
#get_file_from_s3 "hpb_step_target_model.tsv"
#get_file_from_s3 "hpb_step_target_random.tsv"
# get parameter file from s3 bucket

# run
run_task

# send output file to s3 bucket
#send_file_to_s3 "hpb_step_point_target_jk.tsv"

# END
END_TIME=`date '+%s'`
print_msg "[INFO] JOB_END ${SHELLNAME}"
print_msg "JOB_TIME: `expr ${END_TIME} - ${START_TIME}` sec."
