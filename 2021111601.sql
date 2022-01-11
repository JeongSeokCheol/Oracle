2021-1116-01)
4.변환함수
 - 오라클에서 사용하는 데이터의 형변환을 담당
 - CAST, TO_CHAR, TO_DATE, TO_NUMBER 함수 제공
 
   1)CAST(expr AS 타입명)
    . 'expr'로 제시된 데이터나 컬럼 값이 '타입명'으로  형이 변환됨
    
사용예)SELECT 1234,CAST(1234 AS VARCHAR2(10)) AS "COL1",
             CAST(1234 AS CHAR(10)) AS "COL2"
        FROM DUAL;
사용예)2005년 7월 일자별 판매현황을 조회하시오.
      Alias는 일자,판매수량합계,판매금액합계
     SELECT CAST(SUBSTR(A.CART_NO,1,8)AS DATE) AS 일자,
            SUM(A.CART_QTY) AS 판매수량합계,
            SUM(A.CART_QTY*B.PROD_PRICE) AS 판매금액합계
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '200507%'
    GROUP BY SUBSTR(A.CART_NO,1,8)
    ORDER BY 1;

   2)TO_CHAR(expr[,'fnt'])
    . 숫자, 날짜, 문자열 타입을 문자열타입으로 변환
    . 'expr'이 문자열인 경우 CHAR,CLOB타입을 VARCHAR2로변화만 가능
    . 'fnt' : 변환하려는 형식지정문자열로 날짜와 숫자형으로 분리
    . 날짜형 FORMAT STRING
    ---------------------------------------------------------------------------------------------------------------------------
    형식지정문자열     의미          사용예
    ---------------------------------------------------------------------------------------------------------------------------
    AD, BC           서기          SELECT TO_CHAR(SYSDATE, 'BC') FROM DUAL;
    CC               세기          SELECT TO_CHAR(SYSDATE, 'BC CC') FROM DUAL;
    YYYY,YYY,YY      년도          SELECT TO_CHAR(SYSDATE, 'CC YYYY') FROM DUAL;
    MONTH,MON,MM,RM  월            SELECT TO_CHAR(SYSDATE, 'YYMMDD MONTH MON') FROM DUAL; 
    DD,DDD,J         일            SELECT TO_CHAR(SYSDATE, 'YYMMDD DDD D') FROM DUAL;
    DAY,DY,D         요일          SELECT TO_CHAR(SYSDATE, 'YYMMDD DAY DY J') FROM DUAL;
    Q                분기          SELECT TO_CHAR(SYSDATE, 'YYMMDD Q') FROM DUAL;
    AM,PM,A.M.,F.M.  오전/오후     SELECT TO_CHAR(SYSDATE, 'YYMMDD AM FM A.M. F.M.') FROM DUAL;
    HH,HH24,HH12     시           SELECT TO_CHAR(SYSDATE, 'YYMMDD HH HH24 HH12') FROM DUAL;
    MI               분           SELECT TO_CHAR(SYSDATE, 'YYMMDD HH24 : MI : SS') FROM DUAL;
    SS,SSSSS         초           SELECT TO_CHAR(SYSDATE, 'YYMMDD HH24 : MI : SS SSSSS') FROM DUAL;
    "사용자지정"                   SELECT TO_CHAR(SYSDATE, 'YY"년" MM"월" DD"일" HH24 : MI :SS') FROM DUAL;
    ---------------------------------------------------------------------------------------------------------------------------
    . 숫자형 FORMAT STRING
    ---------------------------------------------------------------------------------------------------------------------------
    형식지정문자열     의미                   사용예
    ---------------------------------------------------------------------------------------------------------------------------
       9            무효의 0을 공백          SELECT TO_CHAR(1234, '99,999') FROM DUAL;
       0            무효의 0을 '0'출력       SELECT TO_CHAR(1234, '00,000') FROM DUAL;
      $,L           숫자 왼쪽에 화폐기호      SELECT TO_CHAR(1234, '$99,999'),
                                                   TO_CHAR(1234, 'L99,999')FROM DUAL;
       MI           음수인 경우 우측에'-'     SELECT TO_CHAR(-1234, '99,999MI'),
                                                   TO_CHAR(1234, '99,999MI' ) FROM DUAL;        
                    부호로 출력
       PR           음수를 '<>'안에 표현     SELECT TO_CHAR(-1234, '99,999PR') FROM DUAL;
    ,(COMMA)        3자리마다의 자리점
    .(DOT)          소숫점
   ----------------------------------------------------------------------------------------------------------------------------

   3)TO_NUMBER(expr[,'fnt'])
   . 'expr'(문자열 자료)을 숫자형 자료로 변환
   . 'expr'은 반드시 숫자로 변환 가능해야함
   . 'fnt'는 TO_CHAR의숫자 형식 지정문자열과 동일 하나 숫자로 취급될 수 있는
     문자열만 가능('9', '.'등)
사용예) SELECT TO_NUMBER(MEM_BIR)
         FROM MEMBER;
         
       SELECT TO_NUMBER('12,345', '99999.9'),
              TO_NUMBER('<12,345>', '99999.0PR'),
              TO_NUMBER('￦12,345', 'L00000.9')
       FROM DUAL; 
    
   4)TO_DATE(expr[,'fnt'])
    . 사용되는 'fnt'는 TO_CHAR변환함수에 사용하는 형식지정문자열이 사용되나 날짜로 변환될 수
      있는 문자열 이어야함
    . 문자열자료('expr')을 날짜로 변환
    
사용예)SELECT TO_DATE('20210228'),
             TO_DATE('20210220161759','YYYYMMDDHH24MISS')
        FROM DUAL;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        