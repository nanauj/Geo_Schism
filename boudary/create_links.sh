#!/bin/bash

# 원본 데이터 디렉토리 설정
hycom_TS_dir="/data/dwhwang/Data/HYCOM/2023/TS"
hycom_SSH_dir="/data/dwhwang/Data/HYCOM/2023/SSH"
hycom_UV_dir="/data/dwhwang/Data/HYCOM/2023/UV"

# 심볼릭 링크를 생성할 디렉토리 설정
link_dir="/home/schism/Ukjae/bc/rawdata"

# 심볼릭 링크를 생성할 디렉토리가 존재하지 않으면 생성
mkdir -p "$link_dir"

# 파일들을 처리하는 함수 정의
create_links() {
    local src_dir=$1    # 원본 데이터 디렉토리
    local prefix=$2     # 파일 이름 접두사 (TS, SSH, UV)
    local count=1       # 링크 파일 번호
    local prev_date=""  # 이전 파일의 날짜
    local prev_time=""  # 이전 파일의 시간
    
    for file in "$src_dir/${prefix}"_*.nc; do  # 디렉토리 내의 모든 ${prefix}_*.nc 파일에 대해 반복
    
        if [[ $file =~ ^$src_dir/${prefix}_([0-9]{8})_([0-9]{2}).nc$ ]]; then  # $file 변수에 저장된 파일 이름이 "${prefix}_8자리 숫자_2자리 숫자.nc" 형식과 일치하는지 검사
            # 파일 이름에서 날짜와 시간 추출
            date_part="${BASH_REMATCH[1]}"
            time_part="${BASH_REMATCH[2]}"

            # 날짜와 시간을 비교하여 에러 체크
            if [[ -n "$prev_date" && ( "$date_part" < "$prev_date" || ( "$date_part" == "$prev_date" && "$time_part" < "$prev_time" ) ) ]]; then
                echo "Error: $file 의 날짜와 시간이 이전 파일보다 빠릅니다."
                exit 1
            fi

            # ${prefix}_*.nc 형식으로 심볼릭 링크 생성
            link_name="${prefix}_${count}.nc"

            # 링크 생성
            ln -sf "$file" "$link_dir/$link_name"

            # 생성된 링크 파일 확인 출력
            echo "Link created: $link_name -> $link_dir/$(basename "$file")"

            # 이전 날짜와 시간 업데이트
            prev_date="$date_part"
            prev_time="$time_part"

            # 카운트 증가
            ((count++))
        fi
    done
}

# TS, SSH, UV 디렉토리에 대해 링크 생성 함수 호출
create_links "$hycom_TS_dir" "TS"
create_links "$hycom_SSH_dir" "SSH"
create_links "$hycom_UV_dir" "UV"

echo "심볼릭 링크 생성이 완료되었습니다."
