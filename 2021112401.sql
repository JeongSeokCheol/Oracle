2021-11-24)조인 cont...

사용예) 장바구니테이블을 이룔하여 2005년 4-6월 월별,회원별 구매집계를 조회하시오.
       Alias는 월,회원번호,회원명,구매수량합계,구매금액합계
       SELECT SUBSTR(A.CART_NO,5,2)||'월' AS 월,
              B.MEM_ID AS 회원번호,
              B.MEM_NAME AS 회원명,
              SUM(A.CART_QTY) AS 구매수량합계,
              SUM(A.CART_QTY * C.PROD_COST) AS 구매금액합계
         FROM CART A, MEMBER B, PROD C
        WHERE SUBSTR(A.CART_NO,1,6) BETWEEN '200504' AND '200506' 
          AND A.CART_MEMBER=B.MEM_ID
          AND A.CART_PROD=C.PROD_ID
        GROUP BY SUBSTR(A.CART_NO,5,2),B.MEM_ID,B.MEM_NAME
        ORDER BY 1;
 
        (ANSI JOIN)       
        SELECT SUBSTR(A.CART_NO,5,2)||'월' AS 월,
              B.MEM_ID AS 회원번호,
              B.MEM_NAME AS 회원명,
              SUM(A.CART_QTY) AS 구매수량합계,
              SUM(A.CART_QTY * C.PROD_COST) AS 구매금액합계
         FROM CART A
        INNER JOIN MEMBER B ON ( A.CART_MEMBER=B.MEM_ID AND SUBSTR(A.CART_NO,1,6) BETWEEN '200504' AND '200506' )
        INNER JOIN PROD C ON A.CART_PROD=C.PROD_ID       
        GROUP BY SUBSTR(A.CART_NO,5,2),B.MEM_ID,B.MEM_NAME
        ORDER BY 1;
       
사용예) 장바구니테이블을 이룔하여 2005년 4-6월 분류별 판매집계를 조회하시오.
       Alias는 분류코드,분류명,판매수량합계,판매금액합계
       SELECT C.LPROD_GU AS 분류코드,
              C.LPROD_NM AS 분류명,
              SUM(A.CART_QTY) AS 판매수량합계,
              SUM(A.CART_QTY*B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B, LPROD C
        WHERE SUBSTR(A.CART_NO,1,6) BETWEEN '200504' AND '200506'
          AND A.CART_PROD=B.PROD_ID
          AND B.PROD_LGU=C.LPROD_GU
        GROUP BY C.LPROD_GU, C.LPROD_NM
        ORDER BY 1;

       (ANSI JOIN)        
       SELECT C.LPROD_GU AS 분류코드,
              C.LPROD_NM AS 분류명,
              SUM(A.CART_QTY) AS 판매수량합계,
              SUM(A.CART_QTY*B.PROD_PRICE) AS 판매금액합계
         FROM CART A
        INNER JOIN PROD B ON (A.CART_PROD=B.PROD_ID AND SUBSTR(A.CART_NO,1,6) BETWEEN '200504' AND '200506')
        INNER JOIN LPROD C ON B.PROD_LGU=C.LPROD_GU
        GROUP BY C.LPROD_GU, C.LPROD_NM
        ORDER BY 1;
         
       
사용예) 사원테이블에서 미국 이외의 국가에서 근무하는 사원정보를 조회하시오.
       Alias 는 사원번호,사원명,부서코드,부서명,국가
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명,
              C.STREET_ADDRESS||', '||C.CITY||' '||C.STATE_PROVINCE AS 주소,
              D.COUNTRY_NAME AS 국가명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B ,HR.LOCATIONS C,HR.COUNTRIES D
        WHERE NOT(C.COUNTRY_ID ='US')
          AND C.COUNTRY_ID=D.COUNTRY_ID
          AND C.LOCATION_ID=B.LOCATION_ID
          AND B.DEPARTMENT_ID=A.DEPARTMENT_ID
        ORDER BY 3;
        
       (ANSI JOIN)
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명,
               C.STREET_ADDRESS||', '||C.CITY||' '||C.STATE_PROVINCE AS 주소,
              D.COUNTRY_NAME AS 국가명
         FROM HR.EMPLOYEES A
         INNER JOIN HR.DEPARTMENTS B ON B.DEPARTMENT_ID=A.DEPARTMENT_ID
         INNER JOIN HR.LOCATIONS C ON (C.LOCATION_ID=B.LOCATION_ID AND NOT(C.COUNTRY_ID ='US') )
         INNER JOIN HR.COUNTRIES D ON  C.COUNTRY_ID=D.COUNTRY_ID
       
        ORDER BY 3;
        