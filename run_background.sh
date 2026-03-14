#!/bin/bash

# 가상환경 경로 (본인의 venv 경로로 수정)
VENV_PATH="./venv"
# 파이썬 스크립트 파일명
SCRIPT_NAME="main.py"
# 로그 파일명
LOG_FILE="output.log"

# 1. 가상환경 활성화 및 스크립트 실행
# -u 옵션은 파이썬 출력을 버퍼링 없이 즉시 로그 파일에 기록합니다.
# nohup은 로그아웃해도 프로세스가 종료되지 않게 합니다.
# > $LOG_FILE 2>&1 은 표준 출력과 에러를 모두 로그 파일로 보냅니다.
# & 는 백그라운드에서 실행합니다.

echo "가상환경 $VENV_PATH 내에서 $SCRIPT_NAME 실행 중..."

touch $LOG_FILE
nohup $VENV_PATH/bin/python -u $SCRIPT_NAME --cpu >> $LOG_FILE 2>&1 &
sync;sync
sleep 5

# 2. 실행된 프로세스의 PID(Process ID) 저장 (선택 사항)
echo $! > save_pid.txt

echo "$SCRIPT_NAME 이 백그라운드에서 실행되었습니다."
echo "로그 확인: tail -f $LOG_FILE"

