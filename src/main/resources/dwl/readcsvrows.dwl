%dw 2.0
output application/java
---
if (isEmpty(payload)) 
    []
else 
    payload match {
        case is Array -> payload map ((row) -> {
            sku: trim(row.sku default ""),
            location: trim(row.location default ""),
            countedQty: trim(row.countedQty default ""),
            unitCost: trim(row.unitCost default ""),
            currency: trim(row.currency default ""),
            countedAt: trim(row.countedAt default ""),
            uom: trim(row.uom default "")
        })
        case is String -> read(payload, "application/csv", { header: true, separator: "," }) map ((row) -> {
            sku: trim(row.sku default ""),
            location: trim(row.location default ""),
            countedQty: trim(row.countedQty default ""),
            unitCost: trim(row.unitCost default ""),
            currency: trim(row.currency default ""),
            countedAt: trim(row.countedAt default ""),
            uom: trim(row.uom default "")
        })
        case is Binary -> read(payload, "application/csv", { header: true, separator: "," }) map ((row) -> {
            sku: trim(row.sku default ""),
            location: trim(row.location default ""),
            countedQty: trim(row.countedQty default ""),
            unitCost: trim(row.unitCost default ""),
            currency: trim(row.currency default ""),
            countedAt: trim(row.countedAt default ""),
            uom: trim(row.uom default "")
        })
        else -> []
    }