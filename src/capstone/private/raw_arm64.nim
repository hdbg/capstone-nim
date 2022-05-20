##  Capstone Disassembly Engine
##  By Nguyen Anh Quynh <aquynh@gmail.com>, 2013-2015

import
  platform

## / ARM64 shift type

type
  arm64_shifter* = enum
    SFT_INVALID = 0, SFT_LSL = 1, SFT_MSL = 2, SFT_LSR = 3,
    SFT_ASR = 4, SFT_ROR = 5


## / ARM64 extender type

type
  arm64_extender* = enum
    EXT_INVALID = 0, EXT_UXTB = 1, EXT_UXTH = 2, EXT_UXTW = 3,
    EXT_UXTX = 4, EXT_SXTB = 5, EXT_SXTH = 6, EXT_SXTW = 7,
    EXT_SXTX = 8


## / ARM64 condition code

type
  arm64_cc* = enum
    CC_INVALID = 0, CC_EQ = 1, ## /< Equal
    CC_NE = 2,            ## /< Not equal:                 Not equal, or unordered
    CC_HS = 3,            ## /< Unsigned higher or same:   >, ==, or unordered
    CC_LO = 4,            ## /< Unsigned lower or same:    Less than
    CC_MI = 5,            ## /< Minus, negative:           Less than
    CC_PL = 6,            ## /< Plus, positive or zero:    >, ==, or unordered
    CC_VS = 7,            ## /< Overflow:                  Unordered
    CC_VC = 8,            ## /< No overflow:               Ordered
    CC_HI = 9,            ## /< Unsigned higher:           Greater than, or unordered
    CC_LS = 10,           ## /< Unsigned lower or same:    Less than or equal
    CC_GE = 11,           ## /< Greater than or equal:     Greater than or equal
    CC_LT = 12,           ## /< Less than:                 Less than, or unordered
    CC_GT = 13,           ## /< Signed greater than:       Greater than
    CC_LE = 14,           ## /< Signed less than or equal: <, ==, or unordered
    CC_AL = 15,           ## /< Always (unconditional):    Always (unconditional)
    CC_NV = 16 ## /< Always (unconditional):   Always (unconditional)
                  ## < Note the NV exists purely to disassemble 0b1111. Execution
                  ## < is "always".


## / System registers

