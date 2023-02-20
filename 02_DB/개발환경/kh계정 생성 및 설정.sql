-- 오라클 11G 이전 버전의 SQL 작성을 가능하게 하는 구문.
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- C## : 일반 사용자(사용자 계정을 의미)

-- 계정 생성
CREATE USER C##kh IDENTIFIED BY kh1234;
CREATE USER kh IDENTIFIED BY kh1234;

-- 접속, 기본 객체 생성 권한
GRANT CONNECT, RESOURCE TO C##kh;
GRANT CONNECT, RESOURCE TO kh;

-- 객체가 생성될 수 있는 공간 할당량 지정
-- alter user [유저명] default tablespace [테이블스페이스] quota unlimited on [테이블스페이스];
ALTER USER C##kh DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
ALTER USER kh DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;