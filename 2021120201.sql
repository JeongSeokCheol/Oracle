2021-1202-01)트리거(Trigger)
 - 특정 테이블의 변경(INSERT,UPDATE,DELETE)되면 이를 이벤트로
   다른 테이블이자동으로 변경되도록 하는 일종의 프로시져
   
 (사용형식)
   CREATE OR REPLACE TRIGGER 트리거명
     AFTER|BEFORE INSERT|UPDATE|DELETE ON 테이블명
      [FOR EACH ROW]
      [WHEN 조건]
   [DECLARE]
      선언부;
   BEGIN
      트리거 본문;
   END;
   . 'AFTER|BEFORE' : 트리거 발생 시점 정의 
   . 'INSERT|UPDATE|DELETE' : 이벤트(조합 사용 가능, OR연산자 사용)
   . 'FOR EACH ROW' : 트리거 유형(행단위 트리거, 생략 하면 문자단위 트리거)
   . 'WHEN 조건' : 행단위 트리거에서만 사용 가능, 
                  이벤트발생에 대한 보다 구체적인 조건 제시

 1) 트리거 유형: 문장단위트리거와 행단위트리거로 구분
   (1) 문장단위트리거 : 'FOR EACH ROW'명령을 기술하지 않은 경우
                      트리거는 이벤트발생 전[후]에 한번 발생
                      WHEN 조건, :NEW, :OLD등을  사용할 수 없음

사용예)분류테이블에 순번(LPROD_ID)가 10이상되는 자료를 모두 제거하시오
      제거(삭제) 후 '자료가 삭제되었습니다.'라는 메세지를
      출력하는 트리거를 작성하시오.
      
      CREATE OR REPLACE TRIGGER TG_LPROD_DELETE
        AFTER DELETE ON LPROD
      BEGIN
        DBMS_OUTPUT.PUT_LINE('자료가 삭제되었습니다.');      
      END;
      
      CREATE OR REPLACE TRIGGER TG_LPROD_INSERT
        AFTER INSERT OP DELETE OR UPADATE ON LPROD
      BEGIN
        IF INSERTING THEN
         DBMS_OUTPUT.PUT_LINE('자료가 삽입되었습니다.');
        ELSIF UPDATING THEN
         DBMS_OUTPUT.PUT_LINE('자료가 수정되었습니다.');
        ELSIF DELETING THEN
         DBMS_OUTPUT.PUT_LINE('자료가 삭제되었습니다.');
        END IF;
      END;
   
      INSERT INTO LPROD VALUES(10,'P501','농산물');
      
      INSERT INTO LPROD VALUES(11,'P502','수산물');
      
      DELETE FROM LPROD WHERE LPROD_ID>=10;
      SELECT * FROM LPROD; 
      
   (2) 행단위트리거 : 이벤트의 각 행마다 트리거 발생
       - 트리거 의사레코드 : 행단위 트리거에서만 사용
       -----------------------------------------------------
       의사레코드        의  미
       -----------------------------------------------------
       :NEW          INSERT, UPDATE 이벤트 발생시 사용
                     데이터가 삽입(갱신)시 새롭게 들어오는
                     자료 지칭
                     DELETE 이벤트는 모두 NULL값
                     
       :OLD          DELETE, UPDATE 이벤트 발생시 사용
                     데이터가 삭제(갱신)시 이미 존재하고 있는
                     자료 지칭
                     INSERT 이벤트는 모두 NULL값
       -------------------------------------------------------
       
       - 트리거 함수 : 발생된 이벤트를 구분하기 위해 사용
       -------------------------------------------------------
       함수                의미
       -------------------------------------------------------
       INSERTING        이벤트가 INSERT 이면 참(true)반환
       UPDATING         이벤트가 UPDATE 이면 참(true)반환
       DELETING         이벤트가 DELETE 이면 참(true)반환
       
       
      CREATE TABLE PRODUCT(
        PROD_ID  VARCHAR2(6) PRIMARY KEY,
        PROD_NAME VARCHAR2(12),
        PROD_COM VARCHAR2(12),
        PROD_SALE  NUMBER(8),
        PROD_STOCKS NUMBER  DEFAULT 0);
        
      CREATE TABLE IPGO(
        IPGO_ID NUMBER(6) PRIMARY KEY,
        PROD_ID VARCHAR2(6)REFERENCES PRODUCT(PROD_ID),
        IPGO_DAY DATE DEFAULT SYSDATE,
        IPGO_QTY NUMBER(6),
        IPGO_COST NUMBER(8),
        IPGO_AMT NUMBER(8));
      
      INSERT INTO PRODUCT(PROD_ID,PROD_NAME,PROD_COM,PROD_SALE)
          VALUES('A00001','세탁기','LG',500);
      INSERT INTO PRODUCT(PROD_ID,PROD_NAME,PROD_COM,PROD_SALE)
          VALUES('A00002','컴퓨터','SAMSUNG',700);
      INSERT INTO PRODUCT(PROD_ID,PROD_NAME,PROD_COM,PROD_SALE)
          VALUES('A00003','냉장고','LG',600);       
          
      COMMIT;
      
