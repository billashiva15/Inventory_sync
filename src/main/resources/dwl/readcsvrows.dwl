%dw 2.0
output application/java
import * from dw::core::Strings

// Reusable function to format the row object
fun formatRow(row) = {
    sku: trim(row.sku default ""),
    location: trim(row.location default ""),
    countedQty: trim(row.countedQty default ""),
    unitCost: trim(row.unitCost default ""),
    currency: trim(row.currency default ""),
    countedAt: trim(row.countedAt default ""),
    uom: trim(row.uom default "")
}
---
if (isEmpty(payload)) 
    []
else 
    payload match {
        case data is Array -> data map ((row) -> formatRow(row))
        case data is String -> (read(data, "application/csv", { header: true, separator: "," }) default []) map ((row) -> formatRow(row))
        case data is Binary -> (read(data, "application/csv", { header: true, separator: "," }) default []) map ((row) -> formatRow(row))
        else -> []
    }