package com.java.batchservice.settlement.domain;

import org.springframework.data.jpa.repository.JpaRepository;

public interface DailySettlementRepository extends JpaRepository<DailySettlement, Long> {
}