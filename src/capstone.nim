import capstone/types
import std/[strutils, sequtils, options, tables]

import capstone/arch/x86
include capstone/wrapper


export OptionType, OptionValue, Architecture, Mode

type
  CapStone* = ref object
    handle: RawHandle
    arch: Architecture
    mode: Mode

    options: Table[OptionType, OptionValue]

  Detail* = object
    case arch: Architecture
    of Architecture.X86:
      x86*: X86
      regsReadX86*: seq[X86_Reg]
      regsWriteX86*: seq[X86_Reg]
      groups*: seq[X86_Group]

    # of Architecture.ARM:
    #   arm: cs_arm
    # of Architecture.ARM64:
    #   arm64: cs_arm64
    # of Architecture.M68K:
    #   m68k: cs_m68k
    # of Architecture.MIPS:
    #   mips: cs_mips
    # of Architecture.PPC:
    #   ppc: cs_ppc
    # of Architecture.SPARC:
    #   sparc: cs_sparc
    # of Architecture.SYSZ:
    #   sysz: cs_sysz
    # of Architecture.XCORE:
    #   xcore: cs_xcore
    # of Architecture.TMS320C64X:
    #   tms320c64x: cs_tms320c64x
    # of Architecture.M680X:
    #   m680x: cs_m680x
    # of Architecture.EVM:
    #   evm: cs_evm
    # of Architecture.MOS65XX:
    #   mos65xx: cs_mos65xx
    else: discard

  Instruction* = object
    id*: uint64
    address*: uint64
    bytes*: seq[byte]
    mnemonic*: string
    op*: string
    detail*: Option[Detail]

template errorRaise(c: CapStoneErrorCode) =
  if c != CapStoneErrorCode.Ok:
    let
      desc = $cs_strerror(c)
      excp = CapStoneError.newException(desc)
    excp.code = c
    raise excp

proc initInstruction(raw: RawInstruction): Instruction =
  proc convString(data: openArray[char]): string {.inline.} =
    for c in data:
      if c == '\x00': return
      result.add c

  result = Instruction(id: raw.id, address: raw.address.uint64)

  for b in raw.bytes:
    if b == 0: break
    result.bytes.add b

  result.mnemonic = raw.mnemonic.convString
  result.op = raw.op_str.convString

proc initDetail(engine: CapStone, raw: RawDetail): Detail =
  proc convArray[T, V](src: openArray[T], size: uint): seq[V] {.inline.} =
    if size > 0:
      for i in 0..size-1:
        result.add V(src[i])

  result = Detail(arch: engine.arch)

  case engine.arch
  of Architecture.X86:
    result.regsReadX86 = convArray[uint8, X86_Reg](raw.regs_read, raw.regs_read_count)
    result.regsWriteX86 = convArray[uint8, X86_Reg](raw.regs_write, raw.regs_write_count)

    result.groups = convArray[uint8, X86_Group](raw.groups, raw.groups_count)

    result.x86 = initX86(raw.info.x86)
  # Add more arch as I add more wrappers
  else: discard

# High Level API goes lower

proc new*(_: type CapStone, arch: Architecture, mode: Mode): CapStone =
  result = CapStone(arch: arch, mode: mode)
  cs_open(arch, mode, addr result.handle).errorRaise

  for optName in OptionType.items:
      result.options[optName] = OptionValue.Off

proc set*(engine: CapStone, kind: OptionType, val: OptionValue) =
  cs_option(engine.handle, kind, val.uint).errorRaise
  engine.options[kind] = val

proc version*(_: type CapStone): tuple[major, minor: int] =
  discard cs_version(unsafeAddr(result.major), unsafeAddr(result.minor))

proc disasm*(engine: CapStone, code: seq[uint8], count: uint = 0, address: uint64 = 0): seq[Instruction] =
  const instSize = (sizeof RawInstruction).uint

  var base: ptr RawInstruction
  let succ = cs_disasm(
    engine.handle,
    cast[ptr uint8](unsafeAddr code[0]),
    (code.len * sizeof(uint8)).uint,
    address,
    count,
    addr base
  )

  if succ == -1:
    errorRaise(engine.handle.cs_errno())
    return

  let baseAddr = cast[uint64](base)
  for i in countup(0, succ-1):
    let nextAddress = baseAddr + (i.uint * instSize).uint
    let raw = cast[ptr RawInstruction](nextAddress)[]

    var newInst = initInstruction(raw)

    if engine.options[OptionType.Detail] == OptionValue.On:
      let raw_detail = cast[uint64](raw.detail)
      newInst.detail = engine.initDetail(raw.detail[]).some

    result.add move(newInst)

  cs_free(base, succ.uint)
