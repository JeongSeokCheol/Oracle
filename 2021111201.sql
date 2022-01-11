2021-1112-01)
  6)WIDTH_BUCKET(n,min,max,b)
   - 주어진 구간의 하한값(min)과 상한값(max)를 b 개의 구간으로 나눌때
     값 n이 어느 구간에 속하는지를 판별하여 구간의 순번을 반환해 줌.
사용예)SELECT WIDTH_BUCKET(56,0,100,10),
             WIDTH_BUCKET(100,0,100,10),
             WIDTH_BUCKET(0,0,100,10),
             WIDTH_BUCKET(-120,0,100,10)
        FROM DUAL;
        
사용예)마일리지 값의 범위를 1000-8000 으로 설정하고 이 범위를 8개의 구간으로 설정하여
      회원들의 마일리지가어느 구간에 속하는지 판별하는 쿼리를 작성 하시오
      Alias는 회원번호,회원명,마일리지,구간값
      단, 구간값은 많은 마일리지는 작은 구간값을 갖도록 설계하시오
      SELECT MEM_ID AS 회원번호,
             MEM_NAME AS 회원명,
             MEM_MILEAGE AS 마일리지,
             WIDTH_BUCKET(MEM_MILEAGE,1000,8000,8) AS 구간값1,
             WIDTH_BUCKET(MEM_MILEAGE,8000,999,8)||'등급' AS 구간값2,
             9-WIDTH_BUCKET(MEM_MILEAGE,1000,8000,8) AS 구간값3
        FROM MEMBER;
        
        
        
        
      