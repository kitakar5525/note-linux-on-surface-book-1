/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190215 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembly of hpet.dat, Wed Mar 27 22:13:21 2019
 *
 * ACPI Data Table [HPET]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "HPET"    [High Precision Event Timer table]
[004h 0004   4]                 Table Length : 00000038
[008h 0008   1]                     Revision : 01
[009h 0009   1]                     Checksum : 91
[00Ah 0010   6]                       Oem ID : "MSFT  "
[010h 0016   8]                 Oem Table ID : "MSFT    "
[018h 0024   4]                 Oem Revision : 00000001
[01Ch 0028   4]              Asl Compiler ID : "MSFT"
[020h 0032   4]        Asl Compiler Revision : 0000005F

[024h 0036   4]            Hardware Block ID : 8086A201

[028h 0040  12]         Timer Block Register : [Generic Address Structure]
[028h 0040   1]                     Space ID : 00 [SystemMemory]
[029h 0041   1]                    Bit Width : 40
[02Ah 0042   1]                   Bit Offset : 00
[02Bh 0043   1]         Encoded Access Width : 00 [Undefined/Legacy]
[02Ch 0044   8]                      Address : 00000000FED00000

[034h 0052   1]              Sequence Number : 00
[035h 0053   2]          Minimum Clock Ticks : 0080
[037h 0055   1]        Flags (decoded below) : 00
                             4K Page Protect : 0
                            64K Page Protect : 0

Raw Table Data: Length 56 (0x38)

    0000: 48 50 45 54 38 00 00 00 01 91 4D 53 46 54 20 20  // HPET8.....MSFT  
    0010: 4D 53 46 54 20 20 20 20 01 00 00 00 4D 53 46 54  // MSFT    ....MSFT
    0020: 5F 00 00 00 01 A2 86 80 00 40 00 00 00 00 D0 FE  // _........@......
    0030: 00 00 00 00 00 80 00 00                          // ........
