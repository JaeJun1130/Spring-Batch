package com.java.batchservice.listener;

import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.listener.JobExecutionListenerSupport;
import org.springframework.stereotype.Component;

@Component
public class JobCompletionListener extends JobExecutionListenerSupport {

    @Override
    public void afterJob(JobExecution jobExecution) {
        if (jobExecution.getStatus().isUnsuccessful()) {
            System.out.println("Job failed with status: " + jobExecution.getStatus());
        } else {
            System.out.println("Job completed successfully!");
            System.out.println("Start Time: " + jobExecution.getStartTime());
            System.out.println("End Time: " + jobExecution.getEndTime());
        }
    }

    @Override
    public void beforeJob(JobExecution jobExecution) {
        System.out.println("Job is starting...");
        System.out.println("Job Name: " + jobExecution.getJobInstance().getJobName());
        System.out.println("Start Time: " + jobExecution.getStartTime());
    }
}