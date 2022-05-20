type
  cs_ac_type* {.pure.} = enum
    INVALID = 0
    READ = 1 shl 0
    WRITE = 1 shl 1
