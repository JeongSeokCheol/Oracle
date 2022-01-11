2021-1124-03)조인 cont...

 2.외부조인
  - 자료가 많은 테이블을 기준으로 부족한 테이블에 NULL값의 행을 채우고 조인 수행
  - 조인조건 기술시 부족한 데이터를 보유한 테이블의 컬럼명 뒤에 
    외부조인 연산자'(+)'를 추가함
  - (주의할 점)
    . 외부조린이 필요한 모든 조건식에 외부조인 연산자'(+)' 기술해야 함.
    . 한번에 하나의 테이블만 외부조인될 수 있음. 예를들어 A,B,C 테이블이
      외부조안 될때 A를 기준으로 B가 확장되어 조인되고, 동시에 C를 기준으로
      B가 확장되어 외부조인 될 수 없다. 즉,WHERE A=B(+)  -- 데이터가 적은 테이블쪽에 (+)를 붙힌다.
                                          AND C=B(+) 는 허용되지 않음
    . 일반 외부조인조건과 일반 조건이 동시에 적용되면 내부조인 결과로 변환되며
      이는 서브쿼리나 ANSI 외부조인으로 해경해야 함.
  (ANSI OUTER JOIN)
    SELECT 컬럼list
      FROM 테이블명1 [별칭1] --테이블 n과 테이블 n-1는 직접조인이 가능한 형태여야 한다.
      LEFT|RIGHT|FULL OUTER JOIN 테이블명2 [별칭2]ON(조인조건1 [AND 일반조건1])
                                    :                                      
      LEFT|RIGHT|FULL OUTER JOIN 테이블명n [별칭n]ON(조인조건n [AND 일반조건n])  
    [WHERE 조건]
        :
     - 'LEFT' : FROM 다음에 기술된 '테이블명1'의 자료가 '테이블명2'의 자료보다 더
                많은 경우
     - 'RIGHT' : FROM 다음에 기술된 '테이블명1'의 자료가 '테이블명2'의 자료보다 더
                적은 경우
     - 'FULL' :'테이블명1','테이블명2'의 자료가 서로 부족한 경우
     - 'WHERE 조건' : 조인 연산 후 반영될 조건(조건은 잘 쓰지 않으면 자료가 왜곡된다.)

사용예)모든 분류별 상품의 수를 조회하시오.
      Alias는 분류코드,분류명,상품의 수
      
      SELECT DISTINCT PROD_LGU FROM PROD; 
      
      SELECT A.LPROD_GU AS 분류코드,
             A.LPROD_NM AS 분류명,
             COUNT(PROD_ID) AS "상품의 수"
        FROM LPROD A, PROD B
       WHERE A.LPROD_GU = B.PROD_LGU(+)
       GROUP BY A.LPROD_GU, A.LPROD_NM
       ORDER BY 1;
       
     (*ANSI OUTER JOIN)
      SELECT A.LPROD_GU AS 분류코드,
             A.LPROD_NM AS 분류명,
             COUNT(PROD_ID) AS "상품의 수"
        FROM LPROD A
        LEFT OUTER JOIN PROD B ON(A.LPROD_GU = B.PROD_LGU)
       GROUP BY A.LPROD_GU, A.LPROD_NM
       ORDER BY 1;
       
사용예)모든 부서별 사원수를 조회하시오.
      Alias는 부서코드,부서명,사원수
      
      SELECT DISTINCT DEPARTMENT_ID FROM HR.EMPLOYEES;
      
      SELECT A.DEPARTMENT_ID AS 부서코드,
             A.DEPARTMENT_NAME AS 부서명,
             COUNT(B.EMP_NAME) AS 사원수
        FROM HR.DEPARTMENTS A, HR.EMPLOYEES B
       WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID(+)
       GROUP BY A.DEPARTMENT_ID,A.DEPARTMENT_NAME
       ORDER BY 1;
       
       (*ANSI OUTER JOIN)
       SELECT A.DEPARTMENT_ID AS 부서코드,
             A.DEPARTMENT_NAME AS 부서명,
             COUNT(B.EMP_NAME) AS 사원수
        FROM HR.DEPARTMENTS A
        FULL OUTER JOIN HR.EMPLOYEES B ON(A.DEPARTMENT_ID=B.DEPARTMENT_ID)
       GROUP BY A.DEPARTMENT_ID,A.DEPARTMENT_NAME
       ORDER BY 1;
     
