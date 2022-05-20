import capstone
import unittest

import capstone/types
import pkg/print

suite "Test x64":
  let engine = CapStone.new(Architecture.X86, Mode.Bit64)

  test "Base disasm":
    const instr: seq[uint8] = @[0x41.uint8, 0x5c.uint8, 0x41.uint8, 0x5d.uint8]

    let decoded = engine.disasm(instr)

    check:
      decoded.len == 2
      decoded[0].mnemonic == decoded[1].mnemonic
      decoded[0].mnemonic == "pop"

      decoded[0].op == "r12"
      decoded[1].op == "r13"

  test "Details":
    const instr: seq[uint8] = @[0x41.uint8, 0x5c.uint8, 0x41.uint8, 0x5d.uint8]
    engine.set(OptionType.Detail, OptionValue.On)

    let decoded = engine.disasm(instr)

    # print decoded



