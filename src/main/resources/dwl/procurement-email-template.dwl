%dw 2.0
output application/json
---
{
    to: "billashiva6606@gmail.com",
    cc: "billashiva15@gmail.com",
    from: "billashiva15@gmail.com",
    subject: "Low stock - " ++ (vars.skuCount default 0 as String) ++ " SKUs, " ++ (vars.supplierCount default 0 as String) ++ " suppliers",
    body: "Low stock position as at " ++ (vars.runTime default now() as String {format: "yyyy-MM-dd HH:mm:ss"}) ++ "\n\n" ++
          "SUMMARY\n" ++
          " SKUs at or below reorder point : " ++ (vars.skuCount default 0 as String) ++ "\n" ++
          " New purchase orders raised : " ++ (vars.poRaisedCount default 0 as String) ++ "\n" ++
          " Suppressed (order already open): " ++ (vars.suppressedCount default 0 as String) ++ "\n" ++
          " Failed supplier calls : " ++ (vars.failedCount default 0 as String) ++ "\n\n" ++
          ((vars.suppliers default []) map ((sup) -> 
              "SUPPLIER " ++ (sup.supplierCode default "") ++ " - " ++ (sup.supplierName default "") ++ "\n" ++
              " SKU          AVAIL   ROP     ORDER   OPEN PO   STATUS\n" ++
              ((sup.lines default []) map ((l) -> 
                  " " ++ (l.sku default "") ++ "   " ++ (l.availableQty default 0 as String) ++ "   " ++ (l.reorderPoint default 0 as String) ++ "   order " ++ (l.reorderQty default 0 as String) ++ "   " ++ (l.openPo default "none") ++ "   " ++ (l.status default "")
              ) joinBy "\n")
          ) joinBy "\n\n") ++ 
          (if (!isEmpty(vars.failures default []) and (vars.failedCount default 0) > 0) 
              "\n\nFAILED SUPPLIER CALLS - action needed\n" ++
              ((vars.failures default []) map ((f) -> 
                  " " ++ (f.sku default "") ++ " / " ++ (f.supplierCode default "") ++ " : " ++ (f.reasonCode default "") ++ "\n " ++ (f.reason default "")
              ) joinBy "\n")
          else "") ++ "\n\n" ++
          "Source snapshots in this window\n" ++
          ((vars.snapshots default []) map ((s) -> 
              " " ++ (s.fileName default "") ++ " " ++ (s.warehouseCode default "") ++ " " ++ (s.acceptedRows default 0 as String) ++ " rows"
          ) joinBy "\n") ++ "\n\n" ++
          "Full position: " ++ (vars.stockDashboardUrl default "http://localhost:8081/dashboard") ++ "\n" ++
          "-- Inventory Integration"
}