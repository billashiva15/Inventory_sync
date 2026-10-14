%dw 2.0
output application/java
---
payload map (row, index) -> do {
    var isSkuEmpty = isEmpty(row.sku)
    var isLocationEmpty = isEmpty(row.location)
    
    // Safely parse quantity and check numeric/non-negative rules
    var parsedQty = row.countedQty as Number default -1
    var isQtyValid = (row.countedQty matches /^[0-9]+$/) and (parsedQty >= 0)
    
    // Check if unitCost is a valid number
    var isCostValid = not isEmpty(row.unitCost as Number default null)
    
    // Determine validity and specific reason codes
    var isValid = not isSkuEmpty and not isLocationEmpty and isQtyValid and isCostValid
    var reasonCode = if (isSkuEmpty) "EMPTY_SKU"
                     else if (isLocationEmpty) "EMPTY_LOCATION"
                     else if (not isQtyValid) "INVALID_QUANTITY"
                     else if (not isCostValid) "INVALID_UNIT_COST"
                     else ""
    var reason = if (isSkuEmpty) "SKU cannot be empty"
                 else if (isLocationEmpty) "Location cannot be empty"
                 else if (not isQtyValid) "Quantity must be a non-negative integer"
                 else if (not isCostValid) "Unit cost must be a valid number"
                 else "Valid"
    ---
    {
        lineNumber: index + 2,
        sku: row.sku,
        location: row.location,
        countedQty: parsedQty,
        unitCost: row.unitCost as Number default 0.0,
        currency: row.currency,
        countedAt: row.countedAt,
        uom: row.uom,
        valid: isValid,
        reasonCode: reasonCode,
        reason: reason
    }
}