type                          ##  System registers for MRS
    ##  System registers for MSR
  arm64_sysreg* = enum
    SYSREG_INVALID = 0, SYSREG_MDRAR_EL1 = 0x8080, ##  10  000  0001  0000  000
    SYSREG_OSLSR_EL1 = 0x808c, ##  10  000  0001  0001  100
    SYSREG_DBGAUTHSTATUS_EL1 = 0x83f6, ##  10  000  0111  1110  110
    SYSREG_TRCIDR8 = 0x8806, ##  10  001  0000  0000  110
    SYSREG_TRCIDR9 = 0x880e, ##  10  001  0000  0001  110
    SYSREG_TRCIDR10 = 0x8816, ##  10  001  0000  0010  110
    SYSREG_TRCSTATR = 0x8818, ##  10  001  0000  0011  000
    SYSREG_TRCIDR11 = 0x881e, ##  10  001  0000  0011  110
    SYSREG_TRCIDR12 = 0x8826, ##  10  001  0000  0100  110
    SYSREG_TRCIDR13 = 0x882e, ##  10  001  0000  0101  110
    SYSREG_TRCIDR0 = 0x8847, ##  10  001  0000  1000  111
    SYSREG_TRCIDR1 = 0x884f, ##  10  001  0000  1001  111
    SYSREG_TRCIDR2 = 0x8857, ##  10  001  0000  1010  111
    SYSREG_TRCIDR3 = 0x885f, ##  10  001  0000  1011  111
    SYSREG_TRCIDR4 = 0x8867, ##  10  001  0000  1100  111
    SYSREG_TRCIDR5 = 0x886f, ##  10  001  0000  1101  111
    SYSREG_TRCIDR6 = 0x8877, ##  10  001  0000  1110  111
    SYSREG_TRCIDR7 = 0x887f, ##  10  001  0000  1111  111
    SYSREG_TRCOSLSR = 0x888c, ##  10  001  0001  0001  100
    SYSREG_TRCPDSR = 0x88ac, ##  10  001  0001  0101  100
    SYSREG_TRCDEVID = 0x8b97, ##  10  001  0111  0010  111
    SYSREG_TRCDEVTYPE = 0x8b9f, ##  10  001  0111  0011  111
    SYSREG_TRCPIDR4 = 0x8ba7, ##  10  001  0111  0100  111
    SYSREG_TRCPIDR5 = 0x8baf, ##  10  001  0111  0101  111
    SYSREG_TRCPIDR6 = 0x8bb7, ##  10  001  0111  0110  111
    SYSREG_TRCPIDR7 = 0x8bbf, ##  10  001  0111  0111  111
    SYSREG_TRCPIDR0 = 0x8bc7, ##  10  001  0111  1000  111
    SYSREG_TRCPIDR1 = 0x8bcf, ##  10  001  0111  1001  111
    SYSREG_TRCDEVAFF0 = 0x8bd6, ##  10  001  0111  1010  110
    SYSREG_TRCPIDR2 = 0x8bd7, ##  10  001  0111  1010  111
    SYSREG_TRCDEVAFF1 = 0x8bde, ##  10  001  0111  1011  110
    SYSREG_TRCPIDR3 = 0x8bdf, ##  10  001  0111  1011  111
    SYSREG_TRCCIDR0 = 0x8be7, ##  10  001  0111  1100  111
    SYSREG_TRCLSR = 0x8bee, ##  10  001  0111  1101  110
    SYSREG_TRCCIDR1 = 0x8bef, ##  10  001  0111  1101  111
    SYSREG_TRCAUTHSTATUS = 0x8bf6, ##  10  001  0111  1110  110
    SYSREG_TRCCIDR2 = 0x8bf7, ##  10  001  0111  1110  111
    SYSREG_TRCDEVARCH = 0x8bfe, ##  10  001  0111  1111  110
    SYSREG_TRCCIDR3 = 0x8bff, ##  10  001  0111  1111  111
                                 ##  GICv3 registers
    SYSREG_MDCCSR_EL0 = 0x9808, ##  10  011  0000  0001  000
    SYSREG_DBGDTRRX_EL0 = 0x9828, ##  10  011  0000  0101  000
    SYSREG_MIDR_EL1 = 0xc000, ##  11  000  0000  0000  000
    SYSREG_MPIDR_EL1 = 0xc005, ##  11  000  0000  0000  101
    SYSREG_REVIDR_EL1 = 0xc006, ##  11  000  0000  0000  110
    SYSREG_ID_PFR0_EL1 = 0xc008, ##  11  000  0000  0001  000
    SYSREG_ID_PFR1_EL1 = 0xc009, ##  11  000  0000  0001  001
    SYSREG_ID_DFR0_EL1 = 0xc00a, ##  11  000  0000  0001  010
    SYSREG_ID_AFR0_EL1 = 0xc00b, ##  11  000  0000  0001  011
    SYSREG_ID_MMFR0_EL1 = 0xc00c, ##  11  000  0000  0001  100
    SYSREG_ID_MMFR1_EL1 = 0xc00d, ##  11  000  0000  0001  101
    SYSREG_ID_MMFR2_EL1 = 0xc00e, ##  11  000  0000  0001  110
    SYSREG_ID_MMFR3_EL1 = 0xc00f, ##  11  000  0000  0001  111
    SYSREG_ID_ISAR0_EL1 = 0xc010, ##  11  000  0000  0010  000
    SYSREG_ID_ISAR1_EL1 = 0xc011, ##  11  000  0000  0010  001
    SYSREG_ID_ISAR2_EL1 = 0xc012, ##  11  000  0000  0010  010
    SYSREG_ID_ISAR3_EL1 = 0xc013, ##  11  000  0000  0010  011
    SYSREG_ID_ISAR4_EL1 = 0xc014, ##  11  000  0000  0010  100
    SYSREG_ID_ISAR5_EL1 = 0xc015, ##  11  000  0000  0010  101
    SYSREG_MVFR0_EL1 = 0xc018, ##  11  000  0000  0011  000
    SYSREG_MVFR1_EL1 = 0xc019, ##  11  000  0000  0011  001
    SYSREG_MVFR2_EL1 = 0xc01a, ##  11  000  0000  0011  010
    SYSREG_ID_A64PFR0_EL1 = 0xc020, ##  11  000  0000  0100  000
    SYSREG_ID_A64PFR1_EL1 = 0xc021, ##  11  000  0000  0100  001
    SYSREG_ID_A64DFR0_EL1 = 0xc028, ##  11  000  0000  0101  000
    SYSREG_ID_A64DFR1_EL1 = 0xc029, ##  11  000  0000  0101  001
    SYSREG_ID_A64AFR0_EL1 = 0xc02c, ##  11  000  0000  0101  100
    SYSREG_ID_A64AFR1_EL1 = 0xc02d, ##  11  000  0000  0101  101
    SYSREG_ID_A64ISAR0_EL1 = 0xc030, ##  11  000  0000  0110  000
    SYSREG_ID_A64ISAR1_EL1 = 0xc031, ##  11  000  0000  0110  001
    SYSREG_ID_A64MMFR0_EL1 = 0xc038, ##  11  000  0000  0111  000
    SYSREG_ID_A64MMFR1_EL1 = 0xc039, ##  11  000  0000  0111  001
    SYSREG_RVBAR_EL1 = 0xc601, ##  11  000  1100  0000  001
    SYSREG_ISR_EL1 = 0xc608, ##  11  000  1100  0001  000
    SYSREG_ICC_IAR0_EL1 = 0xc640, ##  11  000  1100  1000  000
    SYSREG_ICC_HPPIR0_EL1 = 0xc642, ##  11  000  1100  1000  010
    SYSREG_ICC_RPR_EL1 = 0xc65b, ##  11  000  1100  1011  011
    SYSREG_ICC_IAR1_EL1 = 0xc660, ##  11  000  1100  1100  000
    SYSREG_ICC_HPPIR1_EL1 = 0xc662, ##  11  000  1100  1100  010
    SYSREG_CCSIDR_EL1 = 0xc800, ##  11  001  0000  0000  000
    SYSREG_CLIDR_EL1 = 0xc801, ##  11  001  0000  0000  001
    SYSREG_AIDR_EL1 = 0xc807, ##  11  001  0000  0000  111
    SYSREG_CTR_EL0 = 0xd801, ##  11  011  0000  0000  001
    SYSREG_DCZID_EL0 = 0xd807, ##  11  011  0000  0000  111
    SYSREG_PMCEID0_EL0 = 0xdce6, ##  11  011  1001  1100  110
    SYSREG_PMCEID1_EL0 = 0xdce7, ##  11  011  1001  1100  111
    SYSREG_CNTPCT_EL0 = 0xdf01, ##  11  011  1110  0000  001
    SYSREG_CNTVCT_EL0 = 0xdf02, ##  11  011  1110  0000  010
                                   ##  Trace registers
    SYSREG_RVBAR_EL2 = 0xe601, ##  11  100  1100  0000  001
    SYSREG_ICH_VTR_EL2 = 0xe659, ##  11  100  1100  1011  001
    SYSREG_ICH_EISR_EL2 = 0xe65b, ##  11  100  1100  1011  011
    SYSREG_ICH_ELSR_EL2 = 0xe65d, ##  11  100  1100  1011  101
    SYSREG_RVBAR_EL3 = 0xf601 ##  11  110  1100  0000  001
  arm64_msr_reg* = enum
    SYSREG_OSLAR_EL1 = 0x8084, ##  10  000  0001  0000  100
    SYSREG_TRCOSLAR = 0x8884, ##  10  001  0001  0000  100
    SYSREG_TRCLAR = 0x8be6, ##  10  001  0111  1100  110
                               ##  GICv3 registers
    SYSREG_DBGDTRTX_EL0 = 0x9828, ##  10  011  0000  0101  000
    SYSREG_ICC_EOIR0_EL1 = 0xc641, ##  11  000  1100  1000  001
    SYSREG_ICC_DIR_EL1 = 0xc659, ##  11  000  1100  1011  001
    SYSREG_ICC_SGI1R_EL1 = 0xc65d, ##  11  000  1100  1011  101
    SYSREG_ICC_ASGI1R_EL1 = 0xc65e, ##  11  000  1100  1011  110
    SYSREG_ICC_SGI0R_EL1 = 0xc65f, ##  11  000  1100  1011  111
    SYSREG_ICC_EOIR1_EL1 = 0xc661, ##  11  000  1100  1100  001
    SYSREG_PMSWINC_EL0 = 0xdce4 ##  11  011  1001  1100  100
                                   ##  Trace Registers



