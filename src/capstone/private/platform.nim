type
  int8_t* = cschar
  int16_t* = cshort
  int32_t* = cint
  uint8_t* = uint8
  uint16_t* = cushort
  uint32_t* = cuint
  int64_t* = clonglong
  uint64_t* = culonglong

  GeneralEnum* = int32_t

converter toInt8*(x: int8_t): int8 = x.int8
converter toInt16*(x: int16_t): int16 = x.int16
converter toInt32*(x: int32_t): int32 = x.int32
converter toUInt16*(x: uint16_t): uint16 = x.uint16
converter toUInt32*(x: uint32_t): uint32 = x.uint32
converter toUInt64*(x: uint64_t): uint64 = x.uint64
converter toInt64*(x: int64_t): int64 = x.int64


## !!!Ignored construct:  d [NewLine] # PRIi8 __PRI_8_LENGTH_MODIFIER__ i [NewLine] # PRIo8 __PRI_8_LENGTH_MODIFIER__ o [NewLine] # PRIu8 __PRI_8_LENGTH_MODIFIER__ u [NewLine] # PRIx8 __PRI_8_LENGTH_MODIFIER__ x [NewLine] # PRIX8 __PRI_8_LENGTH_MODIFIER__ X [NewLine] # PRId16 hd [NewLine] # PRIi16 hi [NewLine] # PRIo16 ho [NewLine] # PRIu16 hu [NewLine] # PRIx16 hx [NewLine] # PRIX16 hX [NewLine] # defined ( _MSC_VER ) && _MSC_VER <= 1700 [NewLine] # PRId32 ld [NewLine] # PRIi32 li [NewLine] # PRIo32 lo [NewLine] # PRIu32 lu [NewLine] # PRIx32 lx [NewLine] # PRIX32 lX [NewLine] #  OSX # PRId32 d [NewLine] # PRIi32 i [NewLine] # PRIo32 o [NewLine] # PRIu32 u [NewLine] # PRIx32 x [NewLine] # PRIX32 X [NewLine] #  defined(_MSC_VER) && _MSC_VER <= 1700 [NewLine] # defined ( _MSC_VER ) && _MSC_VER <= 1700 [NewLine]  redefine functions from inttypes.h used in cstool # strtoull _strtoui64 [NewLine] # [NewLine] # PRId64 __PRI_64_LENGTH_MODIFIER__ d [NewLine] # PRIi64 __PRI_64_LENGTH_MODIFIER__ i [NewLine] # PRIo64 __PRI_64_LENGTH_MODIFIER__ o [NewLine] # PRIu64 __PRI_64_LENGTH_MODIFIER__ u [NewLine] # PRIx64 __PRI_64_LENGTH_MODIFIER__ x [NewLine] # PRIX64 __PRI_64_LENGTH_MODIFIER__ X [NewLine] # [NewLine]  this system has inttypes.h by default # < inttypes . h > [NewLine] #  defined(CAPSTONE_HAS_OSXKERNEL) || (defined(_MSC_VER) && (_MSC_VER <= 1700 || defined(_KERNEL_MODE))) [NewLine] # [NewLine]
## Error: expected ';'!!!
