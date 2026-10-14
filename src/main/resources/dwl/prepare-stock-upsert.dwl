%dw 2.0
output application/java
---
{
    sku: vars.currentRow.sku,
    location: vars.currentRow.location,
    qty: vars.currentRow.countedQty as Number,
    unitCost: vars.currentRow.unitCost as Number,
    countedAt: vars.currentRow.countedAt,
    snapshotId: vars.snapshotId
}