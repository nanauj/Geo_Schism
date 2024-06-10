import os
import numpy as np

# 파일 경로 및 이름 설정
fpath = r'D:\DropBox\Dropbox (개인용)\y2024\02_SCHISM\05_grid\03_Jaran'
fnameBid = 'Shellfish_Grid_SMS_V1.bid'
fname2dm = 'Shellfish_Grid_SMS_V1.2dm'
infileBid = os.path.join(fpath, fnameBid)
infile2dm = os.path.join(fpath, fname2dm)

# 노드 정보 추출
node_num = []
x_coord = []
y_coord = []
elev = []

startString = 'ND'

# 2dm 파일 읽기
with open(infile2dm, 'r') as fid_2dm:
    for line in fid_2dm:
        if line.startswith(startString):
            parts = line.split()
            node_num.append(int(parts[1]))
            x_coord.append(float(parts[2]))
            y_coord.append(float(parts[3]))
            elev.append(float(parts[4]))

# 배열로 변환
node_num = np.array(node_num)
x_coord = np.array(x_coord)
y_coord = np.array(y_coord)
elev = np.array(elev)

# 숫자만 있는 줄을 저장할 리스트 초기화
numeric_lines = []

# bid 파일 읽기
with open(infileBid, 'rb') as fid_Bid:
    for line in fid_Bid:
        line = line.decode('utf-8').strip()
        if line:
            elements = line.split()
            if all(elem.replace('.', '', 1).isdigit() for elem in elements):
                numeric_lines.append([float(elem) for elem in elements])

# 배열로 변환
numeric_lines = np.array(numeric_lines)

# bp 파일 쓰기
fnamebp = 'transect.bp'
outfile = os.path.join(fpath, fnamebp)

with open(outfile, 'w+') as fid_out:
    fid_out.write(f'    {len(numeric_lines)}\n')
    for num_line in numeric_lines:
        node_id = num_line[0]
        idx = np.where(node_num == node_id)[0]
        if idx.size > 0:
            idx = idx[0]
            fid_out.write(f'{int(node_id):06d}      {x_coord[idx]:6.1f}      {y_coord[idx]:6.1f}      {elev[idx]:4.4f}\n')
        else:
            print(f'Warning: Node number {int(node_id)} not found in node_num array.')
