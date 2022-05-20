

const
  INT8_MIN* = (-127'i8 - 1)
  INT16_MIN* = (-32767'i16 - 1)
  INT32_MIN* = (-2147483647'i32 - 1)
  INT64_MIN* = (-9223372036854775807'i64 - 1)
  INT8_MAX* = 127'i8
  INT16_MAX* = 32767'i16
  INT32_MAX* = 2147483647'i32
  INT64_MAX* = 9223372036854775807'i64
  UINT8_MAX* = 0xff'u8
  UINT16_MAX* = 0xffff'u16
  UINT32_MAX* = 0xffffffff'u32
  UINT64_MAX* = 0xffffffffffffffff'u64

type
  int8_t* = cschar
  int16_t* = cshort
  int32_t* = cint
  uint8_t* = cuchar
  uint16_t* = cushort
  uint32_t* = cuint
  int64_t* = clonglong
  uint64_t* = culonglong

## !!!Ignored construct:  d [NewLine] # PRIi8 __PRI_8_LENGTH_MODIFIER__ i [NewLine] # PRIo8 __PRI_8_LENGTH_MODIFIER__ o [NewLine] # PRIu8 __PRI_8_LENGTH_MODIFIER__ u [NewLine] # PRIx8 __PRI_8_LENGTH_MODIFIER__ x [NewLine] # PRIX8 __PRI_8_LENGTH_MODIFIER__ X [NewLine] # PRId16 hd [NewLine] # PRIi16 hi [NewLine] # PRIo16 ho [NewLine] # PRIu16 hu [NewLine] # PRIx16 hx [NewLine] # PRIX16 hX [NewLine] # defined ( _MSC_VER ) && _MSC_VER <= 1700 [NewLine] # PRId32 ld [NewLine] # PRIi32 li [NewLine] # PRIo32 lo [NewLine] # PRIu32 lu [NewLine] # PRIx32 lx [NewLine] # PRIX32 lX [NewLine] #  OSX # PRId32 d [NewLine] # PRIi32 i [NewLine] # PRIo32 o [NewLine] # PRIu32 u [NewLine] # PRIx32 x [NewLine] # PRIX32 X [NewLine] #  defined(_MSC_VER) && _MSC_VER <= 1700 [NewLine] # defined ( _MSC_VER ) && _MSC_VER <= 1700 [NewLine]  redefine functions from inttypes.h used in cstool # strtoull _strtoui64 [NewLine] # [NewLine] # PRId64 __PRI_64_LENGTH_MODIFIER__ d [NewLine] # PRIi64 __PRI_64_LENGTH_MODIFIER__ i [NewLine] # PRIo64 __PRI_64_LENGTH_MODIFIER__ o [NewLine] # PRIu64 __PRI_64_LENGTH_MODIFIER__ u [NewLine] # PRIx64 __PRI_64_LENGTH_MODIFIER__ x [NewLine] # PRIX64 __PRI_64_LENGTH_MODIFIER__ X [NewLine] # [NewLine]  this system has inttypes.h by default # < inttypes . h > [NewLine] #  defined(CAPSTONE_HAS_OSXKERNEL) || (defined(_MSC_VER) && (_MSC_VER <= 1700 || defined(_KERNEL_MODE))) [NewLine] # [NewLine]
## Error: expected ';'!!!
