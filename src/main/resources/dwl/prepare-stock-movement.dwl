%dw 2.0
output application/java
var newQty = vars.currentRow.countedQty as Number
var prevQty = vars.previousQty as Number
---
{
    sku: vars.currentRow.sku,
    location: vars.currentRow.location,
    previousQty: prevQty,
    newQty: newQty,
    delta: newQty - prevQty,
    snapshotId: vars.snapshotId,
    correlationId: vars.sourceFileName
}