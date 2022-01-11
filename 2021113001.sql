2021-1130-01)INDEX 객체 --빠르게 찾기 위해서 사용
 - 데이터의 검색 효율을 증가 시키기 위한 객체
 - DBMS의 부하를 줄여 전체 DB의 성능을 향상
 - WHERE 조건 , GROUP BY의 기준컬럼,ORDER BY의 기준 컬럼등에 인덱스를 사용하면
   처리 속도를 증대 시킴
 - 별도의 기억공간과 자원이 소요됨
 - 인덱스의 종류 
 
   . Unique/Non-Unique
    - 중복값의 허용 여부에 따른 분류로 Unique인덱스인 경우 null을 하나만 허용
      (단, Primary 또는 Foreign 등에서는 허용 안됨)
      
   . Normal Index(B-Tree Index)
    - 기본인덱스
    - 컬럼 값과 rowid(물리적 위치정보)를  기반으로 주소계산
    
   . Bitmap Index --Bit가 Mapping되어서 사용
    - Cardinality가 적은경우 효율적인 인덱스
    - 컬럼값과 rowid(물리적 위치정보)를 이진자료로 변환하여 각 비트의
      조합으로 주소 산정
    - 데이터 변동이 심한 경우 비효율적

   . Function-Based Normal Index
    - 함수가 적용된 컬럼을 기준으로 인덱스 구성
    - 조건절에서 해당 함수가 그대로 사용 되는 경우 효율적
  (사용형식)
    CREATE [ UNIQUE|BITMAP] INDEX 인덱스명
      ON 테이블명(컬럼명1[,컬럼명2,....]) [ASC|DESC]
    . '테이블명' : 인덱스의 대상이되는 테이블
    . 'ASC|DESC' : 인덱스의 생성시 오름차순/내림차순으로 저장, default는 ASC
    
사용예)상품테이블에서 상품이름으로 기본 인덱스를 생성하시오.
      CREATE INDEX IDX_PROD_NAME
        ON PROD(PROD_NAME);
    **인덱스 삭제
      DROP INDEX 인덱스명;
      DROP INDEX IDX_PROD_NAME;
      
      SELECT * FROM PROD
       WHERE PROD_NAME='대우 VTR 6헤드';

사용예)장바구니테이블에서 상품코드로 기본 인덱스를 생성하시오.
      CREATE INDEX IDX_CART_PROD
        ON CART(CART_PROD);
        
      SELECT * FROM CART
       WHERE CART_PROD='P202000003';
       
사용예)멤버테이블에서 회원의 생년월일로 기본 인덱스를 생성하시오.
      CREATE INDEX IDX_MEM_BIR
        ON MEMBER(MEM_BIR);
      
      SELECT * FROM MEMBER
       WHERE MEM_BIR = TO_DATE('1976/05/06');

사용예)멤버테이블에서 회원의 주민번호 두번째 그룹 뒷자리 5자리로 인덱스를 생성하시오.
      CREATE INDEX IDX_MEM_REGNO
        ON MEMBER(SUBSTR(MEM_REGNO2,1,5));
        
 (인덱스 재구성)
  - 테이블과 인덱스가 파일의 저장위치가 변경된 경우(테이블 스페이스 변경)
  - 데이터의 변동(삽입/삭제 등)이 많이 발생된 경우
  
  (사용형식)
   ALTER INDEX 인덱스명 REBUILD;
   