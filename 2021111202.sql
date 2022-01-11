2021-1112-02)
3.날짜함수
 1)SYSDATE
  - 시스템이 제공하는 날짜및 시간정보 제공
  - 기본 날짜 자료(YYYY/MM/DD HH24:MI:SS)타입
  - '+','-' 연산 : 증가(감소)된 날짜 반환
  - 날짜자료 사이의 뺄셈 : 두 날짜사이의 일수(DAYS) 반환
  
사용예)SELECT SYSDATE, SYSDATE+20, SYSDATE-20, TRUNC(SYSDATE)-TO_DATE('20201112')
        FROM DUAL;
        
  2)ADD_MONTHS(d,n)
   - 주어진 날짜지료 d에 n만큼의 월을 더한 날짜 반환
사용예)
    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           HIRE_DATE AS 입사일,
           ADD_MONTHS(HIRE_DATE,3) AS 발령일
        FROM HR.EMPLOYEES;

사용예)매입상품에 따른 결제일은 매입일 기준 2개월 후 일때 2005년 3월 일자별 
      결제할 금액을 조회하시오.
      Alias 날짜,결제금액이다.
    SELECT ADD_MONTHS(A.BUY_DATE,2) AS 날짜,
           TO_CHAR(A.BSUM,'999,999,999') AS 결제금액
           
        FROM (SELECT BUY_DATE,
                     SUM(BUY_QTY*BUY_COST) AS BSUM
                FROM BUYPROD
               WHERE ADD_MONTHS(BUY_DATE,2) BETWEEN TO_DATE('20050301')
                     AND TO_DATE('20050331')
                     GROUP BY BUY_DATE)A

  3)NEXT_DAY(d,fnt(요일을 나타내는 문자)), LAST_DAY(d)
   - NEXT_DAY : 주어진 날짜 d 이후에 처음 만나는 'fnt'로 시술된 요일의 날짜 반환.
                'fnt'는요일로 '월','월요일',...으로 기술
   - LAST_DAY : 주어진 날짜 d에 포함된 월의 마지막일자가 포함된 날짜 반환
   
사용예)2005년 2월 일자별 매입집계를 조회하시오
      Alias는 날짜,매입수량합계,매입금액합계
      
      SELECT BUY_DATE AS 날짜,
             SUM(BUY_QTY) AS 매입수량합계,
             SUM(BUY_QTY*BUY_COST) AS 매입금액합계
        FROM BUYPROD
       WHERE BUY_DATE BETWEEN TO_DATE('20050201') AND LAST_DAY(('20050201'))
       GROUP BY BUY_DATE
       ORDER BY 1;
  4)MONTHS_BETWEEN(d1,d2)
   - 주어진 두 날짜 자료 d1과 d2 사이의 개월 수를 반환
   
사용예)회원들의 정확한 나이를 조회하시오
      Alias는 회원번호,회원명,생년월일,나이
      단, 나이는 XX년 XX월로 계산
      
      SELECT MEM_ID AS 회원번호,
             MEM_NAME AS 회원명,
             MEM_BIR AS 생년월일,
             TRUNC(ROUND(MONTHS_BETWEEN(SYSDATE,MEM_BIR))/12)||'년 '||
             MOD(ROUND(MONTHS_BETWEEN(SYSDATE,MEM_BIR)),12)||'개월' AS 나이
        FROM MEMBER;
        
  5)EXTRACT(fnt FROM d)
   - 날짜자료 d에 포함된 각 요소(fnt : 년,월,일,시,분,초) 값을 반환
   - fnt는 YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
   - 결과로 반환되는 데이터 타입은 숫자형임

**MEMBER 테이블의 다음 자료를 갱신하시오
    회원번호: d001
    생년월일: 1946/04/09 -> 2000/04/09
    주민번호1: 460409 -> 000409
    주민번호2: 2000000 -> 4234654
    UPDATE MEMBER
        SET MEM_BIR=TO_DATE('20000409'),
            MEM_REGNO1='000409',
            MEM_REGNO2='4234654'
      WHERE LOWER(MEM_ID)='d001'
    회원번호: k001
    생년월일: 1962/01/23 -> 2001/01/23
    주민번호1: 620123 -> 010123
    주민번호2: 1449311 -> 3449311
    UPDATE MEMBER
        SET MEM_BIR=TO_DATE('20010123'),
            MEM_REGNO1='010123',
            MEM_REGNO2='3449311'
      WHERE LOWER(MEM_ID)='k001'
    회원번호: v001
    생년월일: 1952/01/31 -> 2004/01/31
    주민번호1: 520131 -> 040131
    주민번호2: 2402712 -> 3402712
    
    UPDATE MEMBER
        SET MEM_BIR=TO_DATE('20040131'),
            MEM_REGNO1='040131',
            MEM_REGNO2='3402712'
      WHERE LOWER(MEM_ID)='v001'
      
    COMMIT;