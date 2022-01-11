2021-1109-01)
  (2) IN
    - 제시된 복수개의 값 중 어느 하나와 일치하면 전체 조건이 참이되는 연산자
    - OR, =ANY, =SOME 연산자로 대치될 수 있음
    (사용 형식)
     expr IN(값1[,값2,....,값n])

  사용예)사원테이블에서 20,50,90,110번 부서에 속한 사원의 사원번호,사원명,부서코드,입사일,직무코드를 조회하시오.
       (OR 연산자 사용) 
        SELECT  EMPLOYEE_ID AS 사원번호,
                EMP_NAME AS 사원명,
                HIRE_DATE AS 입사일,
                DEPARTMENT_ID AS 부서코드,
                JOB_ID AS 직무코드               
            FROM HR.EMPLOYEES
            WHERE DEPARTMENT_ID=20 OR 
                  DEPARTMENT_ID =50 OR 
                  DEPARTMENT_ID=90 OR 
                  DEPARTMENT_ID=110
            ORDER BY 4;
            
       (OR 연산자 사용) 
        SELECT  EMPLOYEE_ID AS 사원번호,
                EMP_NAME AS 사원명,
                HIRE_DATE AS 입사일,
                DEPARTMENT_ID AS 부서코드,
                JOB_ID AS 직무코드
                
            FROM HR.EMPLOYEES
            WHERE DEPARTMENT_ID IN(20,50,90,110)
            ORDER BY 4;
            
  사용예)마일리지가 5000이상되는 회원들의 2005년 5월 구매현황을 조회하시오.
        Alias는 회원번호,구매수량합계,구매금액합계
        
        SELECT  A.CART_MEMBER AS 회원번호,
                SUM(A.CART_QTY) AS 구매수량합계,
                SUM(A.CART_QTY*B.PROD_PRICE) AS 구매금액합계
            FROM CART A,PROD B
           WHERE A.CART_MEMBER IN(SELECT MEM_ID
                                    FROM MEMBER
                                   WHERE MEM_MILEAGE>=5000) --다중행은 =과 같은 관계연산자를 사용할 수 없다
            AND A.CART_PROD=B.PROD_ID
            AND A.CART_NO LIKE '200505%'
           GROUP BY A.CART_MEMBER
           ORDER BY 1;
  
  (3) ANY (SOME)연산자
   - IN 연산자와 비슷한 기능 제공
   - 제기된 데이터(()안에 기술된 데이터) 중 어느 하나라도 조건에 만족하면
     전체 조건의 결과가 true가 되는 연산자
    (사용형식)
      expr 관계연산자ANY|SOME(값1[,값2,...,값n]) --관계연산자에 =이 사용되면 IN과 같다.
       
  사용예)회원테이블에서 직업이 '주부'인 회원의 마일리지보다 더 많은 마일리지를 보유한 회원정보를 조회하시오.
        Alias는 회원번호,회원명,직업,마일리지
        
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
            FROM MEMBER
          --WHERE MEM_MILEAGE >ANY(SELECT MEM_MILEAGE
          WHERE MEM_MILEAGE >SOME(SELECT MEM_MILEAGE
                                    FROM MEMBER
                                   WHERE MEM_JOB='주부');
                                   (1000,2700,800,2700,8700)
        
  사용예)사원테이블에서 각 부서별 평균급여보다 적은 급여를 받는 사원의 
        사원번호,사원명,부서번호,급여를 출력하시오
        
        SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명,
               DEPARTMENT_ID AS 부서번호,
               SALARY AS 급여
            FROM HR.EMPLOYEES
           WHERE SALARY <SOME(SELECT A.SSAL
                                FROM (SELECT DEPARTMENT_ID,
                                            ROUND(AVG(SALARY)) AS SSAL
                                        FROM HR.EMPLOYEES
                                      GROUP BY DEPARTMENT_ID)A);
  
  (4) ALL연산자
   - 제시된 데이터 어느것과 조건이 성립해야 전체조건이 참이되는 연산자
    (사용형식)
      expr 관계연산자ALL(값1[값2,...,값n])
       .'관계연산자'중 '=','!='는 사용되지 않음(허용되면 해당컬럼은 다중값을 갖는 경우가 되어
         제1 저규형 위배)
       . AND 연산자로 치환 가능
  
  사용예)회원테이블에서 직업이 '학생'인 모든 회원의 마일리지보다 더 많은 마일리지를 보유한 회원정보를 조회하시오.
        Alias는 회원번호,회원명,직업,마일리지  
        
        (직업이 학생인 회원들의 마일리지)
        SELECT MEM_MILEAGE
           FROM MEMBER
         WHERE MEM_JOB='학생';
         
                   
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지 
            FROM MEMBER
           WHERE MEM_MILEAGE >ALL(SELECT MEM_MILEAGE
                                    FROM MEMBER
                                    WHERE MEM_JOB='학생');
  
  
  
  
  
  