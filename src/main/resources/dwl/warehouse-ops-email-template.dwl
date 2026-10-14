%dw 2.0
output application/json
---
{
    to: "warehouse.ops@npn.example.com",
    from: "inventory-integration@npn.example.com",
    subject: "Stock load " ++ (payload.loadStatus default "SUCCESS") ++ " – " ++ (vars.sourceFileName default "unknown"),
    body: "File : " ++ (vars.sourceFileName default "unknown") ++ "\n" ++
          "Warehouse : " ++ (vars.warehouseCode default "UNKNOWN") ++ "\n" ++
          "Snapshot time : " ++ (vars.snapshotTs default now() as String {format: "yyyy-MM-dd'T'HH:mm:ss"}) ++ "\n" ++
          "Status : " ++ (payload.loadStatus default "SUCCESS") ++ "\n" ++
          "Rows read : " ++ (payload.totalRows default 0) ++ "\n" ++
          "Rows applied : " ++ (payload.acceptedRows default 0) ++ "\n" ++
          "Rows rejected : " ++ (payload.rejectedRows default 0) ++ "\n" ++
          "SKUs changed : " ++ (payload.skusChanged default 0) ++ "\n" ++
          "Reorder events : " ++ (payload.reorderEvents default 0) ++ "\n" ++
          (if ((payload.rejectedRows default 0) > 0) 
              "\nRejected rows are listed in\n " ++ (vars.rejectsPath default "C:\\data\\inventory\\rejects\\") ++ "\n" ++
              "Top reasons\n" ++
              (payload.rejectReasons map ((rr) -> 
                  " " ++ rr.reasonCode ++ " : " ++ rr.count
              ) joinBy "\n")
          else "") ++ "\n\n" ++
          "Archived to : " ++ (vars.archivePath default "C:\\data\\inventory\\archive\\") ++ "\n" ++
          "Correlation : " ++ (vars.correlationId default "N/A")
}