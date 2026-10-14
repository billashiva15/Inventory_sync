%dw 2.0
output application/json

// Generate a safe idempotency key, handling potential nulls
var generatedIdempotencyKey = (payload.sku default "SKU") 
    ++ "-" ++ (payload.warehouseCode default "WH") 
    ++ "-" ++ (now() as String {format: "yyyyMMdd"})
---
{
    buyerCode: "NPN-RETAIL",
    supplierCode: payload.supplierCode,
    deliverToWarehouse: payload.warehouseCode,
    currency: payload.currency default "INR",
    // Formats date correctly to yyyy-MM-dd
    requestedDeliveryDate: ((now() + |P7D|) as Date) as String {format: "yyyy-MM-dd"},
    lines: [
        {
            sku: payload.sku,
            // Safe array navigation logic to prevent Null Pointer Exceptions
            supplierPartNumber: (vars.skuMaster default [])[0].supplier_part_number default "SUP-PART-01",
            // Safe type casting protecting against blanks/strings
            quantity: (payload.reorderQty default 0) as Number,
            uom: payload.uom,
            expectedUnitCost: (payload.unitCost default 0) as Number
        }
    ],
    idempotencyKey: generatedIdempotencyKey
}