## / System PState Field (MSR instruction)

type
  arm64_pstate* = enum
    PSTATE_INVALID = 0, PSTATE_SPSEL = 0x05, PSTATE_DAIFSET = 0x1e,
    PSTATE_DAIFCLR = 0x1f


## / Vector arrangement specifier (for FloatingPoint/Advanced SIMD insn)

type
  arm64_vas* = enum
    VAS_INVALID = 0, VAS_8B, VAS_16B, VAS_4H, VAS_8H,
    VAS_2S, VAS_4S, VAS_1D, VAS_2D, VAS_1Q


## / Vector element size specifier

type
  arm64_vess* = enum
    VESS_INVALID = 0, VESS_B, VESS_H, VESS_S, VESS_D


## / Memory barrier operands

type
  arm64_barrier_op* = enum
    BARRIER_INVALID = 0, BARRIER_OSHLD = 0x1, BARRIER_OSHST = 0x2,
    BARRIER_OSH = 0x3, BARRIER_NSHLD = 0x5, BARRIER_NSHST = 0x6,
    BARRIER_NSH = 0x7, BARRIER_ISHLD = 0x9, BARRIER_ISHST = 0xa,
    BARRIER_ISH = 0xb, BARRIER_LD = 0xd, BARRIER_ST = 0xe,
    BARRIER_SY = 0xf


