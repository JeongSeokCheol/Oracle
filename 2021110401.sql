2021-1104-01)
 2)숫자열 형
  - 실수 또는정수를 저장하는 자료형
  - NUMBER 타입만 제공됨
 (사용형식)
  컬럼명 NUMBER[(*|정밀도[,스케일])]
  . '*|정밀도' : 전체 자리수(1~30사이 정수)
     '*'를 사용하면 시스템에게 자리수 결정을 위임
  . '스케일' : 소숫점 이하의 자리수
  . 표현범위 : 1.0 x E-130 ~ 9.9999... E+125(소숫점이하'9'의 갯수 38개)
  . 자료의 저장
    - 스케일이 양수인 경우 : 저장하려는 자료의 소숫점이하 (스케일 + 1)자리에서 
                           반올림하여 (스케일)자리수 만큼 저장
                           ex) 21.1234567 > NUMBER(7,4) > 21.1235
    - 스케일이 음수인 경우 : 정수부분에서 (스케일)위치의 정수 부분에서 반올림
                           ex) 12345.6789 > NUMBER(7,-1) > 12350
  .ex)
  -----------------------------------------------------------------------
   타입 선언      데이터               저장되는값
   ----------------------------------------------------------------------
   NUMBER        12345.9876          12345.9876
   NUMBER(*,3)   12345.9876          12345.988
   NUMBER(4)     12345.9876          ERROR(오류 : 정수자리수 부족)
   NUMBER(7,3)   12345.9876          ERROR
   NUMBER(10,2)  12345.9876             12345.99(앞에3개의 공백이 생김)
   NUMBER(7,0)   12345.9876            12346   
   NUMBER(7)     12345.9876            12346 
   ----------------------------------------------------------------------
   
   사용예)CREATE TABLE TEMP5(
          COL1 NUMBER,
          COL2 NUMBER(*,3),
          COL3 NUMBER(4),
          COL4 NUMBER(7,3),
          COL5 NUMBER(10,2),
          COL6 NUMBER(7,0),
          COL7 NUMBER(7)
          );
          
          INSERT INTO TEMP5
           VALUES(12345.9876,
                 12345.9876,
                 2345.9876,
                 2345.9876,
                 12345.9876,
                 12345.9876,
                 12345.9876);
                 
        SELECT * FROM TEMP5;
        
    **정밀도 < 스케일
     . 정밀도는 '0'이아닌 유효숫자의 수
     . 스케일 : 소숫점이하의 자리수
     . 스케일 - 정밀도 : 소숫점이하에 맨 먼저 나와야할 '0'의 갯수
    ex) 
-------------------------------------------------------------------------
    입력값       선언             기억되는값
-------------------------------------------------------------------------
    0.12345     NUMBER(3,5)      오류
    0.012345    NUMBER(4,5)      0.01235 
    0.0012345   NUMBER(3,5)      0.00123             
    1.23        NUMBER(1,3)      오류              
    0.012       NUMBER(2,5)      오류            
--------------------------------------------------------------------------
                       