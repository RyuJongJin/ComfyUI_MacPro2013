#!/bin/bash

VENV_PATH="./venv"
SCRIPT_NAME="main.py"
LOG_FILE="output.log"
function timeout() {
    perl -e 'alarm shift; exec "@ARGV"' "$@"
}

function install_macpro2013 {
#brew install python@3.12
#brew install git 
#cd ComfyUI
#git clone https://github.com/RyuJongJin/ComfyUI_MacPro2013.git .
mkdir -p custom_nodes
python3.12 -m venv venv
source venv/bin/activate
pip install -r ./req.txt
python main.py --cpu
}

function start_app {
    # 이미 실행 중인지 확인 (중복 실행 방지)
    if [ -f save_pid.txt ]; then
        echo "이미 실행 중이거나 save_pid.txt 파일이 존재합니다."
        return
    fi

    touch $LOG_FILE
    # 로그를 덮어쓰지 않고 추가하도록 >> 사용 (잘 하셨습니다!)
    nohup $VENV_PATH/bin/python -u $SCRIPT_NAME --cpu >> $LOG_FILE 2>&1 &
    
    echo $! > save_pid.txt
    echo "애플리케이션이 시작되었습니다. (PID: $(cat save_pid.txt))"
    
    # 팁: 시작 직후 로그의 마지막 10줄만 보여주고 메뉴로 복귀
    echo "--- 최근 로그 10줄 ---"
    #perl -e 'alaram 10; exec "tail -f $LOG_FILE"'
    #timeout 10 tail -f $LOG_FILE
    tail -f $LOG_FILe & sleep 10; kill $!
}

function stop_app {
    if [ -f save_pid.txt ]; then
        PID=$(cat save_pid.txt)
        # 프로세스가 실제로 살아있는지 확인 후 종료
        if ps -p $PID > /dev/null; then
            kill $PID
            echo "프로세스 $PID 를 종료했습니다."
        else
            echo "프로세스가 이미 종료된 상태입니다."
        fi
        rm save_pid.txt
    else
        echo "종료할 PID 파일이 없습니다."
    fi
}

function status_app {
    # 프로세스 존재 여부를 명확히 표시
    if [ -f save_pid.txt ]; then
        PID=$(cat save_pid.txt)
        echo "상태: 실행 중 (PID: $PID)"
        ps -f -p $PID | grep -v "UID"
    else
        echo "상태: 중지됨"
    fi
}

function logs_app {
    echo "로그 확인 중... (빠져나가려면 Ctrl+C를 누르세요)"
    # tail -f 실행 (Ctrl+C를 눌러도 스크립트가 안 꺼지게 관리 가능)
    tail -f $LOG_FILE
}

while true
do
    echo "===================================="
    status_app
    echo ""
    echo "========== 관리 메뉴 =========="
    echo "00) install ComfyUI to MacPro2013"
    echo "01) start  02) stop"
    echo "03) status 04) log"
    echo "q)  exit"
    echo "==============================="
    
    read -p "선택: " AA 

    case $AA in
        "00") install_macpro2013 ;;
        "01") start_app ;;
        "02") stop_app ;;
        "03") status_app ;;
        "04") logs_app ;;
        "q")  echo "프로그램을 종료합니다."; exit 0 ;;
        *)    echo "잘못된 입력입니다." ;;
    esac
done


