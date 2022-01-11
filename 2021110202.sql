2021-1102-01)사용자 등록
1)계정생성(사용자 생성)
 - 오라클 사용자 계정 생성
 - 오라클 사용자는 객체(object)로 취급
 (사용형식)

 CREATE USER jsc96 IDENTIFIED BY 암호;
-$는 대도록 쓰지말자 system과 충돌
-문자는 대도록 영어로

-삭제 
DROP 사용자명
 
 CREATE USER jsc96 IDENTIFIED BY java;
 
 2)권한부여
 - 생성된 사용자의 수행 범위 지정
 (사용형식)
 GRANT 권한명1[,권한명2,......] TO 계정명;
 
 GRANT CONNECT,RESOURCE,DBA TO jsc96
 
 3)파일 열기 
d드라이브>b유틸>설치>오라클>base>784줄까지

4)HR계정 활성화
- HR계정의 잠금 상태를 활성화 상태로 변경
ALTER USER 계정명 ACCOUNT UNLOCK;
-계정명에 HR계정명 기술
ALTER USER HR ACCOUNT UNLOCK;
-암호변경
ALTER USER 유저명 IDENTIFIED BY 암호;

ALTER USER HR IDENTIFIED BY java;