사용예)2005년 6월 모든 상품별 매출집계를 조회하시오.
      Alias는 상품코드,상품명,매출금액합계
      (일반 OUTER JOIN)
      SELECT A.CART_PROD AS 상품코드,
             B.PROD_NAME AS 상품명,
             SUM(A.CART_QTY*B.PROD_PRICE) AS 매출금액합계
        FROM CART A, PROD B
       WHERE A.CART_PROD(+)=B.PROD_ID
         AND A.CART_NO LIKE '200506%'
       GROUP BY A.CART_PROD,B.PROD_NAME, B.PROD_ID
       ORDER BY 1;
       
      SELECT COUNT(*) FROM CART WHERE CART_NO LIKE '200506%'
      
    (*ANSI OUTER JOIN)
     SELECT  B.PROD_ID AS 상품코드,
             B.PROD_NAME AS 상품명,
             NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS 매출금액합계
        FROM CART A
       RIGHT OUTER JOIN PROD B ON (A.CART_PROD=B.PROD_ID
                                   AND A.CART_NO LIKE '200506%')
       GROUP BY B.PROD_ID,B.PROD_NAME
       ORDER BY 1;
       
    (*서브쿼리가 사용된 OUTER JOIN)
      SELECT B.PROD_ID AS 상품코드,
             B.PROD_NAME AS 상품명,
             NVL(A.ASUM,0) AS 매출금액합계
        FROM PROD B ,(SELECT CART_PROD AS CID,
                             SUM(CART_QTY*PROD_PRICE) AS ASUM
                        FROM CART,PROD
                       WHERE CART_PROD=PROD_ID
                         AND CART_NO LIKE '200506%'
                       GROUP BY CART_PROD) A 
       WHERE A.CID(+)=B.PROD_ID
       ORDER BY 1;
       
사용예)2005년 4월 모든 상품별 매입집계를 조회하시오.
      Alias는 상품코드,상품명, 매입금액집계

       SELECT A.PROD_ID AS 상품코드,
             A.PROD_NAME AS 상품명,
             NVL(SUM(B.BUY_QTY*A.PROD_COST),0) AS 매입금액합계
        FROM PROD A
        LEFT OUTER JOIN BUYPROD B ON (A.PROD_ID=B.BUY_PROD AND 
                                      B.BUY_DATE BETWEEN TO_DATE('20050401') AND LAST_DAY(TO_DATE('20050401')))
       GROUP BY A.PROD_ID , A.PROD_NAME
       ORDER BY 1;

사용예)2005년 모든 제품별 매입/매출 현황을 조회하시오.
      Alias는 상품코드,상품명,매입금액합계,매출금액합계

      (*ANSI FORMAT --문제가 있음 매입금액*3이 되어 있음)
      SELECT A.PROD_ID AS 상품코드,
             A.PROD_NAME AS 상품명,
             SUM(B.BUY_QTY*A.PROD_COST) AS 매입금액합계,
             NVL(SUM(C.CART_QTY*A.PROD_PRICE),0) AS 매출금액합계
        FROM PROD A
        LEFT OUTER JOIN BUYPROD B ON ( A.PROD_ID=B.BUY_PROD
                                       AND B.BUY_DATE BETWEEN TO_DATE('20050101') AND LAST_DAY(TO_DATE('20051201')))
        FULL OUTER JOIN CART C ON ( B.BUY_PROD=C.CART_PROD
                                    AND C.CART_NO LIKE '2005%')
       GROUP BY A.PROD_ID, A.PROD_NAME
       ORDER BY 1;