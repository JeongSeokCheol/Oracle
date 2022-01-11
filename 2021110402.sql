2021-1104-02)
 3)날짜 자료형
  . 날짜(년,월,일,시,분,초)자료를 저장하는 데이터타입으로 DATE,TIMESTAMP형이 제공
  . TIMESTAMP는 10억분의 1초의 시간자료와 시간대(TIME ZONE)정보를 저장
  (1) DATE
    - 기본 날짜형
    - '+', '-' 연산의 대상
    ** SYSDATE : 날짜 함수 중 시스템의 날짜정보를 변화하는 함수
사용예) CREATE TABLE TEMP6(
          COL1 DATE,
          COL2 DATE,
          COL3 DATE);
          
          INSERT INTO TEMP6
            VALUES(SYSDATE,SYSDATE-10,SYSDATE+10);
            
          SELECT * FROM TEMP6;
          
          SELECT TO_CHAR(COL1,'YYYY-MM-DD HH24:MI:SS'),
                 TO_CHAR(COL2,'YYYY-MM-DD HH24:MI:SS'),
                 TO_CHAR(COL3,'YYYY-MM-DD HH24:MI:SS')
                 FROM TEMP6;
          
  (2) TIMESTAMP
    - 정교한 시간정보와 시간대 정보를 반환하는 데이터 타입
    - TIMESTAMP, TIMESTAMP WITH TIME ZONE,
      TIMESTAMP WITH LOCAL TIME ZONE의 3가지형태가 제공
      (사용형식)
        컬럼명  TIMESTAMP |                             --시간대 정보 없이 정교한 시간정보제공
               TIMESTAMP WITH TIME ZONE |              -- 시간대 정보와 정교한 시간정보제공 
               TIMESTAMP WITH LOCAL TIME ZONE |        -- 로컬서버의 시간대 정보와 정교한 시간정보제공(TIMESTAMP와 동일)
               
 사용예) CREATE TABLE TEMP7(
           COL1 TIMESTAMP,
           COL2 TIMESTAMP WITH TIME ZONE,
           COL3 TIMESTAMP WITH LOCAL TIME ZONE);
           
           INSERT INTO TEMP7
             VALUES(SYSDATE,SYSDATE,SYSDATE);
             SELECT * FROM TEMP7;
  4)기타 자료형
   . 이전자료를 저장하기 위한 데이터 타입
   . RAW, BFILE, BLOB 타입 제공
   
   (1)RAW
     - 상대적으로 작은 이진자료 저장
     - 인덱스 처리 가능
     - 최대 2000BYTE WJWKDRKSMD
     - 주로 음성, 사진자료저장
     - 16진수나 2진수 현태로 저장 가능
     - 데이터베이스에서 해석이나 변환가능을 제공하지 않음
      (사용형식)
       컬럼명 RAW(크기) 
 사용예) CREATE TABLE TEMP8(
            COL1 RAW(200));
        INSERT INTO TEMP8 VALUES('10000100');
        INSERT INTO TEMP8 VALUES(HEXTORAW('84'));
        
        SELECT * FROM TEMP8;
        
    (2)BFILE
      - 이진 자료를 저장
      - 원본 자료는 데이터베이스 밖에 저장되고 데이터베이스에는 경로와 파일명만 저장
      - 4GB 까지 저장가능
      (사용형식)
        컬럼명 BFILE
        
      (저장 순서)
        (a) 이진자료 파일(그림 등) 선택
            SAMPLE.jfif
        (b) 해당 이진자료 파일이 저자된 경로명을 갖는 디렉토리객체 생성
            CREATE DIRECTORY 디렉토리명 AS 경로명
            
            CREATE DIRECTORY TEST_DIR AS 'D:\A_TeachingMaterial\2.Oracle';
        (c) '(a)'의 자료저장
            INSERT INTO TEMP9
              VALUES(BFILENAME('TEST_DIR','SAMPLE.jfif'));
              
              SELECT * FROM TEMP9;
    사용예)
        CREATE TABLE TEMP9(
            COL1 BFILE);
            
        CREATE DIRECTORY TEST_DIR AS 'D:\A_TeachingMaterial\2.Oracle'; 
        
        INSERT INTO TEMP9
              VALUES(BFILENAME('TEST_DIR','SAMPLE.jfif'));
              
              SELECT * FROM TEMP9;
    
    (3)BLOB(Binary LARGE OBjects)
      - 이진자료를 저장
      - 최대 4GB까지 저장 가능
      - 이진자료를 데이터베이스 내부에 저장
      (사용형식)
        컬럼명 BLOB;
        
      (저장 순서)
        (a)테이블 생성
            CREATE TABLE TEMP10(
                COL1 BLOB);
                
        (b)디렉토리객체 생성 및 원본파일 준비
            TEST_DIR, SAMPLE.jfif
            
        (C)PL/SQL의 블록 구조를활용하여 자료 저장
            --익명블록
          DECLARE
          L_DIR VARCHAR2(30):= 'TEST_DIR';
          L_FILE VARCHAR2(30):= 'SAMPLE.jfif';
          L_BFILE BFILE;
          L_BLOB BLOB;
          
          BEGIN
          INSERT INTO TEMP10(COL1) VALUES(EMPTY_BLOB()) --컬럼을 저장할 공간을 초기화
          RETURN COL1 INTO L_BLOB;   
          
          L_BFILE:=BFILENAME(L_DIR,L_FILE);
          DBMS_LOB.FILEOPEN(L_BFILE,DBMS_LOB.FILE_READONLY);
          DBMS_LOB.LOADFROMFILE(L_BLOB,L_BFILE,DBMS_LOB.GETLENGTH(L_BFILE));
          DBMS_LOB.FILECLOSE(L_BFILE);
          COMMIT;
          END;
       
         SELECT * FROM TEMP10;
    
            
  