%dw 2.0
output application/java
---
(vars.acceptedDatabaseRows default []) map (row) -> {
    sku: row.sku,
    location: row.location,
    qty: row.countedQty as Number,
    unitCost: row.unitCost as Number,
    countedAt: row.countedAt,
    snapshotId: vars.snapshotId,
    correlationId: vars.sourceFileName
}