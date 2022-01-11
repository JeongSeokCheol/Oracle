2021-1201-02)

사용예)집무변동 테이블에 저장된 사원정보를 조회하여 해당 사원의
      사원번호,사원명,입사일 부서명,직무명을 출력하시오.
      
      DECLARE
        CURSOR CUR_JOB_HISTORY IS 
          SELECT DISTINCT EMPLOYEE_ID
            FROM HR.JOB_HISTORY;
        V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE; -- 사원번호
        V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE; -- 사원명
        V_HDATE DATE; -- 입사일
        V_DEPT HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE; -- 부서명
        V_JOBT HR.JOBS.JOB_TITLE%TYPE; -- 직무명
        
      BEGIN
        OPEN CUR_JOB_HISTORY;
        LOOP
          FETCH CUR_JOB_HISTORY INTO V_EID;
          EXIT WHEN CUR_JOB_HISTORY%NOTFOUND;
          SELECT A.EMP_NAME,B.DEPARTMENT_NAME,C.JOB_TITLE,A.HIRE_DATE
            INTO V_ENAME,V_DEPT,V_JOBT,V_HDATE
            FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C
           WHERE A.EMPLOYEE_ID=V_EID
             AND A.DEPARTMENT_ID=B.DEPARTMENT_ID
             AND A.JOB_ID=C.JOB_ID;
            
          DBMS_OUTPUT.PUT_LINE('사원번호 : '||V_EID);
          DBMS_OUTPUT.PUT_LINE('사원명 : '||V_ENAME);
          DBMS_OUTPUT.PUT_LINE('입사일 : '||V_HDATE);
          DBMS_OUTPUT.PUT_LINE('부서명 : '||V_DEPT);
          DBMS_OUTPUT.PUT_LINE('직책명 : '||V_JOBT);
          DBMS_OUTPUT.PUT_LINE('----------------------------');
          END LOOP;
          CLOSE CUR_JOB_HISTORY;
      END;
      
      DECLARE
        CURSOR CUR_JOB_HISTORY IS 
          SELECT DISTINCT EMPLOYEE_ID AS EID
            FROM HR.JOB_HISTORY;
        V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE; -- 사원명
        V_HDATE DATE; -- 입사일
        V_DEPT HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE; -- 부서명
        V_JOBT HR.JOBS.JOB_TITLE%TYPE; -- 직무명
        
      BEGIN
        FOR REC IN CUR_JOB_HISTORY LOOP
          SELECT A.EMP_NAME,B.DEPARTMENT_NAME,C.JOB_TITLE,A.HIRE_DATE
            INTO V_ENAME,V_DEPT,V_JOBT,V_HDATE
            FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C
           WHERE A.EMPLOYEE_ID=REC.EID
             AND A.DEPARTMENT_ID=B.DEPARTMENT_ID
             AND A.JOB_ID=C.JOB_ID;
            
          DBMS_OUTPUT.PUT_LINE('사원번호 : '||REC.EID);
          DBMS_OUTPUT.PUT_LINE('사원명 : '||V_ENAME);
          DBMS_OUTPUT.PUT_LINE('입사일 : '||V_HDATE);
          DBMS_OUTPUT.PUT_LINE('부서명 : '||V_DEPT);
          DBMS_OUTPUT.PUT_LINE('직책명 : '||V_JOBT);
          DBMS_OUTPUT.PUT_LINE('----------------------------');
          END LOOP;
      END;