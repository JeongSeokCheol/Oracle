2021-1126-01)

사용예)2005년 1월 상품별 입고수량을 재고수불테이블을 갱신하시오.
      날짜는 2005년 1월 31일이다
      
      (서브쿼리:2005년 1월 상품별 입고수량집계)
       SELECT BUY_PROD,
              SUM(BUY_QTY)
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY BUY_PROD
        
      (메인쿼리 : 재고수불테이블 갱신)
       UPDATE REMAIN A
          SET (A.REMAIN_I,A.REMAIN_J_99,A.REMAIN_DATE)=
              (SELECT A.REMAIN_I+B.BSUM,
                      A.REMAIN_J_99+B.BSUM,
                      TO_DATE('20050131')
                 FROM (SELECT BUY_PROD,
                            SUM(BUY_QTY) AS BSUM
                           FROM BUYPROD
                          WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
                          GROUP BY BUY_PROD) B
                WHERE B.BUY_PROD=A.PROD_ID)
       WHERE A.REMAIN_YEAR='2005'
         AND A.PROD_ID IN (SELECT DISTINCT BUY_PROD
                             FROM BUYPROD
                            WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131'));
                            
    COMMIT;
    
사용예)2005년 4월 매출집계를 조회하여 재고수불테이블을 갱신하시오.
      (2005년 4월 제품별 매출수량 집계)
      SELECT CART_PROD AS CID,
             SUM(CART_QTY) AS CSUM
        FROM CART 
       WHERE CART_NO LIKE '200504%'
       GROUP BY CART_PROD
       
      UPDATE REMAIN A
         SET (A.REMAIN_O, A.REMAIN_J_99, A.REMAIN_DATE)=
             (SELECT A.REMAIN_O+B.CSUM, A.REMAIN_J_99-B.CSUM,TO_DATE('20050430')
                FROM (SELECT CART_PROD AS CID,
                            SUM(CART_QTY) AS CSUM
                        FROM CART 
                       WHERE CART_NO LIKE '200504%'
                     GROUP BY CART_PROD)B
               WHERE A.PROD_ID=B.CID)           
      WHERE A.REMAIN_YEAR='2005'
        AND A.PROD_ID IN (SELECT CART_PROD
                            FROM CART
                           WHERE CART_NO LIKE '200504%')
               
             