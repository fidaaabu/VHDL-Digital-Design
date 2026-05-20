
# LAB1 - VHDL Part 1

The purpose of this lab was to design and implement a simple ALU-like system using VHDL, while focusing on concurrent hardware design. The system is composed of several independent modules, where each module performs a specific type of operation. The active module is selected using the control signal 'ALUFN' .

## System Overview

The system receives two input vectors, 'X' and 'Y', together with a control signal 'ALUFN' .  
The two most significant bits of `ALUFN` determine which module is activated:

- '01' – arithmetic operations (AdderSub)  
- '10' – shift operations (Shifter)  
- '11' – logical operations (Logic)  

The lower bits of 'ALUFN'  define the exact operation inside the selected module.

## Inputs and Outputs

### Inputs:
- 'X' – input vector  
- 'Y' – input vector  
- 'ALUFN' – control signal  

### Outputs:
- 'ALUout' – the result of the selected operation  
- 'Z' – indicates whether the result is zero  
- 'C' – carry output  
- 'N' – indicates whether the result is negative  
- 'V' – indicates overflow in arithmetic operations  

---

## AdderSub Module ('AdderSub.vhd')

This module performs arithmetic operations between 'X' and 'Y'.  
Depending on the control input, it supports addition, subtraction, and negation.  
The implementation is based on a ripple-carry structure using multiple Full Adders connected in sequence.

---

## Shifter Module ('Shifter.vhd')

The Shifter module performs shift operations on the input `Y`.  
According to the control signal, the data is shifted either to the left or to the right.  
The design is implemented as a barrel shifter, using several stages, where each stage conditionally shifts the data based on the corresponding bit in `X`.

---

## Logic Module ('Logic.vhd')

This module handles logical operations between `X` and `Y`, such as AND, OR, XOR, and others.  
The required operation is selected according to the control bits, and the result is generated using standard VHDL logical operators.

---

## Top Module ('top.vhd')

The Top module connects all sub-modules together and controls the flow of data.  
It selects the appropriate module based on `ALUFN`, routes the inputs accordingly, and outputs the final result.  
Additionally, the flags are determined based on the final output.

---

## Full Adder ('FA.vhd')

This module implements a basic Full Adder, which is used as a building block in the arithmetic unit.

---

## Package ('aux_package.vhd')

This file includes the component declarations required for connecting the different modules in the system.

---
