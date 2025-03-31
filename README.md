# Using IEEE 754 Floating-Point Standard

IEEE 754 is a widely used standard for representing floating-point numbers in computers. It defines how real numbers are stored in binary form, ensuring consistency across different systems. The standard mainly defines two formats:

- **Single Precision (32-bit)**
- **Double Precision (64-bit)**

For our Verilog module, we are working with **Single Precision (32-bit)** representation.

## IEEE 754 Single Precision Format (32-bit)
This format consists of three main components:

| Component      | Bits | Description |
|---------------|------|-------------|
| **Sign**      | 1    | Determines whether the number is positive (0) or negative (1) |
| **Exponent**  | 8    | Stored in a biased format using 127 as the bias (Actual Exponent = Stored Exponent - 127) |
| **Mantissa**  | 23   | Stores the fractional part of the number with an implicit leading 1 (normalized representation) |

### Breakdown of Components

1. **Sign Bit (1 bit)**
   - `0`: Positive number
   - `1`: Negative number

2. **Exponent (8 bits)**
   - Stored in biased form, using **127** as the bias.
   - **Actual exponent** = `Stored exponent - 127`

   Example:
   - Exponent bits: `10000010` (130 in decimal)
   - Actual exponent = `130 - 127 = 3`

3. **Mantissa / Fraction (23 bits)**
   - The real fraction is assumed to have an implicit leading **1**, i.e., `1.XXX...` (normalized representation).

   Example:
   - If fraction = `10000000000000000000000`, the actual value = `1.5` in decimal.

## Example: Representing 13.25 in IEEE 754 (Single Precision)

1. Convert **13.25** to binary:
   - `13.25` → `1101.01`
2. Normalize to the form **1.xxxx × 2ⁿ**:
   - `1.10101 × 2³`
3. Determine the components:
   - **Sign Bit** = `0` (Positive number)
   - **Exponent** = `3 + 127 = 130` → `10000010`
   - **Mantissa** = `10101000000000000000000` (excluding the implicit 1.)
4. **Final IEEE 754 Representation**:
   - `0 10000010 10101000000000000000000`
5. **In Hexadecimal**:
   - `0x41540000`
