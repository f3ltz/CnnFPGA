# IEEE 754 Floating-Point Adder in Verilog

## Overview
This Verilog module, `IEEEAdd`, implements a 32-bit floating-point addition operation following the IEEE 754 standard. It takes two 32-bit floating-point numbers as inputs and computes their sum, handling normalization, exponent alignment, and sign management.

## Features
- Handles special cases such as zero inputs and equal & opposite numbers.
- Aligns the exponent of both operands before performing addition.
- Supports both positive and negative floating-point values.
- Performs normalization after addition to maintain IEEE 754 format.

## Inputs and Outputs
| Port | Direction | Size | Description |
|------|----------|------|-------------|
| `floatA` | Input | 32 bits | First floating-point number |
| `floatB` | Input | 32 bits | Second floating-point number |
| `sum` | Output | 32 bits | The computed sum of `floatA` and `floatB` |

## Functional Description
### 1. Extracting Components
The module extracts the **sign**, **exponent**, and **mantissa** from both input numbers:
```verilog
exponentA = floatA[30:23];
exponentB = floatB[30:23];
fractionA = {1'b1, floatA[22:0]};
fractionB = {1'b1, floatB[22:0]};
```
- The leading 1 is added to the mantissa for normalization.
- Special cases are handled (e.g., if one of the inputs is zero, return the other).

### 2. Exponent Alignment
- If the exponents are different, the smaller number's mantissa is **right-shifted** to align with the larger exponent.

### 3. Addition or Subtraction
- If both numbers have the **same sign**, their mantissas are added.
- If they have **opposite signs**, the module performs subtraction and determines the correct sign of the result.

### 4. Normalization
After addition or subtraction, the result is **normalized** by left-shifting the mantissa and adjusting the exponent.

### 5. Packing the Result
Finally, the computed **sign, exponent, and mantissa** are combined into a 32-bit IEEE 754 format:
```verilog
sum = {sign, exponent, mantissa};
```

## Usage
This module can be instantiated in a larger design, such as a neural network accelerator or DSP system, to perform floating-point arithmetic operations efficiently in hardware.


