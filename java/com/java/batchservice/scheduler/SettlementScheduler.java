package com.java.batchservice.scheduler;

import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class SettlementScheduler {
    private final JobLauncher jobLauncher;
    private final Job myJob;

    public SettlementScheduler(JobLauncher jobLauncher, @Qualifier("settlementJob") Job myJob) {
        this.jobLauncher = jobLauncher;
        this.myJob = myJob;
    }

    @Scheduled(cron = "0 * * * * *") // 매 1분마다 실행
    public void runJob() throws Exception {
        log.info("SettlementScheduler Running job {}", myJob.getName());

        JobParameters params = new JobParametersBuilder()
                .addLong("time", System.currentTimeMillis()) // 고유한 파라미터
                .toJobParameters();

        jobLauncher.run(myJob, params);
    }
}
