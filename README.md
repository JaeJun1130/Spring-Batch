# Settlement Batch Project

간단한 Spring Batch 프로젝트로, 일별 정산 파일을 처리하여 데이터베이스에 저장하는 기능을 제공합니다.

---

## **프로젝트 구조**

```
.
├── java
│   └── com
│       └── java
│           └── batchservice
│               ├── BatchServiceApplication.java
│               ├── config
│               │   ├── BatchJobConfig.java
│               │   └── SchedulerConfig.java
│               ├── listener
│               │   └── JobCompletionListener.java
│               ├── scheduler
│               │   └── SettlementScheduler.java
│               └── settlement
│                   ├── SettlementProcessor.java
│                   ├── SettlementReader.java
│                   ├── SettlementWriter.java
│                   ├── data
│                   │   └── SettlementRecord.java
│                   └── domain
│                       ├── DailySettlement.java
│                       └── DailySettlementRepository.java
└── resources
    ├── application.yml
    ├── settlement.csv
    └── sql
        └── batch_init.sql

```
---

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/batch
    username: your_username
    password: your_password
    driver-class-name: com.mysql.cj.jdbc.Driver
  batch:
    jdbc:
      initialize-schema: always
```

---

## **스케줄러 실행**

Spring Scheduler를 사용하여 1분 간격으로 배치 작업이 실행되도록 설정합니다:

- `@Scheduled(cron = "0 * * * * *")`를 통해 스케줄링 설정.
- 스케줄링 설정 시 애플리케이션 실행 시점에 자동으로 배치 작업이 실행되지 않도록 `spring.batch.job.enabled=false`를 설정합니다.

---
