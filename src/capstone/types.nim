const mnemonicSize = 32 # Maximum size of an instruction mnemonic string.

type
  Architecture* {.pure.} = enum
    ARM = 0
    ARM64
    MIPS
    X86
    PPC
    SPARC
    SYSZ
    XCORE
    MAX
    # ALL = 0xFFFF

  OptionType* {.pure.} = enum
    Invalid = 0
    Syntax
    Detail
    Mode
    Mem
    SkipData
    SkipDataSetup
    Mnemonic
    Unsigned

  OptionValue* {.pure.} = enum
    Off = 0
    On = 3
    Intel
    ATT
    NoRegName
    MASM

  OperandType* {.pure.} = enum
    Invalid = 0
    Reg
    IMM
    Mem
    FP

  AccessType* {.pure.} = enum
    Invalid = 0
    Read = 1 shl 0
    Write = 1 shl 1

  InstructionGroup* {.pure.} = enum
    Invalid = 0
    Jump
    Call
    Ret
    Int
    IRet
    Privilige
    BranchRelative

  CapStoneErrorCode* {.pure.} = enum
    Ok = 0
    Mem
    Arch
    Handle
    CSH
    Mode
    Option
    Detail
    MemSetup
    Version
    Diet
    SkipData
    X86_ATT
    X86_Intel
    X86_MASM

  CapStoneError* = object of CatchableError
    code*: CapStoneErrorCode



  # IDK why, but had to fix via viewing each field offsets
  # because there was size mismatch between github header file and
  # irl dynamic lib


when false:
  static:
    var accessOffset = 0

    for key, val in fieldPairs(RawInstruction()):
      echo key, ": ", accessOffset

      accessOffset.inc sizeof(val)

type Mode* = distinct uint

template genTmpl(name, expression: untyped) =
  template name*(_: type Mode): Mode = (expression).Mode

genTmpl LittleEndian, 0
genTmpl BigEndian, 1'uint shl 31

genTmpl Bit16, 1 shl 1
genTmpl Bit32, 1 shl 2
genTmpl Bit64, 1 shl 3

genTmpl Arm, 0
genTmpl Thumb, 1 shl 4
genTmpl MClass, 1 shl 5
genTmpl V8, 1 shl 6
genTmpl Micro, 1 shl 4
genTmpl Mips3, 1 shl 5
genTmpl Mips32R6, 1 shl 6
genTmpl MipsGP64, 1 shl 7
genTmpl V9, 1 shl 4
genTmpl QPX, 1 shl 4

genTmpl Mips32, 1 shl 2
genTmpl Mips64, 1 shl 3

proc `or`*(a, b: Mode): Mode {.inline.} =
  (a.uint or b.uint).Mode