## / Operand type for instruction's operands

type
  arm64_op_type* = enum
    OP_INVALID = 0,       ## /< = CS_OP_INVALID (Uninitialized).
    OP_REG,             ## /< = CS_OP_REG (Register operand).
    OP_IMM,             ## /< = CS_OP_IMM (Immediate operand).
    OP_MEM,             ## /< = CS_OP_MEM (Memory operand).
    OP_FP,              ## /< = CS_OP_FP (Floating-Point operand).
    OP_CIMM = 64,         ## /< C-Immediate
    OP_REG_MRS,         ## /< MRS register operand.
    OP_REG_MSR,         ## /< MSR register operand.
    OP_PSTATE,          ## /< PState operand.
    OP_SYS,             ## /< SYS operand for IC/DC/AT/TLBI instructions.
    OP_PREFETCH,        ## /< Prefetch operand (PRFM).
    OP_BARRIER          ## /< Memory barrier operand (ISB/DMB/DSB instructions).


## / TLBI operations

type
  arm64_tlbi_op* = enum
    TLBI_INVALID = 0, TLBI_VMALLE1IS, TLBI_VAE1IS,
    TLBI_ASIDE1IS, TLBI_VAAE1IS, TLBI_VALE1IS,
    TLBI_VAALE1IS, TLBI_ALLE2IS, TLBI_VAE2IS, TLBI_ALLE1IS,
    TLBI_VALE2IS, TLBI_VMALLS12E1IS, TLBI_ALLE3IS,
    TLBI_VAE3IS, TLBI_VALE3IS, TLBI_IPAS2E1IS,
    TLBI_IPAS2LE1IS, TLBI_IPAS2E1, TLBI_IPAS2LE1,
    TLBI_VMALLE1, TLBI_VAE1, TLBI_ASIDE1, TLBI_VAAE1,
    TLBI_VALE1, TLBI_VAALE1, TLBI_ALLE2, TLBI_VAE2,
    TLBI_ALLE1, TLBI_VALE2, TLBI_VMALLS12E1, TLBI_ALLE3,
    TLBI_VAE3, TLBI_VALE3


## / AT operations

type
  arm64_at_op* = enum
    AT_S1E1R, AT_S1E1W, AT_S1E0R, AT_S1E0W, AT_S1E2R,
    AT_S1E2W, AT_S12E1R, AT_S12E1W, AT_S12E0R,
    AT_S12E0W, AT_S1E3R, AT_S1E3W


## / DC operations

type
  arm64_dc_op* = enum
    DC_INVALID = 0, DC_ZVA, DC_IVAC, DC_ISW, DC_CVAC,
    DC_CSW, DC_CVAU, DC_CIVAC, DC_CISW


## / IC operations

type
  arm64_ic_op* = enum
    IC_INVALID = 0, IC_IALLUIS, IC_IALLU, IC_IVAU


## / Prefetch operations (PRFM)

type
  arm64_prefetch_op* = enum
    PRFM_INVALID = 0, PRFM_PLDL1KEEP = 0x00 + 1,
    PRFM_PLDL1STRM = 0x01 + 1, PRFM_PLDL2KEEP = 0x02 + 1,
    PRFM_PLDL2STRM = 0x03 + 1, PRFM_PLDL3KEEP = 0x04 + 1,
    PRFM_PLDL3STRM = 0x05 + 1, PRFM_PLIL1KEEP = 0x08 + 1,
    PRFM_PLIL1STRM = 0x09 + 1, PRFM_PLIL2KEEP = 0x0a + 1,
    PRFM_PLIL2STRM = 0x0b + 1, PRFM_PLIL3KEEP = 0x0c + 1,
    PRFM_PLIL3STRM = 0x0d + 1, PRFM_PSTL1KEEP = 0x10 + 1,
    PRFM_PSTL1STRM = 0x11 + 1, PRFM_PSTL2KEEP = 0x12 + 1,
    PRFM_PSTL2STRM = 0x13 + 1, PRFM_PSTL3KEEP = 0x14 + 1,
    PRFM_PSTL3STRM = 0x15 + 1


