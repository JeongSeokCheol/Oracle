2021-1123-01)테이블 조인
 - 관계형 테이블베이스 연산 중 가장 중요한 연산 중 하나
 - 관계(Relationship: 외래키 관계)를 형성하고 있는 복수개의 테이블에서 필요한 자료를 
   추출하기 위한 연산
 - 내부조인(카타시안조인,동등조인, 비동등조인,셀프조인), 외부조인
 - 일반조인, ANSI조인(CROSS JOIN, NATURAL JOIN, INNER JOIN, OUTER JOIN)
 
  1. 내부조인
   - 조인에 참여하는 테이블들 사이에 조인조건을 만족하지 않는 모든 행을 무시하고 연산
    (사용형식)
    SELECT [테이블명.|테이블별칭.]컬럼명 [AS 별칭][,]
                               :
      FROM 테이블명 [별칭1], 테이블명2 [별칭2][,테이블명3 [별칭3],...]
     WHERE [일반조건]
       AND 조인조건1
      [AND 조인조건2,...]
      
      . 일반조건과 조인조건 기술 순서는 제한없음
      . 사용된 테이블의 갯수가 n개일때 조인조건은 적어도 n-1개 이상 이여야함
      . 조인조건이 잘못 기술되거나 생략되면 카타시안 PRODUCT로 수행됨
      . 조인조건은 사용된 테이블들 공통된 컬럼을 관계연산자를 사용하여 비교
      
      1)Cartesian Product
       - 다수개의 테이블에서 모든 행, 모든 열이 조합됨
       - 행의 조합은 곱이되고 열의 조함은 합이됨
       - 아주 특별한 목적이외에는 사용하지 말아야 함
       - 조인조건이 없거나 조인조건이 잘못 기술된 경우 발생
       - ANSI는 CROSS JOIN으로 구현
       
       ANSI(사용형식)
       SELECT 컬럼list
         FROM 테이블명1
        CROSS JOIN 테이블명2 ON(조인조건)
       [CROSS JOIN 테이블명3 ON(조인조건)]
                    :
       [WHERE 일반조건]
       . 보통 'ON(조인조건)'절은 생략
       
사용예)
      SELECT COUNT(*) FROM CART;
      
      SELECT COUNT(*) FROM PROD;
      
      SELECT COUNT(*)
        FROM CART,PROD;
        
      SELECT COUNT(*) 
        FROM CART,PROD,BUYPROD;
        
      (CROSS JOIN 사용)
      SELECT COUNT(*)
        FROM CART
       CROSS JOIN PROD
       CROSS JOIN BUYPROD;
      
      SELECT 207*74*148 FROM DUAL;
      
     2)동등조인(Eqi-Join)
      - 조인조건에 '='연산자를 사용한 조인
      - 조인조건을 만족하는 자료만을 대상으로 함
      - ANSI조인에서 INNER JOIN 이 이에 해당
      (ANSI INNER JOIN 사용형식)
       SELECT 컬럼list
         FROM 테이블명1
        INNER JOIN 테이블명2 ON(조인조건[AND 일반조건1])
       [INNER JOIN 테이블명3 ON(조인조건[AND 일반조건2])]
                    :
       [WHERE 일반조건n]
       
사용예) 2005년 7월 매출자료를 조회하시오.
       Alias는 일자,상품코드,상품명,판매수량,판매금액
       SELECT SUBSTR(A.CART_NO,5,2)||'월'||SUBSTR(A.CART_NO,7,2)||'일' AS 일자,
              A.CART_PROD AS 상품코드,
              B.PROD_NAME AS 상품명,
              A.CART_QTY AS 판매수량,
              A.CART_QTY*B.PROD_PRICE AS 판매금액
         FROM CART A, PROD B
        WHERE A.CART_NO LIKE '200507%' --일반조건
          AND A.CART_PROD=B.PROD_ID  --조인조건(상품명과 판매단가 참조)
        ORDER BY 1;
        
       
사용예) 사원테이블에서 급여가 15000 이상되는 사원정보를 조회하시오.
       Alias는 사원번호,사원명,부서번호,부서명,직무명,급여
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_ID AS 부서번호,
              B.DEPARTMENT_NAME AS 부서명,
              C.JOB_TITLE AS 직무명,
              A.SALARY AS 급여
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C
        WHERE A.SALARY>=15000 --일반조건
          AND A.DEPARTMENT_ID=B.DEPARTMENT_ID --조인조건(부서명 참조)
          AND A.JOB_ID=C.JOB_ID --조인조건(직무명 참조)
        ORDER BY 1;
       
사용예) 2005년 2월 거래처별 매입집계를 조회하시오.
       Alias는 
       SELECT B.BUYER_ID AS 거래처코드,
              B.BUYER_NAME AS 거래처명,
              SUM(A.BUY_QTY*C.PROD_COST) AS 매입금액합계
         FROM BUYPROD A, BUYER B, PROD C
        WHERE A.BUY_PROD=C.PROD_ID
          AND C.PROD_BUYER=B.BUYER_ID
          AND (A.BUY_DATE BETWEEN TO_DATE('20050201') AND LAST_DAY(TO_DATE('20050201')))
        GROUP BY B.BUYER_ID,B.BUYER_NAME
        ORDER BY 1;