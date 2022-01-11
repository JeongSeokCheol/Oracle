2021-11010-01)
  (5)BETWEEN 연산자
   . 범위를 지정할때 사용되는 연산자
   . AND 연산자로 대처될 수 있음
   (사용형식)
    expr BETWEEN 데이터1 AND 데기터2
    - 'expr'값이 '데이터1'에서 '데이터2' 사이에 존재하면 결과가 참이다.
    - '데이터1'과 '데이터2'는 같은 타입이여야 한다.
    -  사용할 수있는 데이터 타입은 모든 타입 가능
    - 특히, 날짜 구간 설정에 많이 사용  -- **날짜를 LIKE연산자를 쓰지 않는다

사용예)사원테이블에서 2006년~2007년 입사한 사원을 조회하시오.
      조회할 값은 사원번호,사원명,부서코드,입사일,직무코드이며
      입사일 순, 부서코드순 으로 출력하시오.
     (AND 연산자 사용) 
      SELECT EMPLOYEE_ID AS 사원번호,
             EMP_NAME AS 사원명,
             DEPARTMENT_ID AS 부서코드,
             HIRE_DATE AS 입사일,
             JOB_ID AS 직무코드
        FROM HR.EMPLOYEES
       WHERE HIRE_DATE>=TO_DATE('20060101') AND HIRE_DATE<=TO_DATE('20071231')
        ORDER BY 4,3;
        
       (BETWEEN 연산자 사용)
        SELECT EMPLOYEE_ID AS 사원번호,
             EMP_NAME AS 사원명,
             DEPARTMENT_ID AS 부서코드,
             HIRE_DATE AS 입사일,
             JOB_ID AS 직무코드
        FROM HR.EMPLOYEES
       WHERE HIRE_DATE BETWEEN TO_DATE('20060101') AND TO_DATE('20071231')
        ORDER BY 4,3;

사용예)매입테이블(BUYPROD)에서 2005년 2월 매입LIST를 출력하시오.
      Alias는 날짜,살품코드,수량,금액이다.
      
      SELECT BUY_DATE AS 날짜,
             BUY_PROD AS 상품코드,
             BUY_QTY AS 수량,
             BUY_QTY*BUY_COST AS 금액
        FROM BUYPROD
       WHERE BUY_DATE BETWEEN TO_DATE('20050201') AND TO_DATE('20050228')
        ORDER BY 1;
        
        SELECT BUY_DATE AS 날짜,
             BUY_PROD AS 상품코드,
             BUY_QTY AS 수량,
             BUY_QTY*BUY_COST AS 금액
        FROM BUYPROD
       WHERE BUY_DATE BETWEEN TO_DATE('20050201') AND LAST_DAY(TO_DATE('20050201')) --BUY_DATE는 날짜타입
        ORDER BY 1;

  (6)LIKE 연산자  --ONLY 문자열비교 날짜 비교를 하면 안된다.
   . 패턴을 비교하는 문자열 비교 연산자
   . 패턴문자(와일드카드)로는 '%','_'가 사용
    (a) '%'
      - '%'가 사용된 위치에서 그이후의 모든 문자열과 대응 됨
       ex)'홍%' : 첫 글자가 '홍'이고 나머지글자는어떤 글자와도 대응되어 
                  참의 결과 반환
          '%홍' : 끝 글자가 '홍'인 모든 문자열과 대응 됨
          '%홍%' : 문자열 내부에 '홍'문자가 있는 모든 문자열과 대응
          
    (b)'_'
      - '_'가 사용된 위치에 한 문자와 대응
       ex)'홍_' : 첫 글자가 '홍'인 문자열만 대응 
          '_홍' : 끝 글자가 '홍'인 2자로 구성된 문자열과 대응 됨
          '_홍_' : 문자열 내부에 '홍'문자가 있는 세글자로 구성된 문자열과 대응
          
사용예) 회원테이블에서 거주지가 '대전'인 회원 정보를 조회하시오.
       Alias는 회원번호,회원명,주소,직업
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' ' ||MEM_ADD2 AS 주소,
              MEM_JOB AS 직업
        FROM MEMBER
       WHERE MEM_ADD1 LIKE '대전%';
       
사용예) 장바구니테이블에서 2005년 7월 구매이력이 있는 회원번호를 조회하시오.
       SELECT DISTINCT CART_MEMBER AS 회원번호     
        FROM  CART
       WHERE  CART_NO LIKE '200507%';

사용예)상품명이 '대우'가 포함된 모든 상품을 조회하시오.
      Alias는 상품번호,상품명,거래처코드,분류코드
      SELECT PROD_ID AS 상품번호,
             PROD_NAME AS 상품명,
             PROD_BUYER AS 거래처코드,
             PROD_LGU AS 분류코드
        FROM PROD
       WHERE PROD_NAME LIKE '%대우%'
      