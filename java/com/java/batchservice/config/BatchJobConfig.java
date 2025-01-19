package com.java.batchservice.config;

import com.java.batchservice.settlement.SettlementProcessor;
import com.java.batchservice.settlement.SettlementReader;
import com.java.batchservice.settlement.SettlementWriter;
import com.java.batchservice.settlement.data.SettlementRecord;
import com.java.batchservice.settlement.domain.DailySettlement;
import lombok.RequiredArgsConstructor;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
@RequiredArgsConstructor
public class BatchJobConfig {
    private final JobRepository jobRepository;
    private final PlatformTransactionManager transactionManager;

    private final SettlementReader reader;
    private final SettlementProcessor processor;
    private final SettlementWriter writer;

    @Bean
    public Job settlementJob(Step settlementStep) {
        return new JobBuilder("settlementJob", jobRepository)
                .start(settlementStep)
                .build();
    }

    @Bean
    public Step settlementStep() {
        return new StepBuilder("settlementStep", jobRepository)
                .<SettlementRecord, DailySettlement>chunk(5, transactionManager)
                .reader(reader.createReader())
                .processor(processor)
                .writer(writer.createWriter())
                .build();
    }
}