2021-11-30-02)PL/SQL
 - procedural Language SQL
 - 표준 SQL이 절차적언언어의 요소(변수,반복문,분기문 등)가 제공되지 않아
   사용이 제한적이었음
 - 서버에 실행가능한 형태로 저장되어 실행(내부 네트워크의 효율적 사용)
 - 모듈화, 캡슐화 기능 제공
 - 표준문법이 없고 각 DBMS에 종속적임
 - 익명블록(Anonymous block), Stored Procedure, User defined
   Function, Package, Trigger 등 제공
   
 1.익명블록(Anonymous Block)
  - PL/SQL의 기본 구조 제공
  - 저장할수 없음
  (표현형식)
    DECLARE
      선언부; -- 변수,상수,커서(SELECT문에 도출된 결과의 집합) 선언
    BEGIN
      실행부; -- 처리할 명령을 절차적으로 기술
             -- SQL문, 반복문, 분기문 등

      [EXCEPTION
        예외처리부;] -- 예외발생시 처리할 명령 기술 (필요 없으면 안써도 된다.)
    END;  --블록의 끝을 지정 END뒤에는 세미콜론(;)이 반드시 와야한다.

사용예)키보드로 년도를 입력 받아 윤년과 평년을 구별하는 익명 블록 작성
      윤년:4의 배수 이면서 100의 배수가 아닌 해 또는 400의 배수인 해
      
      ACCEPT P_YEAR PROMPT '년도입력: '
      DECLARE
        V_YEAR NUMBER:=TO_NUMBER('&P_YEAR');
        V_RES VARCHAR2(200);
      BEGIN
        IF (MOD(V_YEAR,4)=0 AND MOD(V_YEAR,100)!=0) 
            OR (MOD(V_YEAR,400)=0) THEN
            V_RES:=V_YEAR||'년은 윤년입니다.';
        ELSE
            V_RES:=V_YEAR||'년은 평년입니다.';
        END IF;
            DBMS_OUTPUT.PUT_LINE(V_RES);
      END;
      
   1)변수, 상수 선언
    (사용형식)
     식별자 [CONSTANT] 데이터타입|참조타입[:=초기값]];
      . '식별자' : 변수명 또는 상수명
      . '데이터타입' : SQL에서 사용하는 모든 데이터타입
       - PLS_INTEGER, BINARY_INTEGER : 4BYTE 정수(2147483647 ~ -2147483647)
       - BOOLEAN 제공됨
      . '참조타입'
       - 컬럼참조 : 테이블명.컬럼명%TYPE : 해당 컬럼과 동일한 데이터타입과 크기로 변수선언
       - 행참조 : 테이블명%ROWTYPE : 해당 행 전체를 참조하여 변수 선어(C언어의 구조체와 같은 타입)
      . 상수선언은 'CONSTANT'사용하며 반드시 초기값을 설정해야 함
 
사용예)회원테이블에서 마일리지를 조회하여 5000이상이면 'VIP회원',
      그 이하이면 '일반회원'을 비고난에 출력하는 익명블록을 작성
      출력할 컬럼은 회원번호,회원명,마일리지,비고
      
      DECLARE
        V_MID MEMBER.MEM_ID%TYPE;
        V_NAME MEMBER.MEM_NAME%TYPE;
        V_MILE MEMBER.MEM_MILEAGE%TYPE;
        V_BIGO VARCHAR2(30);
      BEGIN
        SELECT MEM_ID,MEM_NAME,MEM_MILEAGE 
          INTO V_MID,V_NAME,V_MILE
          FROM MEMBER
         WHERE ROWNUM=1;
        IF V_MILE > 5000 THEN
           V_BIGO:='VIP회원';
        ELSE
           V_BIGO:='일반회원';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('회원번호 : '||V_MID);
        DBMS_OUTPUT.PUT_LINE('회원명 : '||V_NAME);
        DBMS_OUTPUT.PUT_LINE('마일리지 : '||V_MILE);
        DBMS_OUTPUT.PUT_LINE('비고 : '||V_BIGO);
        
      END;
      
    (커서 사용)  
      DECLARE
        V_BIGO VARCHAR2(30);  
        CURSOR CUR_MEMBER IS
          SELECT MEM_ID,MEM_NAME,MEM_MILEAGE
            FROM MEMBER;
      BEGIN
        FOR REC IN CUR_MEMBER LOOP
            IF REC.MEM_MILEAGE > 5000 THEN
               V_BIGO:='VIP회원';
            ELSE
               V_BIGO:='일반회원';
            END IF;
        
               DBMS_OUTPUT.PUT_LINE('회원번호 : '||REC.MEM_ID);
               DBMS_OUTPUT.PUT_LINE('회원명 : '||REC.MEM_NAME);
               DBMS_OUTPUT.PUT_LINE('마일리지 : '||REC.MEM_MILEAGE);
               DBMS_OUTPUT.PUT_LINE('비고 : '||V_BIGO);
               DBMS_OUTPUT.PUT_LINE('==========================================');
        END LOOP;
      END;
       