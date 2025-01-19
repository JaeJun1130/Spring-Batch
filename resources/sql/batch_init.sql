-- 테이블: BATCH_JOB_INSTANCE
-- Spring Batch에서 실행되는 Job 인스턴스를 관리하는 테이블입니다.
-- 각 Job 인스턴스는 고유하며, 동일한 Job도 파라미터에 따라 다른 인스턴스로 구분됩니다.
CREATE TABLE BATCH_JOB_INSTANCE
(
    JOB_INSTANCE_ID BIGINT       NOT NULL PRIMARY KEY, -- Job 인스턴스의 고유 ID
    VERSION         BIGINT,                            -- 버전 관리 (낙관적 잠금에 사용)
    JOB_NAME        VARCHAR(100) NOT NULL,             -- Job 이름
    JOB_KEY         VARCHAR(32)  NOT NULL,             -- Job 파라미터 기반의 고유 키
    constraint JOB_INST_UN unique (JOB_NAME, JOB_KEY)  -- Job 이름과 키의 고유성 보장
) ENGINE=InnoDB;

-- 테이블: BATCH_JOB_EXECUTION
-- Job 실행 정보를 저장하는 테이블입니다. Job의 상태, 시작/종료 시간 등을 기록합니다.
CREATE TABLE BATCH_JOB_EXECUTION
(
    JOB_EXECUTION_ID BIGINT NOT NULL PRIMARY KEY,       -- Job 실행의 고유 ID
    VERSION          BIGINT,                            -- 버전 관리
    JOB_INSTANCE_ID  BIGINT NOT NULL,                   -- 실행된 Job 인스턴스의 ID
    CREATE_TIME      DATETIME(6) NOT NULL,              -- Job 실행 생성 시간
    START_TIME       DATETIME(6) DEFAULT NULL,          -- Job 실행 시작 시간
    END_TIME         DATETIME(6) DEFAULT NULL,          -- Job 실행 종료 시간
    STATUS           VARCHAR(10),                       -- 실행 상태 (STARTED, COMPLETED 등)
    EXIT_CODE        VARCHAR(2500),                     -- Job 종료 코드
    EXIT_MESSAGE     VARCHAR(2500),                     -- Job 종료 메시지
    LAST_UPDATED     DATETIME(6),                       -- 마지막 업데이트 시간
    constraint JOB_INST_EXEC_FK foreign key (JOB_INSTANCE_ID)
        references BATCH_JOB_INSTANCE (JOB_INSTANCE_ID) -- BATCH_JOB_INSTANCE와 연관
) ENGINE=InnoDB;

-- 테이블: BATCH_JOB_EXECUTION_PARAMS
-- Job 실행에 전달된 파라미터 정보를 저장합니다.
CREATE TABLE BATCH_JOB_EXECUTION_PARAMS
(
    JOB_EXECUTION_ID BIGINT       NOT NULL,               -- 관련 Job 실행 ID
    PARAMETER_NAME   VARCHAR(100) NOT NULL,               -- 파라미터 이름
    PARAMETER_TYPE   VARCHAR(100) NOT NULL,               -- 파라미터 타입 (STRING, LONG 등)
    PARAMETER_VALUE  VARCHAR(2500),                       -- 파라미터 값
    IDENTIFYING      CHAR(1)      NOT NULL,               -- Job 인스턴스를 식별하는 데 사용 여부
    constraint JOB_EXEC_PARAMS_FK foreign key (JOB_EXECUTION_ID)
        references BATCH_JOB_EXECUTION (JOB_EXECUTION_ID) -- BATCH_JOB_EXECUTION과 연관
) ENGINE=InnoDB;

