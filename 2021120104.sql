2021-1201-04)User Defined Function(함수: Function)
 - 반환 값이 있다.
 - PROCEDURE와 유사한 구조
 (사용형식)
    CREATE OR REPLACE FUNCTION 함수명[(
       매개변수 [IN|OUT|INOUT] 데이터타입[:=기본값1],
                   :
       매개변수 [IN|OUT|INOUT] 데이터타입[:=기본값1])]
       
       RETURN 데이터타입
    IS|AS
      선언부;
    BEGIN
      실핼부;
      RETURN 반환값;
      [EXCEPTION
        예외처리;
       ]
    END;
    . 'RETURN 데이터타입' : 반환할 데이터의 타입
    . 'RETURN 반환값' : 실제 반환 명령으로 반드시 1개 이상 존재 해야함
    
사용예)월과 상품코드를 입력 받아 2005년 해당 월에 판매된 해당상품의 
      판매액을 반환하는 함수작성
      
      CREATE OR REPLACE FUNCTION FN_SALES(
        P_MONTH IN VARCHAR2,
        P_CID IN PROD.PROD_ID%TYPE)
        RETURN NUMBER
      IS
        V_SUM NUMBER:=0; -- 판매액
      BEGIN
        SELECT SUM(A.CART_QTY*B.PROD_PRICE) INTO V_SUM
          FROM CART A, PROD B
         WHERE A.CART_PROD=B.PROD_ID
           AND A.CART_NO LIKE '2005'||P_MONTH||'%'
           AND A.CART_PROD=P_CID;
        RETURN V_SUM;   
        
      END;
      
    (실행)
      SELECT PROD_ID,PROD_NAME,
             NVL(FN_SALES('06',PROD_ID),0)
        FROM PROD;
        
사용예)분류코드를 입력 받아 분류별 평균매입액과 평균매출액을 반환하는
      함수를 작성하시오.
      
      CREATE OR REPLACE FUNCTION FN_AVG(
        P_LGU IN LPROD.LPROD_GU%TYPE)
        
        RETURN NUMBER
      IS  
        V_AVG_BUY NUMBER:=0;
      BEGIN
        -- 평균매입액
        SELECT ROUND(AVG(BUY_QTY*BUY_COST)) INTO V_AVG_BUY 
          FROM BUYPROD ,PROD
         WHERE PROD_LGU=P_LGU
           AND BUY_PROD=PROD_ID;

           
        RETURN V_AVG_BUY;
        
      END;
      
    (실행)
      SELECT LPROD_GU,
               LPROD_NM,
               FN_AVG(LPROD_GU)
        FROM LPROD;
        
        
      CREATE OR REPLACE FUNCTION FN_AVG_SALES(
        P_LGU IN LPROD.LPROD_GU%TYPE)
        
        RETURN NUMBER
      IS  
        V_AVG_SLAE NUMBER:=0;
      BEGIN
        -- 평균매입액
        SELECT ROUND(AVG(CART_QTY*PROD_PRICE)) INTO V_AVG_SALE 
          FROM CART ,PROD
         WHERE PROD_LGU=P_LGU
           AND CART_PROD=PROD_ID;

           
        RETURN V_AVG_SALE;
        
      END;
      
      (실행)
      SELECT LPROD_GU AS 분류코드,
               LPROD_NM AS 분류명,
               FN_AVG(LPROD_GU) AS 평균매입액,
               FN_AVG_SLAES(LPROD_GU) AS 평균매출액
        FROM LPROD;
        
사용예)날짜와 회원번호를 입력받아 장바구니번호를 생성하시오
      CREATE OR REPLACE FUNCTION FN_CREATE_CARTNO(
        P_DATE VARCHAR2,
        P_MID MEMBER.MEM_ID%TYPE)
        RETURN VARCHAR2
      IS
        V_CNT NUMBER:=0; --자료의 수
        V_CARTNO VARCHAR2(13); --임시장바구니번호
        V_MEM_ID MEMBER.MEM_ID%TYPE; --임의의 날짜에 가장큰 장바구니번호를 
                                     --부여받은 회원번호
      BEGIN
        SELECT COUNT(*) INTO V_CNT
          FROM CART
         WHERE CART_NO LIKE P_DATE||'%'; 
        
        IF V_CNT != 0 THEN
           SELECT MAX(CART_NO) INTO V_CARTNO
             FROM CART
            WHERE CART_NO LIKE P_DATE||'%';
            
           SELECT DISTINCT CART_MEMBER INTO V_MEM_ID
             FROM CART
            WHERE CART_NO=V_CARTNO; 
        END IF;
        
        IF V_MEM_ID != P_MID THEN
           V_CARTNO:=V_CARTNO+1;
        END IF;
        
        IF V_CNT=0 THEN
           V_CARTNO:=P_DATE||'00001';
        END IF;   
        RETURN V_CARTNO; 
      END;

 (실행)
      SELECT FN_CREATE_CARTNO('20050501','b001')
        FROM DUAL;
        
      SELECT FN_CREATE_CARTNO('20050501','c001')
        FROM DUAL;  
      
      SELECT FN_CREATE_CARTNO('20050502','c001')
        FROM DUAL; 
        
사용예)부서번호를 입력받아 부서별 인원수를 반환하는 함수를 작성하고
      부서번호,부서명,인원수를 출력하시오.
      함수명 : FN_SUM_EMP
      CREATE OR REPLACE FUNCTION FN_SUM_EMP(
        P_EID IN HR.DEPARTMENTS.DEPARTMENT_ID%TYPE)
        RETURN NUMBER
      IS
        V_CNT NUMBER:=0;
      BEGIN
        SELECT COUNT(DEPARTMENT_ID) INTO V_CNT
          FROM HR.EMPLOYEES
         WHERE DEPARTMENT_ID=P_EID;
         RETURN V_CNT;
        
      END;
      
    SELECT DEPARTMENT_ID,DEPARTMENT_NAME,FN_SUM_EMP(DEPARTMENT_ID)
      FROM DEPARTMENTS;