package com.java.batchservice.settlement;

import com.java.batchservice.settlement.data.SettlementRecord;
import org.springframework.batch.item.file.FlatFileItemReader;
import org.springframework.batch.item.file.builder.FlatFileItemReaderBuilder;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

@Component
public class SettlementReader {

    public FlatFileItemReader<SettlementRecord> createReader() {
        return new FlatFileItemReaderBuilder<SettlementRecord>()
                .name("settlementReader")
                .resource(new ClassPathResource("settlement.csv")) // CSV 파일 경로
                .delimited()
                .names("date", "amount") // CSV 헤더 열 이름
                .fieldSetMapper(fieldSet -> new SettlementRecord(
                        fieldSet.readString("date"),
                        fieldSet.readLong("amount")
                )).build();
    }
}