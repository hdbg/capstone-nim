import std/options
import capstone/private/raw_x86

type
  X86_Reg* = x86_reg
  X86_Op_Kind* = x86_op_type
  X86_AVX_BCast* = x86_avx_bcast
  X86_SSE_CC* = x86_sse_cc
  X86_AVX_CC* = x86_avx_cc
  X86_AVX_RM* = x86_avx_rm
  X86_Prefix* = x86_prefix
  X86_Group* = x86_insn_group

type
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
    of X86_Op_Kind.FP:
      fp*: float32
    else: discard

    size*: uint8

    avx_bcast*: Option[X86_AVX_BCast]
    avx_zero_opmask*: bool


  X86* = object
    prefix*: tuple[
      repeat: Option[X86_Prefix],
      segment: Option[X86_Prefix],
      size: Option[X86_Prefix],
      address: Option[X86_Prefix]
    ]

    opcode*: seq[uint8]
    rex*: Option[uint8]
    addr_size*: uint8

    modrm*: uint8
    sib*: Option[uint8]
    disp*: Option[int32]

    sib_index*: Option[X86_Reg]
    sib_scale*: Option[int8]
    sib_base*: Option[X86_Reg]

    sse_cc*: Option[X86_SSE_CC]

    avx_cc*: Option[X86_AVX_CC]
    avx_sae*: bool
    avx_rm*: Option[X86_AVX_RM]

    operands*: seq[X86_Operand]

template ifValid(src, dest: typed) =
    if src != type(src).INVALID:
      dest = some(src)

proc initX86Operand*(raw: cs_x86_op): X86_Operand =
  result = X86_Operand(kind: raw.`type`)

  case result.kind
  of X86_Op_Kind.REG:
    result.reg = raw.storage.reg
  of X86_Op_Kind.IMM:
    result.imm = int64(raw.storage.imm)
  of X86_Op_Kind.FP:
    result.fp = raw.storage.fp
  of X86_Op_Kind.MEM:
    let
      oldMem = raw.storage.mem

      segReg = X86_Reg(oldMem.segment)
      baseReg = X86_Reg(oldMem.base)
      indexReg = X86_Reg(oldMem.index)

    var newMem = X86_Op_Mem()

    ifvalid segReg, newMem.segment
    ifValid baseReg, newMem.base
    ifValid indexReg, newMem.index

    newMem.scale = int(oldMem.scale)
    newMem.disp = oldMem.disp

    result.mem = newMem
  else: discard
  result.size = raw.size

  ifValid raw.avx_bcast, result.avx_bcast
  result.avx_zero_opmask = raw.avx_zero_opmask

proc initX86*(raw: cs_x86): X86 =
  result.prefix = (
    repeat:  if raw.prefix[0] != 0: some(X86_Prefix(raw.prefix[0])) else: none(X86_Prefix),
    segment: if raw.prefix[1] != 0: some(X86_Prefix(raw.prefix[1])) else: none(X86_Prefix),
    size:    if raw.prefix[2] != 0: some(X86_Prefix(raw.prefix[2])) else: none(X86_Prefix),
    address: if raw.prefix[3] != 0: some(X86_Prefix(raw.prefix[3])) else: none(X86_Prefix)
  )

  for o in raw.opcode:
    if o == 0: break
    result.opcode.add o

  if raw.rex != 0:
    result.rex = some(raw.rex)

  result.addr_size = raw.addr_size
  result.modrm = raw.modrm

  if raw.sib != 0:
    result.sib = some(raw.sib)

  if raw.disp != 0:
    result.disp = some(raw.disp.int32)

  if X86_Reg(raw.sib_index) != X86_Reg.INVALID:
    result.sib_index = some(X86_Reg(raw.sib_index))
    result.sib_scale = some(int8(raw.sib_scale))

  ifValid X86_Reg(raw.sib_base), result.sib_base

  ifValid X86_SSE_CC(raw.sse_cc), result.sse_cc
  ifValid X86_AVX_CC(raw.avx_cc), result.avx_cc

  result.avx_sae = raw.avx_sae

  ifValid X86_AVX_RM(raw.avx_rm), result.avx_rm

  if raw.op_count > 0:
    for i in 0..(int(raw.op_count) - 1):
      let rawOperand = raw.operands[i]

      result.operands.add rawOperand.initX86Operand()


