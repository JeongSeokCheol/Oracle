2021-1130-04)반복문과 커서
1. 반복문 -- 주로 CURSOR문에 많이 쓰인다.
 - 프로그래밍언어의 반복문의 역활과 동일
 - LOOP, WHILE, FOR 문 제공
 1)LOOP 문
  . 무한루프를 제공
  . 반복문의 기본 구조 제공
  (사용형식)
   LOOP
       반복명령문(들);
      [EXIT WHEN 조건;]
   END LOOP;
   - 'EXIT WHEN 조건' : 조건이 참인 경우 반복을 벗어남

사용예)구구단의 7단을 출력하시오.
      DECLARE
        V_CNT NUMBER:=1;
        V_SUM NUMBER:=0;
      BEGIN
        LOOP
            V_SUM:=7*V_CNT;
            EXIT WHEN V_CNT>9;
            DBMS_OUTPUT.PUT_LINE(7||'*'||V_CNT||'='||V_SUM);
            V_CNT:=V_CNT+1;
        END LOOP;
      END;
      
사용예)첫날에 100원, 둘째날 부터 전날의 2배씩 저축할 경우 100만원을 넘는날은
      몇일째 이며 그때까지 저축한 총 금액은?
      DECLARE
        V_CNT NUMBER:=100;
        V_SUM NUMBER:=0;
        V_DATE NUMBER:=1;
      BEGIN
        LOOP
         V_SUM:=V_SUM+V_CNT;
         EXIT WHEN V_SUM>1000000;
         DBMS_OUTPUT.PUT_LINE(V_DATE||'째 날'||' 저축할 돈: '||V_CNT||' 저축액 : '||V_SUM);
         V_DATE:=V_DATE+1;
         V_CNT:=V_CNT*2;     
        END LOOP;
      END;
      
 2)WHILE 문
  . 조건판단 후 반복 수행
  . 반복횟수가 중요하지 않거나 횟수를 알지 못할때
  . 반복을 벗어나는 탈출조건은 알고 있을때
  (사용형식)
   WHILE 조건 LOOP
      반복처리문(들);
      
   END LOOP;
   - '조건'이 참이면 반복수행, 거짓이면 반복을 종료함

위예제들을 WHILE 문으로 변경하시오.

    DECLARE
        V_CNT NUMBER:=1;
        V_SUM NUMBER:=0;
    BEGIN
        WHILE V_CNT<=9 LOOP
            V_SUM:=V_CNT*7;
            DBMS_OUTPUT.PUT_LINE('7*'||V_CNT||'='||V_SUM);
            V_CNT:=V_CNT+1;
        END LOOP;
    
    END;
    
    DECLARE
        V_CNT NUMBER:=100;
        V_SUM NUMBER:=0;
        V_DATE NUMBER:=0;
      BEGIN
        WHILE V_SUM<1000000 LOOP
         V_SUM:=V_SUM+V_CNT;
         V_DATE:=V_DATE+1;
         V_CNT:=V_CNT*2;     
        END LOOP;
         DBMS_OUTPUT.PUT_LINE('날수 ='||V_DATE);
         DBMS_OUTPUT.PUT_LINE('저축액 ='||V_SUM);
      END;
      
 3)FOR 문
  .반복횟수가 중요하거나 반복횟수를 정확히 알고 있는 경우
  (일반적 FOR문의 사용형식)
   FOR 인덱스 IN [REVERSE] 초기값..최종값 LOOP
    반복처리명령문(들);
   END LOOP;
   
   . 인덱스 : 초기값 부터 최종값을 보관할 기억공간으로 시스템에서 확보해줌
   . 초기값..최종값 : 초기값부터 최종값 까지 1씩 증가  --..으로 찍어야함
   . REVERSE : 역순(최종값..초기값)으로 루프를 수행
   
사용예)구구단의 7단
      DECLARE
        V_SUM NUMBER:=0;
      BEGIN
        FOR I IN 1..9 LOOP
            V_SUM:=7*I;
            DBMS_OUTPUT.PUT_LINE('7*'||I||'='||V_SUM);
        END LOOP;
      END;
      
  (커서용 FOR문의 사용형식)
   FOR 레코드 IN 커서이름|커서용 SELECT문 LOOP
      처리명령문(들);
   END LOOP;   
   . 커서컬럼 참조는 '레코드.커서컬럼명' 