## / ARM64 registers

type
  arm64_reg* = enum
    REG_INVALID = 0, REG_X29, REG_X30, REG_NZCV, REG_SP,
    REG_WSP, REG_WZR, REG_XZR, REG_B0, REG_B1,
    REG_B2, REG_B3, REG_B4, REG_B5, REG_B6,
    REG_B7, REG_B8, REG_B9, REG_B10, REG_B11,
    REG_B12, REG_B13, REG_B14, REG_B15, REG_B16,
    REG_B17, REG_B18, REG_B19, REG_B20, REG_B21,
    REG_B22, REG_B23, REG_B24, REG_B25, REG_B26,
    REG_B27, REG_B28, REG_B29, REG_B30, REG_B31,
    REG_D0, REG_D1, REG_D2, REG_D3, REG_D4,
    REG_D5, REG_D6, REG_D7, REG_D8, REG_D9,
    REG_D10, REG_D11, REG_D12, REG_D13, REG_D14,
    REG_D15, REG_D16, REG_D17, REG_D18, REG_D19,
    REG_D20, REG_D21, REG_D22, REG_D23, REG_D24,
    REG_D25, REG_D26, REG_D27, REG_D28, REG_D29,
    REG_D30, REG_D31, REG_H0, REG_H1, REG_H2,
    REG_H3, REG_H4, REG_H5, REG_H6, REG_H7,
    REG_H8, REG_H9, REG_H10, REG_H11, REG_H12,
    REG_H13, REG_H14, REG_H15, REG_H16, REG_H17,
    REG_H18, REG_H19, REG_H20, REG_H21, REG_H22,
    REG_H23, REG_H24, REG_H25, REG_H26, REG_H27,
    REG_H28, REG_H29, REG_H30, REG_H31, REG_Q0,
    REG_Q1, REG_Q2, REG_Q3, REG_Q4, REG_Q5,
    REG_Q6, REG_Q7, REG_Q8, REG_Q9, REG_Q10,
    REG_Q11, REG_Q12, REG_Q13, REG_Q14, REG_Q15,
    REG_Q16, REG_Q17, REG_Q18, REG_Q19, REG_Q20,
    REG_Q21, REG_Q22, REG_Q23, REG_Q24, REG_Q25,
    REG_Q26, REG_Q27, REG_Q28, REG_Q29, REG_Q30,
    REG_Q31, REG_S0, REG_S1, REG_S2, REG_S3,
    REG_S4, REG_S5, REG_S6, REG_S7, REG_S8,
    REG_S9, REG_S10, REG_S11, REG_S12, REG_S13,
    REG_S14, REG_S15, REG_S16, REG_S17, REG_S18,
    REG_S19, REG_S20, REG_S21, REG_S22, REG_S23,
    REG_S24, REG_S25, REG_S26, REG_S27, REG_S28,
    REG_S29, REG_S30, REG_S31, REG_W0, REG_W1,
    REG_W2, REG_W3, REG_W4, REG_W5, REG_W6,
    REG_W7, REG_W8, REG_W9, REG_W10, REG_W11,
    REG_W12, REG_W13, REG_W14, REG_W15, REG_W16,
    REG_W17, REG_W18, REG_W19, REG_W20, REG_W21,
    REG_W22, REG_W23, REG_W24, REG_W25, REG_W26,
    REG_W27, REG_W28, REG_W29, REG_W30, REG_X0,
    REG_X1, REG_X2, REG_X3, REG_X4, REG_X5,
    REG_X6, REG_X7, REG_X8, REG_X9, REG_X10,
    REG_X11, REG_X12, REG_X13, REG_X14, REG_X15,
    REG_X16, REG_X17, REG_X18, REG_X19, REG_X20,
    REG_X21, REG_X22, REG_X23, REG_X24, REG_X25,
    REG_X26, REG_X27, REG_X28, REG_V0, REG_V1,
    REG_V2, REG_V3, REG_V4, REG_V5, REG_V6,
    REG_V7, REG_V8, REG_V9, REG_V10, REG_V11,
    REG_V12, REG_V13, REG_V14, REG_V15, REG_V16,
    REG_V17, REG_V18, REG_V19, REG_V20, REG_V21,
    REG_V22, REG_V23, REG_V24, REG_V25, REG_V26,
    REG_V27, REG_V28, REG_V29, REG_V30, REG_V31, REG_ENDING ##  <-- mark the end of the list of registers
                                                                                          ##  alias registers

