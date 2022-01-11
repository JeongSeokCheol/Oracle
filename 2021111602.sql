2021-1116-02)집계함수
 - 특정컬럼을 기준으로 자료를그룸화하고 그룸화된 자료를 대상으로 집계처리에
 사용하는 함수
 - SUM,AVG,COUNT,MIN,MAX가 제공됨
 (표현방식)
     SELECT 컬럼명1[AS 별칭][,]
            [컬럼명1[AS 별칭]][,]
            집계함수(expr)[,]
            [집계함수(expr)[,]
             :
        FROM 테이블명
      [WHERE 조건]
      [GROUP BY 컬럼명1[,컬럼명2,...]
      [HAVING 조건] --집계함수 자체의 조건
      [ORDER BY 컬럼명|커럼인덱스 [ASC|DESC]
      
사용예)회원테이블에서 회원전체의 마일리지합계를 조회하시오.
      SELECT SUM(MEM_MILEAGE),
             AVG(MEM_MILEAGE),
             COUNT(*)
      
        FROM MEMBER;
        
    1)SUM(expr)
     . 'expr'로 표현된 컬럼이나 수식의 결과값의 합계를 반환
     
사용예)회원테이블에서 거주지별 마일리지 합계를 구하시오
      SELECT SUBSTR(MEM_ADD1,1,2) AS 거주지,
             SUM(MEM_MILEAGE) AS "마일리지 합계"
        FROM MEMBER
       GROUP BY SUBSTR(MEM_ADD1,1,2);
        
사용예)매입테이블에서 2005년 1-3월 월별 매입집계를 구하시오
      SELECT EXTRACT(MONTH FROM BUY_DATE) AS 월별, 
             SUM(BUY_QTY) AS 매입수량합계,
             SUM(BUY_QTY*BUY_COST)매입금액합계
        FROM BUYPROD
       WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050331')
       GROUP BY EXTRACT(MONTH FROM BUY_DATE)
       ORDER BY 1;
사용예)매입테이블에서 2005년 1-3월 제품별 매입집계를 구하시오
      SELECT BUY_PROD AS 제품별,
             SUM(BUY_QTY) AS 매입수량합계,
             SUM(BUY_QTY*BUY_COST) AS 매입금액합계
        FROM BUYPROD
       WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050331')
       GROUP BY BUY_PROD
       ORDER BY 1;
       
사용예)매입테이블에서 2005년 1-3월 제품별 매입집계를 구하되
      매입금액합계가 500만원 이상인 제품만 조회하시오.
      SELECT BUY_PROD AS 제품별,
             SUM(BUY_QTY) AS 매입수량합계,
             SUM(BUY_QTY*BUY_COST) AS 매입금액합계
        FROM BUYPROD
       WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050331')
       HAVING SUM(BUY_QTY*BUY_COST)>=5000000 
       GROUP BY BUY_PROD
       ORDER BY 1;

사용예)회원테이블에서 성별 마일리지 합계를 구하시오
      SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR
                       SUBSTR(MEM_REGNO2,1,1)='3'THEN
                    '남성회원'
             ELSE
                    '여성회원'
             END AS 구분,
             SUM(MEM_MILEAGE) AS "마일리지 합계"
        FROM MEMBER
        GROUP BY CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR
                           SUBSTR(MEM_REGNO2,1,1)='3'THEN
                    '남성회원'
                 ELSE
                    '여성회원'
                 END;
                 
** CASE WHEN 표현식
  - 분기명령과 유사한 역활
  - SELECT 절에서만 사용 가능
  (표현형식)
   CASE 변수 WHEN 값1 THEN
                  expr1
             WHEN 값2 THEN
                  expr2
                    :
                  
    ELSE
        expr_n
    END [AS 컬럼별칭]
    
    (표현형식2)
   CASE WHEN 조건식1 THEN
             expr1
        WHEN 조건식1 THEN
             expr2
              :
                  
    ELSE
        expr_n
    END [AS 컬럼별칭]
    
 사용예) 회원테이블의 연령대별 마일리지 합계를 구하시오.
        SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1)||'대'
                AS 연령대,
               SUM(MEM_MILEAGE) AS "마일리지 합계"
          FROM MEMBER
         GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1)
         ORDER BY 1;
         
사용예)장바구니테이블에서 2005년 6월 일자별,회원별 구매집계를 조회하시오,
      Alias는 일자,회원번호,구매수량합계
      SELECT SUBSTR(CART_NO,1,8) AS 일자,
             CART_MEMBER AS 회원번호,
             SUM(CART_QTY) AS 구매수량합계
        FROM CART
       WHERE SUBSTR(CART_NO,1,6)='200506'
       GROUP BY SUBSTR(CART_NO,1,8),CART_MEMBER
       ORDER BY 1;
       
사용예)장바구니테이블에서 2005년 6월 일자별,회원별 구매집계를 조회하시오 단,
      구매수량합계가 10이상이 되는 자료만 조회하시오.
      Alias는 일자,회원번호,구매수량합계
     SELECT SUBSTR(CART_NO,1,8) AS 일자,
             CART_MEMBER AS 회원번호,
             SUM(CART_QTY) AS 구매수량합계
        FROM CART
       WHERE CART_NO LIKE '200506%' --LIKE는 문자열을 다루는 함수
       GROUP BY SUBSTR(CART_NO,1,8),CART_MEMBER
       HAVING SUM(CART_QTY)>=10 --집계함수 조건은 무조건 HAVING절 GROUP BY다음에 나와야한다
       ORDER BY 1;
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    