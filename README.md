# Using IEEE 754 Floating-Point Adder in Verilog
## Overview
The IEEEAdd module is a Verilog implementation of a 32-bit floating-point adder that follows the IEEE 754 standard. It takes two 32-bit floating-point numbers as inputs and computes their sum while handling exponent alignment, normalization, and sign management.
## IEEE 754 Single Precision Floating-Point Representation
The IEEE 754 standard defines how floating-point numbers are represented in binary form to ensure consistency across computing systems. The **Single Precision (32-bit)** format consists of three key components:
### 1. Sign Bit (1 bit)
- **0** → Positive number   - **1** → Negative number
### 2. Exponent (8 bits)
- Stored in **biased format** with a bias of **127**.
- Actual exponent = Stored exponent - 127
### 3. Mantissa / Fraction (23 bits)
- Stores the fractional part of the number.
- Has an **implicit leading 1** in normalized form.
### Example: Representing 13.25 in IEEE 754 Format
1. Convert **13.25** to binary: **1101.01**
2. Normalize: **1.10101 × 2³**
3. Encode the components:
   - **Sign Bit** = 0 (Positive)
   - **Exponent** =3 + 127 = 130 → 10000010
   - **Mantissa** = 10101000000000000000000
4. Final IEEE 754 Representation: 0 10000010 10101000000000000000000
5. **Hexadecimal Representation**:0x41540000
## Features of IEEEAdd Module
 Handles special cases like zero inputs and equal & opposite numbers.
 Aligns exponents before performing addition.
 Supports both positive and negative floating-point values.
 Performs normalization after addition to maintain IEEE 754 compliance.
## Inputs and Outputs
| Signal  | Direction | Width | Description |
|---------|----------|-------|-------------|
| floatA | Input | 32 bits | First floating-point number |
| floatB | Input | 32 bits | Second floating-point number |
| sum | Output | 32 bits | Computed sum in IEEE 754 format |
