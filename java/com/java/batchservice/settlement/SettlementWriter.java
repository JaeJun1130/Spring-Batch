package com.java.batchservice.settlement;

import com.java.batchservice.settlement.domain.DailySettlement;
import com.java.batchservice.settlement.domain.DailySettlementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.batch.item.data.RepositoryItemWriter;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class SettlementWriter {
    private final DailySettlementRepository repository;

    public RepositoryItemWriter<DailySettlement> createWriter() {
        RepositoryItemWriter<DailySettlement> writer = new RepositoryItemWriter<>();
        writer.setRepository(repository);
        writer.setMethodName("save");

        return writer;
    }
}