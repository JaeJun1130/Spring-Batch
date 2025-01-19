package com.java.batchservice.settlement;

import com.java.batchservice.settlement.data.SettlementRecord;
import com.java.batchservice.settlement.domain.DailySettlement;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.stereotype.Component;

@Component
public class SettlementProcessor implements ItemProcessor<SettlementRecord, DailySettlement> {

    @Override
    public DailySettlement process(SettlementRecord item) {
        DailySettlement settlement = new DailySettlement();
        settlement.setDate(item.date());
        settlement.setTotalAmount(item.amount());

        return settlement;
    }
}
