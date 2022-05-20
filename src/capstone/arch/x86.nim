import std/[options, bitops]
import capstone/private/[raw_x86, shared]
import common

type
  X86_Reg* = x86_reg
  X86_Op_Kind* = x86_op_type
  X86_XOP_CC* = x86_xop_cc
  X86_AVX_BCast* = x86_avx_bcast
  X86_SSE_CC* = x86_sse_cc
  X86_AVX_CC* = x86_avx_cc
  X86_AVX_RM* = x86_avx_rm
  X86_Prefix* = x86_prefix
  X86_Group* = x86_insn_group

type
  X86_Flag* {.pure.} = enum EFLAGS, FPU

  X86_Flags_Modified* = object
    kind*: X86_Flag
    flags*: uint64

  X86_Op_Mem* = object
    segment*: Option[X86_Reg]
    base*: Option[X86_Reg]
    index*: Option[X86_Reg]

    scale*: int
    disp*: int64

  X86_Operand* = object
    case kind*: X86_Op_Kind
    of X86_Op_Kind.REG:
      reg*: X86_Reg
    of X86_Op_Kind.IMM:
      imm*: int64
    of X86_Op_Kind.MEM:
      mem*: X86_Op_Mem
    else: discard

    size*: uint8
    access*: set[AccessKind]

    avx_bcast*: Option[X86_AVX_BCast]
    avx_zero_opmask*: bool

  X86_Encoding* = object
    modrm*: Option[uint8]
    disp*: Option[tuple[offset, size: uint8]]
    imm*:  Option[tuple[offset, size: uint8]]

  X86* = object
    prefix*: tuple[
      repeat: Option[X86_Prefix],
      segment: Option[X86_Prefix],
      size: Option[X86_Prefix],
      address: Option[X86_Prefix]
    ]

    opcode*: seq[uint8]
    rex*: uint8
    addr_size*: uint8

    modrm*: uint8
    disp*: Option[int64]

    sib_index*: Option[X86_Reg]
    sib_scale*: Option[int8]
    sib_base*: Option[X86_Reg]

    xop_cc*: Option[X86_XOP_CC]
    sse_cc*: Option[X86_SSE_CC]
    avx_cc*: Option[X86_AVX_CC]

    avx_sae*: bool
    avx_rm*: Option[X86_AVX_RM]

    flags*: X86_Flags_Modified

    operands*: seq[X86_Operand]
    encoding*: X86_Encoding

template ifValid(src, dest: typed) =
    if src != type(src).INVALID:
      dest = some(src)

proc initX86Encoding*(raw: cs_x86_encoding): X86_Encoding =
  if raw.modrm_offset.uint8 > 0:
    result.modrm = some(raw.modrm_offset.uint8)

  if raw.disp_offset.uint8 > 0:
    result.disp = some((offset: raw.disp_offset.uint8, size: raw.disp_size.uint8))

  if raw.imm_offset.uint8 > 0:
    result.imm = some((offset: raw.imm_offset.uint8, size: raw.imm_size.uint8))

proc initX86Operand*(raw: cs_x86_op): X86_Operand =
  result = X86_Operand(kind: raw.`type`)

  case result.kind
  of X86_Op_Kind.REG:
    result.reg = raw.storage.reg
  of X86_Op_Kind.IMM:
    result.imm = int64(raw.storage.imm)
  of X86_Op_Kind.MEM:
    let oldMem = raw.storage.mem
    var newMem = X86_Op_Mem()

    ifvalid oldMem.segment, newMem.segment
    ifValid oldMem.base, newMem.base
    ifValid oldmem.index, newMem.index

    newMem.scale = int(oldMem.scale)
    newMem.disp = int64(oldMem.disp)

    result.mem = newMem
  else: discard
  result.size = uint8(raw.size)

  if bitand(uint8(raw.access), uint8(cs_ac_type.READ)) > 0:
    result.access.incl AccessKind.Read

  if bitand(uint8(raw.access), uint8(cs_ac_type.WRITE)) > 0:
    result.access.incl AccessKind.Write

  ifValid raw.avx_bcast, result.avx_bcast
  result.avx_zero_opmask = raw.avx_zero_opmask

proc initX86*(raw: cs_x86): X86 =
  for o in raw.opcode:
    if o.uint8 == 0: break
    result.opcode.add o.uint8

  result.rex = raw.rex.uint8
  result.addr_size = raw.addr_size.uint8

  result.modrm = raw.modrm.uint8

  result.encoding = initX86Encoding(raw.encoding)

  if result.encoding.disp.isSome:
    result.disp = some(raw.disp.int64) # TODO: Make check

  if raw.sib_index != X86_Reg.INVALID:
    result.sib_index = some(raw.sib_index)
    result.sib_scale = some(int8(raw.sib_scale))

  ifValid raw.sib_base, result.sib_base

  ifValid raw.xop_cc, result.xop_cc
  ifValid raw.sse_cc, result.sse_cc
  ifValid raw.avx_cc, result.avx_cc

  result.avx_sae = raw.avx_sae

  ifValid raw.avx_rm, result.avx_rm

  # TODO: Figure out how to diff eflags and fpu_flags
  result.flags = X86_Flags_Modified(flags: uint64(raw.flags.eflags))

  if int(raw.op_count) > 0:
    for i in 0..(int(raw.op_count) - 1):
      let rawOperand = raw.operands[i]

      result.operands.add rawOperand.initX86Operand()


