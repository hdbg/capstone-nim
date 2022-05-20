import private/[
  raw_arm, raw_arm64, raw_mips, raw_systemz,
  raw_x86, raw_xcore, raw_ppc, raw_sparc]
import types

type
  RawHandle = pointer
  RawCode = ptr uint8

  ArchInstructionInfo {.bycopy, union.} = object
    x86: cs_x86
    arm64: cs_arm64
    arm: cs_arm
    mips: cs_mips
    ppc: cs_ppc
    sparc: cs_sparc
    sysz: cs_sysz
    xcore: cs_xcore

  RawDetail {.bycopy.} = object
    regs_read: array[12, uint8]
    regs_read_count: uint8

    regs_write: array[20, uint8]
    regs_write_count: uint8

    groups: array[8, uint8]
    groups_count: uint8

    info: ArchInstructionInfo

  RawInstruction {.bycopy.} = object
    id: uint
    address: uint64
    size: uint16
    bytes: array[16, uint8]
    mnemonic: array[32, char]
    op_str: array[160, char]

    detail: ptr RawDetail

const libname =
  when defined(Windows):
    "capstone.dll"
  else:
    "libcapstone.so"

{.push importc, cdecl, dynlib: libname.}
proc cs_open(arch: Architecture, mode: Mode, handle: ptr RawHandle): CapStoneErrorCode
proc cs_close(handle: ptr RawHandle): CapStoneErrorCode

proc cs_option(handle: RawHandle, `type`: OptionType, value: uint): CapStoneErrorCode

proc cs_errno(handle: RawHandle): CapStoneErrorCode
proc cs_strerror(code: CapStoneErrorCode): cstring

proc cs_disasm(handle: RawHandle, code: RawCode, code_size: uint, address: uint64, count: uint, insn: ptr ptr RawInstruction): int

proc cs_free(insn: ptr RawInstruction, count: uint)
proc cs_malloc(handle: RawHandle): ptr RawInstruction

proc cs_disasm_iter(handle: RawHandle, code: RawCode, size: ptr uint, address: ptr pointer, insn: ptr RawInstruction): bool

proc cs_version(major, minor: ptr int): uint
{.pop.}
