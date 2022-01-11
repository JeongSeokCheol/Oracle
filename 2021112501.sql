2021-1125-01)서브쿼리 
 - 쿼리 안에 또 다른 쿼리가 존재 
 - 서브쿼리는 많은 JOIN등을 대신할 수 있음
 - 서브쿼리는 주쿼리(메인쿼리)에서 사용할 중간결과를 도출하기위한 쿼리
 - 서브쿼리는 '( )'안에 기술함
 - 서브쿼리는 연산자 오른쪽에 위치해야함
  ( 서브쿼리의 분류 )
   . 일반서브쿼리 : SELECT절에 위치
   . 인라인(in-line view) 서브쿼리 : FORM 절에 위치(독립실행이 가능)
   . 중첩서브쿼리 : WHERE절에 위치
 - 메인쿼리와의 연관성 여부에 따라
   . 연관성이 없는 서브쿼리 : 메인쿼리에 사용된 테이블과 서브쿼리에 사용된 테이블
                           사이에 JOIN이 발생 되지 않는 쿼리
   . 연관성이 있는 서브쿼리 : 메인쿼리에 사용된 테이블과 서브쿼리에 사용된 테이블
                           사이에 JOIN으로 연결된 쿼리
 - 반환되는 행의 갯수에 따라
   . 단일행 서브쿼리 : 하나의 행만 반환(일반 연산자 사용)
   . 다중행 서브쿼리 : 복수개의 행을 반환(다중행 연산자를 사용하여 처리)

1)연관성없는 서브쿼리
 - 메인쿼리와 서브쿼리 사이에 조인으로 연결되지 않은 서브쿼리
 
사용예)사원테이블에서 평균급여보다 많은 급여를 받는 사원의 
      사원번호,사원명,부서번호,급여를 츨력하시오.
      (메인쿼리 : 사원번호,사원명,부서번호,급여를 츨력)
      SELECT EMPLOYEE_ID AS 사원번호,
             EMP_NAME AS 사원명,
             DEPARTMENT_ID AS 부서번호,
             SALARY AS 급여
        FROM HR.EMPLOYEES
       WHERE SALARY > (평균급여 : 서브쿼리);
       
       (서브쿼리 : 평균급여 계산)
       SELECT ROUND(AVG(SALARY),2)
         FROM HR.EMPLOYEES;
         
     (결합)
      SELECT EMPLOYEE_ID AS 사원번호,
             EMP_NAME AS 사원명,
             DEPARTMENT_ID AS 부서번호,
             SALARY AS 급여
        FROM HR.EMPLOYEES
       WHERE SALARY > (SELECT AVG(SALARY)
                         FROM HR.EMPLOYEES); --서브쿼리가 사우너수만큼 실행
    
     
      SELECT A.EMPLOYEE_ID AS 사원번호,
             A.EMP_NAME AS 사원명,
             A.DEPARTMENT_ID AS 부서번호,
             A.SALARY AS 급여
        FROM HR.EMPLOYEES A,(SELECT AVG(SALARY) AS BABG
                               FROM HR.EMPLOYEES) B --연관성있는 서브쿼리
       WHERE A.SALARY > B.BABG;               --조인이 되어짐
    
2)연관성있는 서브쿼리
 - 메인쿼리와 서브쿼리 사이에 조인으로 연결된 서브쿼리
 
 사용예)직무변동테이블에서 사용된 부서번호와 부서테이블의 부서변호가 같은 정보를 조회하시오
       Alias는 부서번호,부서명
      (메인쿼리) 
       SELECT 부서번호,부서명
         FROM HR.DEPARTMENTS
        WHERE DEPARTMENT_ID=(부서테이블의 부서번호와 동일한 JOB_HISTORY테이블에서의 부서번호 : 서브쿼리);
        
      (서브쿼리 : 부서테이블의 부서번호와 동일한 JOB_HISTORY테이블에서의 부서번호)  
       SELECT B.DEPARTMENT_ID
         FROM HR.DEPARTMENTS A,HR.JOB_HISTORY B
        WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID;
        
      (결합)
      (EXISTS 연산자 사용)
       SELECT A.DEPARTMENT_ID AS 부서번호,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.DEPARTMENTS A
        WHERE EXISTS (SELECT 1  -- 1 : 의미없는 숫자 1을 찍는다. 의미없는 숫자를 찍히면 조건이 맞아 참이 된다. 
                        FROM HR.JOB_HISTORY B
                       WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID); -- 다중행 서브쿼리
                                                               -- EXISTS는 뒤에 나오는 하나의 열이라도 존재하면 참이 된다.
                                                               -- EXISTS 옆에는 컬럼이 존재하지 않는다.
      (IN 연산자 사용)  
       SELECT A.DEPARTMENT_ID AS 부서번호,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID IN (SELECT B.DEPARTMENT_ID  
                                    FROM HR.JOB_HISTORY B);
                                    
    
       SELECT /*B.EMPLOYEE_ID AS 사원번호,
              (SELECT EMP_NAME
                 FROM HR.EMPLOYEES A
                WHERE A.EMPLOYEE_ID=B.EMPLOYEE_ID) AS 사원명,*/
              DISTINCT DEPARTMENT_ID AS 부서번호,
              (SELECT DEPARTMENT_NAME
                 FROM HR.DEPARTMENTS C
                WHERE C.DEPARTMENT_ID=B.DEPARTMENT_ID) AS 부서명
         FROM HR.JOB_HISTORY B;
         
