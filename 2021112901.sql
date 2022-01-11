2021-1129-01)집합연산자
 - 집합론에서 제공하는 연산 db에서 수행하기 위한 연산자
 - UNION, UNION ALL, INTERSECT, MINUS 제공
 - 각 SELECT문의 SELECT절에 사용된 컬럼의 수와 컬럼의 데이터타입은 일치해야함
 - 첫 번째 SELECT문의 SELECT절이 출력의 기준이됨
 - CLOB,BLOB,BFILE타입은 사용 불가
 - ORDER BY 절은 맨 마지막 SELECT문에만 사용 가능
 
 1)UNION , UNION ALL
  - 합집합의 결과를 반환
  - UNION : 중복을 배제한 합집합을 반환
  - UNION ALL : 중복을 허용한 합집합을 반환
  
사용예)회원들의 직업이 '학생'인 회원 정보 또는 취미가 '등산'인 회원들의 
      회원번호,회원명,주소,취미,직업을 조회하시오.
      
      SELECT MEM_ID AS 회원번호,
             MEM_NAME AS 회원명,
             MEM_ADD1||' '||MEM_ADD2 AS 주소,
             MEM_LIKE AS 취미,
             MEM_JOB AS 직업
             
        FROM MEMBER
       WHERE MEM_JOB = '학생'
       UNION ALL
      SELECT MEM_ID AS 회원번호,
             MEM_NAME AS 회원명,
             MEM_ADD1||' '||MEM_ADD2 AS 주소,
             MEM_LIKE AS 취미,
             MEM_JOB AS 직업
             
        FROM MEMBER
       WHERE MEM_LIKE = '등산'

사용예)2005년 4월과 6월에 판매된 모든 상품을 조회하시오.
      Alias는 상품코드,상품명,매입단가,매출단가
      단,중복배제
      SELECT DISTINCT A.CART_PROD AS 상품코드,
             B.PROD_NAME AS 상품명,
             B.PROD_COST AS 매입단가,
             B.PROD_PRICE AS 매출단가
        FROM CART A,PROD B
       WHERE A.CART_NO LIKE '200504%'
         AND A.CART_PROD=B.PROD_ID
      UNION 
     SELECT DISTINCT A.CART_PROD AS 상품코드,
             B.PROD_NAME AS 상품명,
             B.PROD_COST AS 매입단가,
             B.PROD_PRICE AS 매출단가
        FROM CART A,PROD B
       WHERE A.CART_NO LIKE '200506%'
         AND A.CART_PROD=B.PROD_ID
      
사용예)2005년 6월에 매입된 상품들과 2005년 6월 매출된 상품들을 조회하시오.
      Alias는 상품코드,상품명
      SELECT DISTINCT BUY_PROD AS 상품코드,
             PROD_NAME AS 상품명
        FROM BUYPROD , PROD 
       WHERE BUY_PROD =PROD_ID
         AND BUY_DATE BETWEEN TO_DATE('20050601') AND TO_DATE('20050630')
       UNION     
      SELECT DISTINCT CART_PROD AS 상품코드,
             PROD_NAME AS 상품명
        FROM CART, PROD 
       WHERE CART_PROD =PROD_ID
         AND CART_NO LIKE '200506%'
       ORDER BY 1;    
       
 2)INTERSECT
  - 교집합의 결과를 반환

사용예)2005년 1월과 2월에 모두 매입이 발생된 상품을 조회하시오.
      Alias는 상품코드,상품명,거래처코드
      
      SELECT B.PROD_ID AS 상품코드,
             B.PROD_NAME AS 상품명,
             B.PROD_BUYER AS 거래처코드
        FROM BUYPROD A ,PROD B
       WHERE B.PROD_ID=A.BUY_PROD
         AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
   INTERSECT   
      SELECT B.PROD_ID AS 상품코드,
             B.PROD_NAME AS 상품명,
             B.PROD_BUYER AS 거래처코드
        FROM BUYPROD A ,PROD B
       WHERE B.PROD_ID=A.BUY_PROD
         AND A.BUY_DATE BETWEEN TO_DATE('20050401') AND LAST_DAY(TO_DATE('20050401'))

사용예)2005년 1월과 4월에 모두 매입이 발생된 상품 중 5월에 판매된 상품을 조회하시오
      Alias는 상품코드,상품명,거래처코드
      
      (5월에 판매된 상품)
       SELECT DISTINCT A.CART_PROD AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_BUYER AS 거래처코드
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND CART_NO LIKE '200505%'
      (결합)    
      SELECT B.PROD_ID AS 상품코드,
             B.PROD_NAME AS 상품명,
             B.PROD_BUYER AS 거래처코드
        FROM BUYPROD A ,PROD B
       WHERE B.PROD_ID=A.BUY_PROD
         AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
   INTERSECT   
      SELECT B.PROD_ID AS 상품코드,
             B.PROD_NAME AS 상품명,
             B.PROD_BUYER AS 거래처코드
        FROM BUYPROD A ,PROD B
       WHERE B.PROD_ID=A.BUY_PROD
         AND A.BUY_DATE BETWEEN TO_DATE('20050401') AND LAST_DAY(TO_DATE('20050401'))
   INTERSECT 
      SELECT DISTINCT A.CART_PROD AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_BUYER AS 거래처코드
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND CART_NO LIKE '200505%';
          
 3)MINUS
  - 차집합의 결과를 반환
  
사용예)2005년 1월과 4월 중 1월에만 매입된 상품정보를 조회하시오
      Alias는 상품코드,상품명,분류코드
      SELECT DISTINCT B.BUY_PROD AS 상품코드,
             A.PROD_NAME AS 상품명,
             A.PROD_LGU AS 분류코드
        FROM PROD A,BUYPROD B
       WHERE A.PROD_ID=B.BUY_PROD
         AND B.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
       MINUS
      SELECT DISTINCT B.BUY_PROD AS 상품코드,
             A.PROD_NAME AS 상품명,
             A.PROD_LGU AS 분류코드
        FROM PROD A,BUYPROD B
       WHERE A.PROD_ID=B.BUY_PROD
         AND B.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050430');
         
    (집합연산자를 사용하지 않은 경우)   
      SELECT A.PROD_ID,
             A.PROD_NAME,
             A.PROD_LGU
        FROM (SELECT DISTINCT BUY_PROD AS APID
               FROM BUYPROD
              WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131'))TBLA,
                    PROD A
       WHERE NOT TBLA.APID IN (SELECT DISTINCT BUY_PROD AS BPID
                                  FROM BUYPROD
                                 WHERE BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050430'))
        AND A.PROD_ID=TBLA.APID;
        