const
  REG_IP0* = REG_X16
  REG_IP1* = REG_X17
  REG_FP* = REG_X29
  REG_LR* = REG_X30

## / Instruction's operand referring to memory
## / This is associated with OP_MEM operand type above

type
  arm64_op_mem* {.bycopy.} = object
    base*: arm64_reg           ## /< base register
    index*: arm64_reg          ## /< index register
    disp*: int32_t             ## /< displacement/offset value


## / Instruction operand

type
  INNER_C_STRUCT_arm64_655* {.bycopy.} = object
    `type`*: arm64_shifter     ## /< shifter type of this operand
    value*: cuint              ## /< shifter value of this operand

  INNER_C_UNION_arm64_655* {.bycopy, union.} = object
    reg*: arm64_reg            ## /< register value for REG operand
    imm*: int64_t              ## /< immediate value, or index for C-IMM or IMM operand
    fp*: cdouble               ## /< floating point value for FP operand
    mem*: arm64_op_mem         ## /< base/index/scale/disp value for MEM operand
    pstate*: arm64_pstate      ## /< PState field of MSR instruction.
    sys*: cuint                ## /< IC/DC/AT/TLBI operation (see arm64_ic_op, arm64_dc_op, arm64_at_op, arm64_tlbi_op)
    prefetch*: arm64_prefetch_op ## /< PRFM operation.
    barrier*: arm64_barrier_op ## /< Memory barrier operation (ISB/DMB/DSB instructions).

  cs_arm64_op* {.bycopy.} = object
    vector_index*: cint        ## /< Vector Index for some vector operands (or -1 if irrelevant)
    vas*: arm64_vas            ## /< Vector Arrangement Specifier
    vess*: arm64_vess          ## /< Vector Element Size Specifier
    shift*: INNER_C_STRUCT_arm64_655
    ext*: arm64_extender       ## /< extender type of this operand
    `type`*: arm64_op_type     ## /< operand type
    ano_arm64_655*: INNER_C_UNION_arm64_655
    access*: uint8_t


## / Instruction structure

type
  cs_arm64* {.bycopy.} = object
    cc*: arm64_cc              ## /< conditional code for this insn
    update_flags*: bool        ## /< does this insn update flags?
    writeback*: bool ## /< does this insn request writeback? 'True' means 'yes'
                   ## / Number of operands of this instruction,
                   ## / or 0 when instruction has no operand.
    op_count*: uint8_t
    operands*: array[8, cs_arm64_op] ## /< operands for this instruction.


## / ARM64 instruction