사용예)2005년 5월 구매금액을 기준으로 가장 많은 구매를 기록한 회원의
      회원번호,회원명,직업,마일리지를 조회하시오.
      
      (서브쿼리: 회원별 구매액 중 최대 구매액)
      
      SELECT D.CID AS DID,
             D.CSUM AS DSUM
        FROM (SELECT B.CART_MEMBER AS CID,
                 SUM(B.CART_QTY*C.PROD_PRICE) AS CSUM
                FROM CART B, PROD C
               WHERE B.CART_PROD=C.PROD_ID
                 AND B.CART_NO LIKE '200505%'
            GROUP BY B.CART_MEMBER
            ORDER BY 2 DESC) D
            WHERE ROWNUM =1;
      
      SELECT A.MEM_ID AS 회원번호,
             A.MEM_NAME AS 회원명,
             A.MEM_JOB AS 직업,
             A.MEM_MILEAGE AS 마일리지
        FROM MEMBER A 
       WHERE A.MEM_ID=(SELECT D.CID AS DID
                         FROM (SELECT B.CART_MEMBER AS CID,
                               SUM(B.CART_QTY*C.PROD_PRICE) AS CSUM
                              FROM CART B, PROD C
                             WHERE B.CART_PROD=C.PROD_ID
                               AND B.CART_NO LIKE '200505%'
                             GROUP BY B.CART_MEMBER
                             ORDER BY 2 DESC) D
                        WHERE ROWNUM =1);
                        
**다음 조건을 만족하는 재고수불테이블을 생성하시오.
  1) 테이블명 : REMAIN
  2) 컬럼 및 제약조건
  --------------------------------------------------------------------------------------
  컬럼명           테이블타입       NULLABLE    DEFAULT         PK/FK
  --------------------------------------------------------------------------------------
  REMAIN_YEAR     CHAR(4)          N.N                         PK
  PROD_ID         VARCHAR2(10)     N.N                         PK/FK
  REMAIN_J_00     NUMBER(5)                     0               
  REMAIN_I        NUMBER(5)                     0
  REMAIN_O        NUMBER(5)                     0
  REMAIN_J_99     NUMBER(5)                     0
  REMAIN_DATE     DATE
 ----------------------------------------------------------------------------------------
 
 CREATE TABLE REMAIN(
  REMAIN_YEAR     CHAR(4),        
  PROD_ID         VARCHAR2(10),  
  REMAIN_J_00     NUMBER(5) DEFAULT 0,                                   
  REMAIN_I        NUMBER(5) DEFAULT 0,        
  REMAIN_O        NUMBER(5) DEFAULT 0,         
  REMAIN_J_99     NUMBER(5) DEFAULT 0,         
  REMAIN_DATE     DATE,
  
  CONSTRAINT pk_remain PRIMARY KEY(REMAIN_YEAR,PROD_ID),
  CONSTRAINT fk_re_prod FOREIGN KEY(PROD_ID) REFERENCES PROD(PROD_ID));
  
  ** 생성된 재고수불테이블에 다음 자료를 입력하시오.
     REMAIN_YEAR : '2005'
     PROD_ID : 상품테이블의 상품코드
    
     INSERT INTO REMAIN(REMAIN_YEAR,PROD_ID)
     SELECT '2005',PROD_ID FROM PROD;
    
     SELECT * FROM REMAIN;
    
  ** 생성된 재고수불테이블에 기초재고와 날짜를 입력하시오.
     기초재고는 상품테이블의 적정재고를 사용하고 날짜는 2004-12-31을 입력
     
     UPDATE REMAIN
        SET 컬럼명1=(서브쿼리),
            컬럼명2=(서브쿼리),
            컬럼명3=(서브쿼리)
      WHERE 조건;
      
     UPDATE REMAIN
        SET (컬럼명1,컬러명2,컬럼명3)=(서브쿼리)
      WHERE 조건;
      
     UPDATE REMAIN A
        SET (A.REMAIN_J_00,A.REMAIN_J_99,A.REMAIN_DATE) = 
            (SELECT B.PROD_PROPERSTOCK,
                    B.PROD_PROPERSTOCK,
                    TO_DATE('20041231')
               FROM PROD B
              WHERE A.PROD_ID=B.PROD_ID)
     WHERE A.REMAIN_YEAR='2005'
     
     COMMIT;
     