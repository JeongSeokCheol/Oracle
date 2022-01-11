2021-1129-03)
2. SEQUENCE
 - 순차적인 값을 생성하기위한 객체
 - 테이블과 독립적인 값 생성
 - 시퀀스가 사용되는 곳
  . 적당한 기본키를 찾지 못한 경우
  . 자동적으로 증가(감소)되는 값이 필요한 경우(ex)CART_NO의 뒷자리 5글자 등)
  (사용형식)
  CREATE [OR REPLACE] SEQUENCE 시퀀스명 
    [START WITH n] -- 시작값 설정 기본은 MIN_VALUE
    [INCREMENT BY n] -- 증가[감소] 값 기본은 1(음수 사용 가능)
    [MAXVALUE n[NOMAXVALUE] -- 최대값 설정, default NOMAXVALUE 이며 10 ^ 27 
    [MINVALUE n[NOMINVALUE] -- 최소값 설정, default NOMINVALUE 이며 1 이다.
    [CYCLE|NOCYCLE] -- 최대[최소] 값까지 도달한 후 다시 새성여부 설정 default는 NOCYCLE  
    [CACHE n|NOCACHE] -- 메모리에 미리 생성 할지 여부 default는 CACHE 20
    [ORDER|NOORDER] -- 제시된 조건대로 시퀀스 생성보장 여부 default는 NOORDER
    
    **의사컬럼(Pseudo Column)
    ------------------------------------------------------------------------
    의사컬럼               의미
    ------------------------------------------------------------------------
    시퀀스명.nextval       '시퀀스'의 다음 값
    시퀀스명.currval       '시퀀스'의 현재 값
    ------------------------------------------------------------------------
    **** 시퀀스가 생성된 후 적어도 최초의 한번은 nextval가 호출되어야
         해당 시퀀스가 값을 배정 받음
         
사용예)다음자료를 분류테이블에 삽입하시오.
      [자료]
      순번 : 10
      분류코드 : 'P501'
      분류명 : 농산물
      
      순번 : 11
      분류코드 : 'P502'
      분류명 : 농산가공식품

      순번 : 12
      분류코드 : 'P503'
      분류명 : 임산물
      
      **순번은 시퀀스를 사용할 것
      
      (시퀀스 생성)
      CREATE SEQUENCE SEQ_LPROD
       START WITH 10;
       
       SELECT SEQ_LPROD.CURRVAL FROM DUAL;
       
      (자료삽입)
      INSERT INTO LPROD(LPROD_ID,LPROD_GU,LPROD_NM)
       VALUES(SEQ_LPROD.NEXTVAL,'P501','농산물');
       
      SELECT * FROM LPROD;
      
      INSERT INTO LPROD(LPROD_ID,LPROD_GU,LPROD_NM)
       VALUES(SEQ_LPROD.NEXTVAL,'P502','농산가공식품');
       
      INSERT INTO LPROD(LPROD_ID,LPROD_GU,LPROD_NM)
       VALUES(SEQ_LPROD.NEXTVAL,'P503','임산물');
       
사용예)오늘이 2005년 7월 29일이라고 가정하고 CART_NO를 생성하시오.
      5자리 숫자는 시퀀스를 이용 할 것
      CREATE SEQUENCE SEQ_CART_NO
       START WITH 1
       MAXVALUE 99999;

-----------------------------------------------------------------------------------------------      
      ACCEPT P_MID PROMPT '회원번호 : ' 
      DECLARE
       V_DATE VARCAHAR2(9) :=TO_CHAR(SYSDATE,'YYYMMDD')||'9%';
       V_LNUM NUMBER:=0;
       V_CNT VARCHAR2(20);
       V_MID MEMBER.MEM_ID%TYPE;
      BEGIN
        SELECT A.CART_NO,A.CART_MEMBER INTO V_CNT,V_MID
          FROM (SELECT CART_NO,CART_MEMBER
                  FROM CART
                 WHERE CART_NO LIKE V_DATE
                 ORDER BY 1 DESC) A
         WHERE ROWNUM=1;
         IF V_CNT IS NOT NULL OR V_MID != '&PMID' THEN
            V_LNUM:=SEQ_CART_NO.NEXTVAL;
         ELSIF V_CNT IS NOT NULL AND V_MID = '&P_MID' THEN
               V_LNUM:=SEQ_CART_NO.CURRVAL;
        END IF;
        
        DBMS.OUPUT.PUT_LINE('날짜 : '||TO_CHAR(SYSDATE,'YYYYMMDD'));
        DBMS.OUPUT.PUT_LINE('회원번호 : '|| '&P_MID');
        DBMS.OUPUT.PUT_LINE('카트번호 : '||TO_CHAR(SYSDATE,'YYYYMMDD')||
                             
            
         
      END;
      
      SELECT SEQ_CART_NO.nextval FROM DUAL;
      
      SELECT SEQ_CART_NO.currval FROM DUAL;
      
3.동의어(synonym)
 - 오라클 객체에 부여된 별도의 이름
 - 별칭(테이블)과의 차이점은 탐조영역의 차이 (테이블 별칭: 사용되는 sql 내부,
                                         동의어는 모든 곳에서 사용)
 (사용형식)
 CREATE [OR REPLACE] SYNONYM 동의어 FOR 객체명;
  . '객체명' : 원본 객체명
  
사용예)HR계정의 사원테이블(HR.EMPLOYEES)에 동의어 EMP를 설정하시오.
      CREATE OR REPLACE SYNONYM EMP FOR HR.EMPLOYEES;
      
      SELECT * FROM EMP;
      
      DROP SYNONYM EMP; --삭제 DROP시 ROLLBACK을 쓸 수 없다.
      