-- 테이블: BATCH_STEP_EXECUTION
-- Step 실행 정보를 저장하는 테이블입니다.
CREATE TABLE BATCH_STEP_EXECUTION
(
    STEP_EXECUTION_ID  BIGINT       NOT NULL PRIMARY KEY, -- Step 실행의 고유 ID
    VERSION            BIGINT       NOT NULL,             -- 버전 관리
    STEP_NAME          VARCHAR(100) NOT NULL,             -- Step 이름
    JOB_EXECUTION_ID   BIGINT       NOT NULL,             -- 관련 Job 실행 ID
    CREATE_TIME        DATETIME(6) NOT NULL,              -- Step 실행 생성 시간
    START_TIME         DATETIME(6) DEFAULT NULL,          -- Step 실행 시작 시간
    END_TIME           DATETIME(6) DEFAULT NULL,          -- Step 실행 종료 시간
    STATUS             VARCHAR(10),                       -- 실행 상태
    COMMIT_COUNT       BIGINT,                            -- 커밋 횟수
    READ_COUNT         BIGINT,                            -- 읽은 데이터 개수
    FILTER_COUNT       BIGINT,                            -- 필터링된 데이터 개수
    WRITE_COUNT        BIGINT,                            -- 쓴 데이터 개수
    READ_SKIP_COUNT    BIGINT,                            -- 읽기 스킵된 데이터 개수
    WRITE_SKIP_COUNT   BIGINT,                            -- 쓰기 스킵된 데이터 개수
    PROCESS_SKIP_COUNT BIGINT,                            -- 처리 중 스킵된 데이터 개수
    ROLLBACK_COUNT     BIGINT,                            -- 롤백 횟수
    EXIT_CODE          VARCHAR(2500),                     -- Step 종료 코드
    EXIT_MESSAGE       VARCHAR(2500),                     -- Step 종료 메시지
    LAST_UPDATED       DATETIME(6),                       -- 마지막 업데이트 시간
    constraint JOB_EXEC_STEP_FK foreign key (JOB_EXECUTION_ID)
        references BATCH_JOB_EXECUTION (JOB_EXECUTION_ID) -- BATCH_JOB_EXECUTION과 연관
) ENGINE=InnoDB;

-- 테이블: BATCH_STEP_EXECUTION_CONTEXT
-- Step 실행 중 생성된 컨텍스트 데이터를 저장합니다.
CREATE TABLE BATCH_STEP_EXECUTION_CONTEXT
(
    STEP_EXECUTION_ID  BIGINT        NOT NULL PRIMARY KEY,  -- 관련 Step 실행 ID
    SHORT_CONTEXT      VARCHAR(2500) NOT NULL,              -- 컨텍스트 데이터 요약
    SERIALIZED_CONTEXT TEXT,                                -- 직렬화된 컨텍스트 데이터
    constraint STEP_EXEC_CTX_FK foreign key (STEP_EXECUTION_ID)
        references BATCH_STEP_EXECUTION (STEP_EXECUTION_ID) -- BATCH_STEP_EXECUTION과 연관
) ENGINE=InnoDB;

-- 테이블: BATCH_JOB_EXECUTION_CONTEXT
-- Job 실행 중 생성된 컨텍스트 데이터를 저장합니다.
CREATE TABLE BATCH_JOB_EXECUTION_CONTEXT
(
    JOB_EXECUTION_ID   BIGINT        NOT NULL PRIMARY KEY, -- 관련 Job 실행 ID
    SHORT_CONTEXT      VARCHAR(2500) NOT NULL,             -- 컨텍스트 데이터 요약
    SERIALIZED_CONTEXT TEXT,                               -- 직렬화된 컨텍스트 데이터
    constraint JOB_EXEC_CTX_FK foreign key (JOB_EXECUTION_ID)
        references BATCH_JOB_EXECUTION (JOB_EXECUTION_ID)  -- BATCH_JOB_EXECUTION과 연관
) ENGINE=InnoDB;

-- 테이블: BATCH_STEP_EXECUTION_SEQ
-- Step 실행의 고유 ID를 생성하는 시퀀스 테이블입니다.
CREATE TABLE BATCH_STEP_EXECUTION_SEQ
(
    ID         BIGINT  NOT NULL, -- Step 실행 ID 시퀀스
    UNIQUE_KEY CHAR(1) NOT NULL, -- 고유 키
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ENGINE=InnoDB;

INSERT INTO BATCH_STEP_EXECUTION_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from BATCH_STEP_EXECUTION_SEQ);

-- 테이블: BATCH_JOB_EXECUTION_SEQ
-- Job 실행의 고유 ID를 생성하는 시퀀스 테이블입니다.
CREATE TABLE BATCH_JOB_EXECUTION_SEQ
(
    ID         BIGINT  NOT NULL, -- Job 실행 ID 시퀀스
    UNIQUE_KEY CHAR(1) NOT NULL, -- 고유 키
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ENGINE=InnoDB;

INSERT INTO BATCH_JOB_EXECUTION_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from BATCH_JOB_EXECUTION_SEQ);

-- 테이블: BATCH_JOB_SEQ
-- Job 인스턴스의 고유 ID를 생성하는 시퀀스 테이블입니다.
CREATE TABLE BATCH_JOB_SEQ
(
    ID         BIGINT  NOT NULL, -- Job 인스턴스 ID 시퀀스
    UNIQUE_KEY CHAR(1) NOT NULL, -- 고유 키
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ENGINE=InnoDB;

INSERT INTO BATCH_JOB_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from BATCH_JOB_SEQ);