트리거 사용예)입고테이블에 상품이 입고되면 상품테이블의 재고수량컬럼에
            재고수량이 추가되는 트리거 작성
            
      CREATE OR REPLACE TRIGGER TG_INSERT_IPGO
        AFTER INSERT ON IPGO
        FOR EACH ROW
      BEGIN
        UPDATE PRODUCT
           SET PROD_STOCKS=PROD_STOCKS+:NEW.IPGO_QTY
         WHERE PROD_ID=:NEW.PROD_ID;
      END;
      
      INSERT INTO IPGO VALUES(1,'A00002',SYSDATE,5,600,3000);
      INSERT INTO IPGO VALUES(2,'A00001',SYSDATE,10,500,5000);
      
      SELECT * FROM IPGO;
      SELECT * FROM PRODUCT;
      COMMIT;

사용예)이미 입고된 상품의 정보가 변경된 경우 상품테이블의 재고수량컬럼의
      값을 변경하는 트리거 작성
      
      CREATE OR REPLACE TRIGGER TG_UPDATE_IPGO
        AFTER UPDATE ON IPGO
        FOR EACH ROW
      BEGIN
        UPDATE PRODUCT
           SET PROD_STOCKS=PROD_STOCKS + :NEW.IPGO_QTY - :OLD.IPGO_QTY
         WHERE PROD_ID=:NEW.PROD_ID;
      END;
      
      UPDATE IPGO
         SET IPGO_QTY=IPGO_QTY+3
       WHERE PROD_ID='A00002';
       
      
      SELECT * FROM IPGO;
      SELECT * FROM PRODUCT;
      COMMIT;
      
      UPDATE IPGO
         SET IPGO_QTY=5
       WHERE PROD_ID='A00001';
       
      SELECT * FROM IPGO; 
      SELECT * FROM PRODUCT;

사용예)이미 입고된 상품의 정보를 삭제하는 경우 상품테이블의 재고수량컬럼의
      값을 변경하는 트리거 작성
      
      CREATE OR REPLACE TRIGGER TG_DELETE_IPGO
        AFTER DELETE ON IPGO
        FOR EACH ROW
      
      BEGIN
        UPDATE PRODUCT 
           SET PROD_STOCKS=PROD_STOCKS - :OLD.IPGO_QTY
         WHERE PROD_ID = :OLD.PROD_ID;
      END;
      
      DELETE
        FROM IPGO
       WHERE IPGO_ID=1;
       
      SELECT * FROM IPGO;
      SELECT * FROM PRODUCT;
      
      ROLLBACK;
      COMMIT;
      
    (트리거 함수 사용)
      CREATE OR REPLACE TRIGGER TG_IPGO
        AFTER INSERT OR UPDATE OR DELETE ON IPGO
        FOR EACH ROW
      DECLARE
        V_QTY NUMBER:=0;
        V_PROD_ID PRODUCT.PROD_ID%TYPE;
        
      BEGIN
        IF INSERTING THEN
            V_QTY := :NEW.IPGO_QTY;
            V_PROD_ID := :NEW.PROD_ID;
        ELSIF UPDATING THEN
            V_QTY := :NEW.IPGO_QTY - :OLD.IPGO_QTY;
            V_PROD_ID := :NEW.PROD_ID;
        ELSIF DELETING THEN
            V_QTY := -(:OLD.IPGO_QTY);
            V_PROD_ID := :OLD.PROD_ID;
        END IF;
        
        UPDATE PRODUCT
           SET PROD_STOCKS=PROD_STOCKS+V_QTY
         WHERE PROD_ID=V_PROD_ID;
      END;
    
*** 트리거 삭제
    DROP TRIGGER 트리거명
    DROP TRIGGER TG_INSERT_IPGO;
    DROP TRIGGER TG_UPDATE_IPGO; 
    DROP TRIGGER TG_DELETE_IPGO;
    
** 2021-12-03일 'A00001'을 10개 입고
    INSERT INTO IPGO VALUES(3,'A00001',TO_DATE('20211203'),10,500,5000);
    
    SELECT * FROM IPGO;
    SELECT * FROM PRODUCT;   

** 2021-12-02일 'A00001'의 입고 수량을 3개로 변경
    UPDATE IPGO
       SET IPGO_QTY=3,
           IPGO_AMT=1500
     WHERE PROD_ID='A00001'
       AND TO_DATE(IPGO_DAY,'YYYY/MM/DD')='2021/12/02';
       
**IPGO_ID가 2인 'A00001'의 자료를 삭제
    DELETE 
      FROM IPGO
     WHERE IPGO_ID=2;
     
     
    COMMIT;
    
