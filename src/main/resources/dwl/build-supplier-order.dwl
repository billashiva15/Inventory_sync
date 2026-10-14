%dw 2.0
output application/json
var generatedIdempotencyKey = (payload.sku default "SKU") ++ "-" ++ (payload.warehouseCode default "WH") ++ "-" ++ (now() as String {format: "yyyyMMdd"})
---
{
    buyerCode: "NPN-RETAIL",
    supplierCode: payload.supplierCode,
    deliverToWarehouse: payload.warehouseCode,
    currency: payload.currency default "INR",
    requestedDeliveryDate: (now() + |P7D|) as String {format: "yyyy-MM-dd"},
    lines: [
        {
            sku: payload.sku,
            supplierPartNumber: vars.skuMaster[0].supplier_part_number default "SUP-PART-01",
            quantity: payload.reorderQty as Number,
            uom: payload.uom,
            expectedUnitCost: payload.unitCost as Number
        }
    ],
    idempotencyKey: generatedIdempotencyKey
}