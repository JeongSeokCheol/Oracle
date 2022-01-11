2021-1130-03)분기문
 - 프로그램의 싱행중 특정 조건을 판단하여 진행 방향을 바꾸는 명령
 - IF문, CASE WHEN THEN문 제공
 1) IF 문
  - 프로그래밍언어의 IF문과 동일기능 제공
   (사용형식-1)
   IF 조건1 THEN
      명령문1;
  [ELSIF 조건2 THEN
         명령문2;]
  [ELSE
        명령문n;]
   END IF; --IF문을 닫기위해 반드기 기재

   (사용형식-2)
   IF 조건1 THEN
     IF 조건2 THEN
        명령문1;
    [ELSE
        명령문2;
     END IF;
  [ELSE
       명령문n;]
   END IF;    
 
 사용예)사원테이블에서 임의의 부서코드를 선택하여 해당 부서의
       첫번째 검색된 직원의 급여가 3000이하이면 '낮은급여 직원'
       급여가 3001~6000이면 '중간급여 직원'
       급여가 6001~10000이면 '높은급여 직원'
       그 이상이면 '최상위 급여 직원'을 출력하시오.
       Alias는 부서번호,사원명,급여,비고이다.
       
       DECLARE
          V_DID HR.EMPLOYEES.DEPARTMENT_ID%TYPE;
          V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE;
          V_SALARY NUMBER:=0;
          V_REMARKS VARCHAR2(100);
       BEGIN
          V_DID:=TRUNC(DBMS_RANDOM.VALUE(10,119),-1); --부서번호
          SELECT EMP_NAME,SALARY INTO V_ENAME,V_SALARY
            FROM HR.EMPLOYEES
           WHERE DEPARTMENT_ID=V_DID
             AND ROWNUM=1;
          IF
            V_SALARY <= 3000 THEN
            V_REMARKS:='낮은급여 직원';
          ELSIF
            V_SALARY <= 6000 THEN
            V_REMARKS:='중간급여 직원';
          ELSIF
            V_SALARY <= 10000 THEN
            V_REMARKS:='높은급여 직원';
          ELSE
            V_REMARKS:='최상위 급여 직원';
          END IF;
          
          DBMS_OUTPUT.PUT_LINE('부서번호 : '||V_DID);
          DBMS_OUTPUT.PUT_LINE('사원명 : '||V_ENAME);
          DBMS_OUTPUT.PUT_LINE('급여 : '||V_SALARY);
          DBMS_OUTPUT.PUT_LINE('비고 : '||V_REMARKS);
       END;

사용예)점수하나를 입력 받아
      100~97:A+,
      96~94 :A0,
      93~90:A-,
      89~87:B+,
      86~84:B0,
      83~80:B-
      그 이하는 F를 출력
       
      ACCEPT P_SCORE PROMPT '점수 입력: '
      DECLARE
        V_SCORE NUMBER:=TO_NUMBER('&P_SCORE');
        V_RES VARCHAR2(100);

      BEGIN
        IF
          V_SCORE>=90 THEN
          IF
            V_SCORE>=97 THEN
            V_RES:='A+입니다.';
          ELSIF
            V_SCORE >= 94 THEN
            V_RES:='A0입니다.';
          ELSE
            V_RES:='A-입니다.';
          END IF;
        ELSIF
          V_SCORE>=80 THEN
          IF
            V_SCORE>=87 THEN
            V_RES:='B+입니다.';
          ELSIF
            V_SCORE >= 84 THEN
            V_RES:='B0입니다.';
          ELSE
            V_RES:='B-입니다.';
          END IF;
        ELSE
        V_RES:='F 입니다.';
      END IF;
        DBMS_OUTPUT.PUT_LINE(V_SCORE||'점은'||V_RES);
      END;

 2)CASE WHEN ~THEN 문
  - 다중분기명령으로 자바의 SWITCH~CASE문과 유사
  (사용 형식)
   CASE 표현식
       WHEN 결과1 THEN
            명령어1;
       WHEN 결과2 THEN
            명령어2;
              :
       ELSE
           명령문n;
           
   END CASE;

  (사용 형식2)
   CASE WHEN 표현식1 THEN
             명령문1;
        WHEN 표현식2 THEN
             명령어2;
               :
        ELSE
            명령문n;
           
   END CASE;
   