type
  arm64_insn* = enum
    INS_INVALID = 0, INS_ABS, INS_ADC, INS_ADDHN,
    INS_ADDHN2, INS_ADDP, INS_ADD, INS_ADDV, INS_ADR,
    INS_ADRP, INS_AESD, INS_AESE, INS_AESIMC,
    INS_AESMC, INS_AND, INS_ASR, INS_B, INS_BFM,
    INS_BIC, INS_BIF, INS_BIT, INS_BL, INS_BLR,
    INS_BR, INS_BRK, INS_BSL, INS_CBNZ, INS_CBZ,
    INS_CCMN, INS_CCMP, INS_CLREX, INS_CLS, INS_CLZ,
    INS_CMEQ, INS_CMGE, INS_CMGT, INS_CMHI, INS_CMHS,
    INS_CMLE, INS_CMLT, INS_CMTST, INS_CNT, INS_MOV,
    INS_CRC32B, INS_CRC32CB, INS_CRC32CH, INS_CRC32CW,
    INS_CRC32CX, INS_CRC32H, INS_CRC32W, INS_CRC32X,
    INS_CSEL, INS_CSINC, INS_CSINV, INS_CSNEG,
    INS_DCPS1, INS_DCPS2, INS_DCPS3, INS_DMB,
    INS_DRPS, INS_DSB, INS_DUP, INS_EON, INS_EOR,
    INS_ERET, INS_EXTR, INS_EXT, INS_FABD, INS_FABS,
    INS_FACGE, INS_FACGT, INS_FADD, INS_FADDP,
    INS_FCCMP, INS_FCCMPE, INS_FCMEQ, INS_FCMGE,
    INS_FCMGT, INS_FCMLE, INS_FCMLT, INS_FCMP,
    INS_FCMPE, INS_FCSEL, INS_FCVTAS, INS_FCVTAU,
    INS_FCVT, INS_FCVTL, INS_FCVTL2, INS_FCVTMS,
    INS_FCVTMU, INS_FCVTNS, INS_FCVTNU, INS_FCVTN,
    INS_FCVTN2, INS_FCVTPS, INS_FCVTPU, INS_FCVTXN,
    INS_FCVTXN2, INS_FCVTZS, INS_FCVTZU, INS_FDIV,
    INS_FMADD, INS_FMAX, INS_FMAXNM, INS_FMAXNMP,
    INS_FMAXNMV, INS_FMAXP, INS_FMAXV, INS_FMIN,
    INS_FMINNM, INS_FMINNMP, INS_FMINNMV, INS_FMINP,
    INS_FMINV, INS_FMLA, INS_FMLS, INS_FMOV,
    INS_FMSUB, INS_FMUL, INS_FMULX, INS_FNEG,
    INS_FNMADD, INS_FNMSUB, INS_FNMUL, INS_FRECPE,
    INS_FRECPS, INS_FRECPX, INS_FRINTA, INS_FRINTI,
    INS_FRINTM, INS_FRINTN, INS_FRINTP, INS_FRINTX,
    INS_FRINTZ, INS_FRSQRTE, INS_FRSQRTS, INS_FSQRT,
    INS_FSUB, INS_HINT, INS_HLT, INS_HVC, INS_INS,
    INS_ISB, INS_LD1, INS_LD1R, INS_LD2R, INS_LD2,
    INS_LD3R, INS_LD3, INS_LD4, INS_LD4R, INS_LDARB,
    INS_LDARH, INS_LDAR, INS_LDAXP, INS_LDAXRB,
    INS_LDAXRH, INS_LDAXR, INS_LDNP, INS_LDP,
    INS_LDPSW, INS_LDRB, INS_LDR, INS_LDRH, INS_LDRSB,
    INS_LDRSH, INS_LDRSW, INS_LDTRB, INS_LDTRH,
    INS_LDTRSB, INS_LDTRSH, INS_LDTRSW, INS_LDTR,
    INS_LDURB, INS_LDUR, INS_LDURH, INS_LDURSB,
    INS_LDURSH, INS_LDURSW, INS_LDXP, INS_LDXRB,
    INS_LDXRH, INS_LDXR, INS_LSL, INS_LSR, INS_MADD,
    INS_MLA, INS_MLS, INS_MOVI, INS_MOVK, INS_MOVN,
    INS_MOVZ, INS_MRS, INS_MSR, INS_MSUB, INS_MUL,
    INS_MVNI, INS_NEG, INS_NOT, INS_ORN, INS_ORR,
    INS_PMULL2, INS_PMULL, INS_PMUL, INS_PRFM,
    INS_PRFUM, INS_RADDHN, INS_RADDHN2, INS_RBIT,
    INS_RET, INS_REV16, INS_REV32, INS_REV64, INS_REV,
    INS_ROR, INS_RSHRN2, INS_RSHRN, INS_RSUBHN,
    INS_RSUBHN2, INS_SABAL2, INS_SABAL, INS_SABA,
    INS_SABDL2, INS_SABDL, INS_SABD, INS_SADALP,
    INS_SADDLP, INS_SADDLV, INS_SADDL2, INS_SADDL,
    INS_SADDW2, INS_SADDW, INS_SBC, INS_SBFM,
    INS_SCVTF, INS_SDIV, INS_SHA1C, INS_SHA1H,
    INS_SHA1M, INS_SHA1P, INS_SHA1SU0, INS_SHA1SU1,
    INS_SHA256H2, INS_SHA256H, INS_SHA256SU0,
    INS_SHA256SU1, INS_SHADD, INS_SHLL2, INS_SHLL,
    INS_SHL, INS_SHRN2, INS_SHRN, INS_SHSUB, INS_SLI,
    INS_SMADDL, INS_SMAXP, INS_SMAXV, INS_SMAX,
    INS_SMC, INS_SMINP, INS_SMINV, INS_SMIN,
    INS_SMLAL2, INS_SMLAL, INS_SMLSL2, INS_SMLSL,
    INS_SMOV, INS_SMSUBL, INS_SMULH, INS_SMULL2,
    INS_SMULL, INS_SQABS, INS_SQADD, INS_SQDMLAL,
    INS_SQDMLAL2, INS_SQDMLSL, INS_SQDMLSL2, INS_SQDMULH,
    INS_SQDMULL, INS_SQDMULL2, INS_SQNEG, INS_SQRDMULH,
    INS_SQRSHL, INS_SQRSHRN, INS_SQRSHRN2, INS_SQRSHRUN,
    INS_SQRSHRUN2, INS_SQSHLU, INS_SQSHL, INS_SQSHRN,
    INS_SQSHRN2, INS_SQSHRUN, INS_SQSHRUN2, INS_SQSUB,
    INS_SQXTN2, INS_SQXTN, INS_SQXTUN2, INS_SQXTUN,
    INS_SRHADD, INS_SRI, INS_SRSHL, INS_SRSHR,
    INS_SRSRA, INS_SSHLL2, INS_SSHLL, INS_SSHL,
    INS_SSHR, INS_SSRA, INS_SSUBL2, INS_SSUBL,
    INS_SSUBW2, INS_SSUBW, INS_ST1, INS_ST2, INS_ST3,
    INS_ST4, INS_STLRB, INS_STLRH, INS_STLR,
    INS_STLXP, INS_STLXRB, INS_STLXRH, INS_STLXR,
    INS_STNP, INS_STP, INS_STRB, INS_STR, INS_STRH,
    INS_STTRB, INS_STTRH, INS_STTR, INS_STURB,
    INS_STUR, INS_STURH, INS_STXP, INS_STXRB,
    INS_STXRH, INS_STXR, INS_SUBHN, INS_SUBHN2,
    INS_SUB, INS_SUQADD, INS_SVC, INS_SYSL, INS_SYS,
    INS_TBL, INS_TBNZ, INS_TBX, INS_TBZ, INS_TRN1,
    INS_TRN2, INS_UABAL2, INS_UABAL, INS_UABA,
    INS_UABDL2, INS_UABDL, INS_UABD, INS_UADALP,
    INS_UADDLP, INS_UADDLV, INS_UADDL2, INS_UADDL,
    INS_UADDW2, INS_UADDW, INS_UBFM, INS_UCVTF,
    INS_UDIV, INS_UHADD, INS_UHSUB, INS_UMADDL,
    INS_UMAXP, INS_UMAXV, INS_UMAX, INS_UMINP,
    INS_UMINV, INS_UMIN, INS_UMLAL2, INS_UMLAL,
    INS_UMLSL2, INS_UMLSL, INS_UMOV, INS_UMSUBL,
    INS_UMULH, INS_UMULL2, INS_UMULL, INS_UQADD,
    INS_UQRSHL, INS_UQRSHRN, INS_UQRSHRN2, INS_UQSHL,
    INS_UQSHRN, INS_UQSHRN2, INS_UQSUB, INS_UQXTN2,
    INS_UQXTN, INS_URECPE, INS_URHADD, INS_URSHL,
    INS_URSHR, INS_URSQRTE, INS_URSRA, INS_USHLL2,
    INS_USHLL, INS_USHL, INS_USHR, INS_USQADD,
    INS_USRA, INS_USUBL2, INS_USUBL, INS_USUBW2,
    INS_USUBW, INS_UZP1, INS_UZP2, INS_XTN2, INS_XTN,
    INS_ZIP1, INS_ZIP2, ##  alias insn
    INS_MNEG, INS_UMNEGL, INS_SMNEGL, INS_NOP,
    INS_YIELD, INS_WFE, INS_WFI, INS_SEV, INS_SEVL,
    INS_NGC, INS_SBFIZ, INS_UBFIZ, INS_SBFX, INS_UBFX,
    INS_BFI, INS_BFXIL, INS_CMN, INS_MVN, INS_TST,
    INS_CSET, INS_CINC, INS_CSETM, INS_CINV, INS_CNEG,
    INS_SXTB, INS_SXTH, INS_SXTW, INS_CMP, INS_UXTB,
    INS_UXTH, INS_UXTW, INS_IC, INS_DC, INS_AT,
    INS_TLBI, INS_NEGS, INS_NGCS, INS_ENDING ##  <-- mark the end of the list of insn


## / Group of ARM64 instructions

type
  arm64_insn_group* = enum
    GRP_INVALID = 0,      ## /< = CS_GRP_INVALID
                        ##  Generic groups
                        ##  all jump instructions (conditional+direct+indirect jumps)
    GRP_JUMP,           ## /< = CS_GRP_JUMP
    GRP_CALL, GRP_RET, GRP_INT, GRP_PRIVILEGE = 6, ## /< = CS_GRP_PRIVILEGE
    GRP_BRANCH_RELATIVE, ## /< = CS_GRP_BRANCH_RELATIVE
                              ##  Architecture-specific groups
    GRP_CRYPTO = 128, GRP_FPARMV8, GRP_NEON, GRP_CRC, GRP_ENDING ##  <-- mark the end of the list of groups

