% 초기 설정: 콘솔 및 변수 초기화, 파일 경로 및 이름 설정
clc; clear; close all

% 파일 경로 및 이름 설정
fpath = 'D:\DropBox\Dropbox (개인용)\y2024\02_SCHISM\05_grid\03_Jaran';
fnameBid = 'Shellfish_Grid_SMS_V1.bid';
fname2dm = 'Shellfish_Grid_SMS_V1.2dm';
infileBid = fullfile(fpath, fnameBid);
infile2dm = fullfile(fpath, fname2dm);


%% node 정보
% 2dm 파일 열기
fid_2dm = fopen(infile2dm, 'r');
if fid_2dm == -1
    error('Can''t open %s\n', infile2dm);
end

% 찾고자 하는 시작 문자열
startString = 'ND';

% 노드 번호 및 좌표 정보를 저장할 배열 초기화
mm = 1; % 인덱스 초기화

% 파일의 모든 줄을 읽으며 특정 문자열로 시작하는 줄 처리
while ~feof(fid_2dm)
    % 한 줄 읽기
    line = fgetl(fid_2dm);
    
    % 특정 문자열로 시작하는지 확인
    if startsWith(line, startString)
        % 줄 양쪽 공백 제거 및 공백으로 분할
        line = strtrim(line);
        line = strsplit(line);
        
        % 노드 번호 및 좌표 추출
        node_num(mm,1) = str2double(line{2});
        x_coord(mm,1)  = str2double(line{3});
        y_coord(mm,1)  = str2double(line{4});
        elev(mm,1)     = str2double(line{5});
        
        % 다음 인덱스를 위해 mm 증가
        mm = mm + 1;
    end
end

% 파일 닫기
fclose(fid_2dm);

%% nodestrig 정보
% bid 파일 열기
fid_Bid = fopen(infileBid, 'rb');
if fid_Bid == -1
    error('Can''t open %s\n',infileBid);
end

% 숫자만 있는 줄을 저장할 배열 초기화
numericLines = [];

% 파일의 모든 줄을 읽으며 처리
while ~feof(fid_Bid)
    % 한 줄 읽기
    line = fgetl(fid_Bid);
    
    % 줄이 비어있지 않은지 확인
    if ischar(line)
        % 공백으로 분할하여 각각의 요소를 확인
        elements = strsplit(strtrim(line));
        
        % 요소가 모두 숫자인지 확인
        isNumericLine = all(cellfun(@(x) ~isnan(str2double(x)), elements));
        
        % 요소가 모두 숫자일 경우 배열에 저장
        if isNumericLine
            numericLines(end+1,1) = str2double(line); 
        end
    end
end

% 파일 닫기
fclose(fid_Bid);


%%
fnamebp = 'transect.bp';
outfile = fullfile(fpath, fnamebp);
fid_out = fopen(outfile, 'w+');

% 첫 번째 줄에 공백 문자열 추가
fprintf(fid_out, '\n');

formatString1 = ['    %4d\n'];
fprintf(fid_out, formatString1, size(numericLines,1));
for ii = 1:size(numericLines,1)

    id = find(numericLines(ii)==node_num);
    formatString2 = ['%06d      %6.1f      %6.1f      %4.4f\n'];
    if ~isempty(id)
        fprintf(fid_out, formatString2, numericLines(ii), x_coord(id), y_coord(id), elev(id));
    else
        warning('Node number %d not found in node_num array.', numeric_lines(ii));
    end

end

% 파일 닫기
fclose(fid_out);






