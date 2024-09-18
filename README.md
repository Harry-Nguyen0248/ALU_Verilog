# Quadratic ALU Solver & Restoring Division ALU

## Overview

This project consists of two distinct arithmetic logic unit (ALU) designs:

1. **Quadratic ALU Solver**: This ALU is designed to compute the quadratic equation `Ax² + Bx + C` for different values of `A`, `B`, `C`, and `x`. The solution is controlled by a finite state machine (FSM) that ensures the correct sequence of operations is executed.

2. **Restoring Division ALU**: This ALU performs division using the restoring division algorithm. It divides a 4-bit dividend by a 4-bit divisor, providing both a quotient and a remainder as outputs. The process is managed by an FSM that handles the subtraction and restoration cycles.

## Project Structure

The repository contains the following files:

- `quadratic_fsm.sv`: Implements the FSM that controls the quadratic ALU solver.
- `quadratic_datapath.sv`: Implements the datapath that performs the arithmetic operations for the quadratic equation.
- `division_fsm.sv`: Implements the FSM that controls the restoring division ALU.
- `division_datapath.sv`: Implements the datapath that performs the division operation using restoring division.
- `quadratic_test.do`: ModelSim/QuestaSim test script with multiple test cases for the Quadratic ALU Solver.
- `division_test.do`: ModelSim/QuestaSim test script with multiple test cases for the Restoring Division ALU.

## Quadratic ALU Solver

### Functionality

The **Quadratic ALU Solver** computes the result of the quadratic equation:

```
Result = A * x^2 + B * x + C
```

The system takes 4-bit inputs for `A`, `B`, `C`, and `x`, and uses an FSM to control the sequence of operations. The output is the computed result, which is stored in a register.

### Simulation

To simulate the **Quadratic ALU Solver**, you can use the `quadratic_test.do` file, which provides several test cases to verify the functionality of the ALU. Each test case will set the values of `A`, `B`, `C`, and `x`, and the simulation will run to compute the result.

### How to Run

1. Compile `quadratic_fsm.sv` and `quadratic_datapath.sv` in ModelSim/QuestaSim.
2. Load the design using:
   ```bash
   vsim work.quadratic_fsm work.quadratic_datapath
   ```
3. Run the `quadratic_test.do` script:
   ```bash
   do quadratic_test.do
   ```
4. Observe the results in the waveform view.

### Test Cases

Several test cases are included in the `quadratic_test.do` file to verify different input combinations. Example test cases include:

- **Test Case 1**: `A = 2`, `B = 3`, `C = 4`, `x = 1` (Expected result: `9`)
- **Test Case 2**: `A = 1`, `B = 1`, `C = 1`, `x = 2` (Expected result: `7`)
- **Test Case 3**: `A = 3`, `B = 2`, `C = 1`, `x = 2` (Expected result: `17`)

## Restoring Division ALU

### Functionality

The **Restoring Division ALU** performs integer division using a restoring division algorithm. It divides a 4-bit dividend by a 4-bit divisor and provides both the quotient and remainder as outputs. The FSM controls the flow of operations, handling the subtraction and restoration when necessary.

### Simulation

To simulate the **Restoring Division ALU**, you can use the `division_test.do` file, which provides multiple test cases to verify the functionality of the division process.

### How to Run

1. Compile `division_fsm.sv` and `division_datapath.sv` in ModelSim/QuestaSim.
2. Load the design using:
   ```bash
   vsim work.division_fsm work.division_datapath
   ```
3. Run the `division_test.do` script:
   ```bash
   do division_test.do
   ```
4. Observe the results in the waveform view.

### Test Cases

Several test cases are included in the `division_test.do` file to test the division process. Example test cases include:

- **Test Case 1**: `Dividend = 9`, `Divisor = 3` (Expected result: `Quotient = 3`, `Remainder = 0`)
- **Test Case 2**: `Dividend = 15`, `Divisor = 2` (Expected result: `Quotient = 7`, `Remainder = 1`)
- **Test Case 3**: `Dividend = 4`, `Divisor = 8` (Expected result: `Quotient = 0`, `Remainder = 4`)

## Tools

- **ModelSim** or **QuestaSim**: For simulation and verification of the SystemVerilog files.
- **Verilog/SystemVerilog**: The HDL used to design the FSM and datapath modules.

## Future Work

- Expand the ALU designs to handle additional arithmetic operations such as subtraction and multiplication for broader functionality.
- Optimize the FSM state transitions for faster processing in both the quadratic solver and division operations.
