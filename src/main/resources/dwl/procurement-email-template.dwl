%dw 2.0
output application/json
---
{
    to: "procurement@npn.example.com",
    cc: "category.managers@npn.example.com",
    from: "inventory-integration@npn.example.com",
    subject: "Low stock – " ++ (vars.skuCount default 0) ++ " SKUs, " ++ (vars.supplierCount default 0) ++ " suppliers",
    body: "Low stock position as at " ++ (vars.runTime default now() as String {format: "yyyy-MM-dd HH:mm:ss"}) ++ "\n\n" ++
          "SUMMARY\n" ++
          " SKUs at or below reorder point : " ++ (vars.skuCount default 0) ++ "\n" ++
          " New purchase orders raised : " ++ (vars.poRaisedCount default 0) ++ "\n" ++
          " Suppressed (order already open): " ++ (vars.suppressedCount default 0) ++ "\n" ++
          " Failed supplier calls : " ++ (vars.failedCount default 0) ++ "\n\n" ++
          (vars.suppliers map ((sup) -> 
              "SUPPLIER " ++ sup.supplierCode ++ " – " ++ sup.supplierName ++ "\n" ++
              " SKU          AVAIL   ROP     ORDER   OPEN PO   STATUS\n" ++
              (sup.lines map ((l) -> 
                  " " ++ l.sku ++ "   " ++ l.availableQty ++ "   " ++ l.reorderPoint ++ "   order " ++ l.reorderQty ++ "   " ++ (l.openPo default "none") ++ "   " ++ l.status
              ) joinBy "\n")
          ) joinBy "\n\n") ++ 
          (if (!isEmpty(vars.failures) and (vars.failedCount default 0) > 0) 
              "\n\nFAILED SUPPLIER CALLS – action needed\n" ++
              (vars.failures map ((f) -> 
                  " " ++ f.sku ++ " / " ++ f.supplierCode ++ " : " ++ f.reasonCode ++ "\n " ++ f.reason
              ) joinBy "\n")
          else "") ++ "\n\n" ++
          "Source snapshots in this window\n" ++
          (vars.snapshots map ((s) -> 
              " " ++ s.fileName ++ " " ++ s.warehouseCode ++ " " ++ s.acceptedRows ++ " rows"
          ) joinBy "\n") ++ "\n\n" ++
          "Full position: " ++ (vars.stockDashboardUrl default "http://localhost:8081/dashboard") ++ "\n" ++
          "-- Inventory Integration"
}
