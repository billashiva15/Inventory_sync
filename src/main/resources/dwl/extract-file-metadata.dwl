%dw 2.0
output application/json
---
{
  fileName: vars.sourceFileName,
  correlationId: vars.correlationId,
  status: "PARALLEL_INIT_COMPLETE",
  timestamp: now()
}