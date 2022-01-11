2021-1118-01)집계함수 cont...
   4)MAX(col),MIN(col)
    - 제시된 'col'컬럼의 값 중 최대(최소)값을 반환
    - 집계함수들은 중첩사용이 금지됨

사용예)사원테이블애서 각 부서별 입사가 가장 빠른 사원과 가장 늦은 사원 정보를 조회하시오
      (서브쿼리: 각 부서별 입사가 가장 빠른 입사일)
      SELECT DEPARTMENT_ID,
             COUNT(*),
             MIN(HIRE_DATE) AS MIDATE,
             MAX(HIRE_DATE) AS MXDATE   --영문으로 별칭을 설정한 이유: 나중에 호출을 위해서
        FROM HR.EMPLOYEES
       GROUP BY DEPARTMENT_ID
       ORDER BY 1;
       
       (메인쿼리:사원 정보를 조회)
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_ID AS 부서코드,
              B.MIDATE AS 입사일
         FROM HR.EMPLOYEES A,
              (SELECT DEPARTMENT_ID,
                      COUNT(*),
                      MIN(HIRE_DATE) AS MIDATE
                    --  MAX(HIRE_DATE) AS MXDATE   --영문으로 별칭을 설정한 이유: 나중에 호출을 위해서
                 FROM HR.EMPLOYEES
                GROUP BY DEPARTMENT_ID) B
        WHERE B.DEPARTMENT_ID=B.DEPARTMENT_ID
          AND B.MIDATE=A.HIRE_DATE
        ORDER BY 3;
               
    
    
사용예)2005년 5월 최대 구매액을 기록한 회원정보를 조회하시오.
      (MAX를 사용하지 않은 경우)
      (회원별 구매액 계산)
      SELECT A.CID AS 회원번호,
             B.MEM_NAME AS 회원명,
             B.MEM_HP AS 전화번호,
             B.MEM_MILEAGE AS 마일리지,
             A.CSUM AS 구매액
        FROM(SELECT A.CART_MEMBER AS CID,
                    SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM 
               FROM CART A, PROD B
              WHERE A.CART_PROD=B.PROD_ID
                AND A.CART_NO LIKE '200505%'
              GROUP BY A.CART_MEMBER
              ORDER BY 2 DESC) A, MEMBER B
       WHERE ROWNUM=1
         AND A.CID=B.MEM_ID;
 
      (MAX를 사용한 경우) 
       SELECT 
         FROM (SELECT MAX(A.CSUM) AS MCSUM,      
                FROM(SELECT A.CART_MEMBER AS CID,
                            SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM 
                       FROM CART A, PROD B
                      WHERE A.CART_PROD=B.PROD_ID
                        AND A.CART_NO LIKE '200505%'
                      GROUP BY A.CART_MEMBER) A)
                      
   5)ROLLUP(col1,[,col2,...])
    - GROUP BY 절에 사용되는 함수
    - 기술된 컬럼을 기준으로(오른쪽 -> 왼쪽) 레벨로 구분하고 각 레벨별 집계를 반환하며
      최종적으로 전체집계까지 반환
      ex)GROUP BY ROLLUP(A,B,C)
          - A,B,C컬럼을 기준으로 집계
          - A,B컬럼을 기준으로 집계
          - A컬럼을 기준으로 집계
          - 전체 집계
    - 기술된 컬럼의 수가 n개일떄 n+1종류의 집계 반환
      
사용예)장바구니테이블을 이용하여 2005년 월별,회원별,제품별 구매집계를 
      조회하시오
      Alias는 월,회원번호,제품코드,판매금액합계
      (ROLLUP 미사용)
      SELECT SUBSTR(A.CART_NO,5,2) AS 월,
             A.CART_MEMBER AS 회원번호,
             A.CART_PROD AS 제품코드,
             SUM(A.CART_QTY*B.PROD_PRICE) AS 판매금액합계
        FROM CART A, PROD B
       WHERE A.CART_NO LIKE '2005%'
         AND A.CART_PROD=B.PROD_ID
       GROUP BY SUBSTR(A.CART_NO,5,2), A.CART_MEMBER, A.CART_PROD
       ORDER BY 1;
       
       (ROLLUP 사용)
       SELECT SUBSTR(A.CART_NO,5,2) AS 월,
             A.CART_MEMBER AS 회원번호,
             A.CART_PROD AS 제품코드,
             SUM(A.CART_QTY*B.PROD_PRICE) AS 판매금액합계
        FROM CART A, PROD B
       WHERE A.CART_NO LIKE '2005%'
         AND A.CART_PROD=B.PROD_ID
       --GROUP BY ROLLUP(SUBSTR(A.CART_NO,5,2), A.CART_MEMBER, A.CART_PROD)
       GROUP BY SUBSTR(A.CART_NO,5,2),ROLLUP( A.CART_MEMBER, A.CART_PROD)  --부분 롤업
       ORDER BY 1;
       
   6)CUBE(col1[,col2,...])
    - GROUP BY 절에 사용되는 함수
    - CUBE는 기술된 컬럼을 가지고 조합 가능한 경우의 수 만큼 집계를 반환
      하여 집계 결과의 종류가 2^(사용된 컬럼의 수)가 됨
    ex)GROUP BY CUBE(A,B,C)=>2^3=8가지 집계 반환
       - 전체집계
       - A컬럼만 기준으로 집계
       - B컬럼만 기준으로 집계
       - C컬럼만 기준으로 집계
       - A와 B컬럼만 기준으로 집계
       - A와 C컬럼만 기준으로 집계
       - C와 B컬럼만 기준으로 집계
       - A,B,C컬럼을 기준으로 집계
       
       (CUBE 사용)
       SELECT SUBSTR(A.CART_NO,5,2) AS 월,
             A.CART_MEMBER AS 회원번호,
             A.CART_PROD AS 제품코드,
             SUM(A.CART_QTY*B.PROD_PRICE) AS 판매금액합계
        FROM CART A, PROD B
       WHERE A.CART_NO LIKE '2005%'
         AND A.CART_PROD=B.PROD_ID
       GROUP BY CUBE(SUBSTR(A.CART_NO,5,2), A.CART_MEMBER, A.CART_PROD)
      -- GROUP BY SUBSTR(A.CART_NO,5,2),ROLLUP( A.CART_MEMBER, A.CART_PROD)  --부분 롤업
       ORDER BY 1;