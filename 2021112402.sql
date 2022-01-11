2021-1124-02)
  3)비동등조인(Non Eqi-Join)
   - 조인조건에 '='연산자 이외의 연산자가 사용된 경우 
   - 대상테이블의 어떤 값도 원본테이블의 값과 같지 않을때 사용
사용예)사원테이블에서 급여가 평균급여보다 많은 사원의 사원번호,사원명,급여,부서코드,평균급여를 조회하시오
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           A.SALARY AS 급여,
           A.DEPARTMENT_ID AS 부서코드,
           B.ASAL AS 평균급여
      FROM HR.EMPLOYEES A ,(SELECT ROUND(AVG(SALARY)) AS ASAL
                             FROM HR.EMPLOYEES) B
     WHERE A.SALARY > B.ASAL;
     
   4)셀프조인(Self-Join)
    - 하나의 테이블에 서로 다른 별칭을 부여하여 서로 다흔 테이블로
      취급하면서 수행하는 조인

사용예)회원번호 'b001'회원의 마일리지보다 많은 마일리지를
      보유한 회원의 회원번호,회원명,직업,마일리지
      
      SELECT A.MEM_ID AS 회원번호,
             A.MEM_NAME AS 회원명,
             A.MEM_JOB AS 직업,
             A.MEM_MILEAGE AS 마일리지,
             B.MEM_MILEAGE AS 기준마일리지
        FROM MEMBER A,MEMBER B
       WHERE B.MEM_ID='b001'
         AND A.MEM_MILEAGE > B.MEM_MILEAGE
       ORDER BY 4;

사용예)급여가 자신이 속한 부서의 평균급여보다 많은 사원들의 
      사원번호,사원명,부서번호,급여,부서평균급여를 조회하시오.
      
        
사용예)직업이 '자영업'인 회원들의 보유한 마일리지보다 많은 마일리지를
      가지고있는 회원의 회원번호,회원명,직업,마일리지를 조회하시오.
      SELECT A.MEM_ID AS 회원번호,
             A.MEM_NAME AS 회원명,
             A.MEM_JOB AS 직업,
             A.MEM_MILEAGE AS 마일리지
        FROM MEMBER A
       WHERE A.MEM_MILEAGE > ANY (SELECT MEM_MILEAGE
                                    FROM MEMBER
                                   WHERE MEM_JOB='자영업');
        
        
사용예)직업이 '자영업'인 회원들의 보유한 모든 마일리지보다 많은 마일리지를
      가지고있는 회원의 회원번호,회원명,직업,마일리지를 조회하시오.
      
      SELECT A.MEM_ID AS 회원번호,
             A.MEM_NAME AS 회원명,
             A.MEM_JOB AS 직업,
             A.MEM_MILEAGE AS 마일리지
        FROM MEMBER A
       WHERE A.MEM_MILEAGE > ALL (SELECT MEM_MILEAGE
                                    FROM MEMBER
                                   WHERE MEM_JOB='자영업');