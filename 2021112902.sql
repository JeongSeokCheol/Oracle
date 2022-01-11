2021-1129-02)오라클 객체
 1.VIEW 객체
  - 가상의 테이블(테이블 객체와 유사한 성격)
  - SELECT문의 실행결과
  - 필요한 정보가 여러 테이블에 분산 저장된 경우
  - 특정 테이블의 접근을 제한하고자 하는 경우 주로 사용
  (구문형식)
  CREATE [OR REPLACE] VIEW 뷰이름[(컬럼list)] 
  AS
    SELECT 문;
     [WITH CHECK OPTION]
     [WITH READ ONLY]
     
   . 'OR REPLACE' : 이미 존재하는 뷰인 경우에는 대치하고 신규인 뷰는 생성
   . '컬럼list' : 뷰에 사용될 컬럼명들
                생략되면 SELECT절의 별칭이 뷰의 이름으로 부여되며, 별칭이
                없는 경우 SELECT절의 컬럼명이 뷰의 컬럼명이 됨
   . 'WITH CHECK OPTION' : SELECT문의 WHERE 조건절을 위배하는 dml명령을 
                           뷰에 사용할수 없음(원본테이블은 제한없이 사용)
   . 'WITH READ ONLY' : 읽기전용 뷰를 생성 --테이블의 값을 변경하지 않기 위해 사용 , CHECK OPTION과 같이 쓸 수 없다
   
사용예)회원테이블에서 마일리지가 3000이상인 회원의 
      회원번호,회원명,전화번호,마일리지로 구성된 뷰를 생성하시오.
      
      CREATE OR REPLACE VIEW V_MEM01
      AS
        SELECT MEM_ID ,
               MEM_NAME ,
               MEM_HP ,
               MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000;
         
      SELECT * FROM V_MEM01;
        
**원본테이블 변경
  1. 이혜나회원 (e001)의 보유 마일리지를 2500으로 변경
    UPDATE MEMBER
       SET MEM_MILEAGE=2500
     WHERE MEM_ID='e001';
     
    SELECT * FROM V_MEM01;
    
    ROLLBACK;
    COMMIT;
  2. 신규회원 등록
   [자료]
   회원번호 : d002
   이름 : 임헌길
   암호 : 1234
   주민번호 : 010625-4236789
   우편번호 : 34940
   주소 : 대전시 중구 중앙로 76
         영민빌딩 3층 대덕인재개발원
   집전화번호 : 042-222-8203
   회사전화번호 : 042-222-8202
   메일 : hungil@naver.com
   
   INSERT INTO MEMBER(MEM_ID,MEM_PASS,MEM_NAME,MEM_REGNO1,MEM_REGNO2,
                      MEM_ZIP,MEM_ADD1,MEM_ADD2,MEM_HOMETEL,MEM_COMTEL,
                      MEM_MAIL,MEM_MILEAGE)
               VALUES('d002','1234','임헌길','010625','4236789',
                      '34940','대전시 중구 중앙로 76','영민빌딩 3층 대덕인재개발원','042-222-8203','042-222-8202',
                      'hungil@naver.com',6700);
  SELECT * FROM V_MEM01;                    
  COMMIT;
  
**뷰의 자료를 변경
  1. 뷰내의 이진영회원(v001)의 마일리지를 1300으로 변경
     UPDATE V_MEM01
        SET MEM_MILEAGE=1300
      WHERE MEM_ID='v001';
    
     SELECT * FROM V_MEM01;   
     
     SELECT MEM_ID,MEM_NAME,MEM_MILEAGE
       FROM MEMBER
      WHERE MEM_ID='v001';
   
  2. 뷰에서 이혜나회원자료를 삭제
     DELETE 
       FROM V_MEM01
      WHERE MEM_ID='e001';
      
      SELECT * FROM V_MEM01;
      
     CREATE OR REPLACE VIEW V_MEM01
      AS
     SELECT MEM_ID ,
            MEM_NAME ,
            MEM_HP ,
            MEM_MILEAGE
       FROM MEMBER
      WHERE MEM_MILEAGE >= 3000
      -- WITH CHECK OPTION
       WITH READ ONLY;
         
      COMMIT;
      
**원본테이블 변경
  1. 이진영회원(v001)의 마일리지를 5300으로 변경
     UPDATE MEMBER
        SET MEM_MILEAGE=5300
      WHERE MEM_ID='v001' ;
      
      SELECT * FROM V_MEM01;
  2. 임헌길 회원(d002)의 자료삭제
     DELETE 
       FROM MEMBER
      WHERE MEM_ID = 'd002';
      
     SELECT * FROM V_MEM01;
     
**뷰의 자료 변경
  1. 이진영 회원(v001)의 마일리지를 2300으로 변경
     UPDATE V_MEM01
        SET MEM_MILEAGE=2300
      WHERE MEM_ID='v001'; 
      
  2. 안은정회원(s001)의 마일리지를 7200으로 변경
     UPDATE V_MEM01
        SET MEM_MILEAGE=7200
      WHERE MEM_ID='s001';
      
     SELECT * FROM V_MEM01;
     
사용예)2005년 5월 제품별 매출액집계를 다이어그램과 연동하기 위한  뷰를 생성하시오.
      다이어그램과 연동하기 위한 자료는 상품명,매출액,매출수량이다, 읽기전용
      뷰로 생성하시오.(뷰이름은 V_SUM01이다)
      (SELECT 문)
       SELECT B.PROD_NAME AS 상품명,
              SUM(A.CART_QTY*B.PROD_PRICE) AS 매출액,
              SUM(A.CART_QTY) AS 매출수량
         FROM CART A,PROD B
        WHERE A.CART_PROD=B.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY B.PROD_NAME
        
       CREATE OR REPLACE VIEW V_SUM01
       AS
         SELECT B.PROD_NAME AS PNAME,
                SUM(A.CART_QTY*B.PROD_PRICE) AS PSUM,
                SUM(A.CART_QTY) AS PCNT
           FROM CART A,PROD B
          WHERE A.CART_PROD=B.PROD_ID
            AND A.CART_NO LIKE '200505%'
          GROUP BY B.PROD_NAME
           WITH READ ONLY;
        
       SELECT * FROM V_SUM01; 
       
       
     