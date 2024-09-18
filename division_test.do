# Load design
vsim work.division_fsm work.division_datapath

# Setup wave signals
add wave -r /*

# Initialize signals
force -freeze sim:/division_fsm/clk 0 0, 1 50 -r 100
force -freeze sim:/division_fsm/reset 1
force -freeze sim:/division_fsm.go 0
force -freeze sim:/division_fsm.dividend 0
force -freeze sim:/division_fsm.divisor 0

# Reset the system
run 100ns
force -freeze sim:/division_fsm/reset 0

# Test Case 1: Dividend = 9, Divisor = 3 (9 / 3 = 3, remainder 0)
force -freeze sim:/division_fsm.dividend 4'b1001  # Dividend = 9
force -freeze sim:/division_fsm.divisor 4'b0011   # Divisor = 3
force -freeze sim:/division_fsm.go 1
run 500ns
force -freeze sim:/division_fsm.go 0
run 500ns

# Test Case 2: Dividend = 15, Divisor = 2 (15 / 2 = 7, remainder 1)
force -freeze sim:/division_fsm.dividend 4'b1111  # Dividend = 15
force -freeze sim:/division_fsm.divisor 4'b0010   # Divisor = 2
force -freeze sim:/division_fsm.go 1
run 500ns
force -freeze sim:/division_fsm.go 0
run 500ns

# Test Case 3: Dividend = 7, Divisor = 1 (7 / 1 = 7, remainder 0)
force -freeze sim:/division_fsm.dividend 4'b0111  # Dividend = 7
force -freeze sim:/division_fsm.divisor 4'b0001   # Divisor = 1
force -freeze sim:/division_fsm.go 1
run 500ns
force -freeze sim:/division_fsm.go 0
run 500ns

# Test Case 4: Dividend = 12, Divisor = 5 (12 / 5 = 2, remainder 2)
force -freeze sim:/division_fsm.dividend 4'b1100  # Dividend = 12
force -freeze sim:/division_fsm.divisor 4'b0101   # Divisor = 5
force -freeze sim:/division_fsm.go 1
run 500ns
force -freeze sim:/division_fsm.go 0
run 500ns

# Test Case 5: Dividend = 6, Divisor = 4 (6 / 4 = 1, remainder 2)
force -freeze sim:/division_fsm.dividend 4'b0110  # Dividend = 6
force -freeze sim:/division_fsm.divisor 4'b0100   # Divisor = 4
force -freeze sim:/division_fsm.go 1
run 500ns
force -freeze sim:/division_fsm.go 0
run 500ns

# Test Case 6: Dividend = 4, Divisor = 8 (4 / 8 = 0, remainder 4)
force -freeze sim:/division_fsm.dividend 4'b0100  # Dividend = 4
force -freeze sim:/division_fsm.divisor 4'b1000   # Divisor = 8
force -freeze sim:/division_fsm.go 1
run 500ns
force -freeze sim:/division_fsm.go 0
run 500ns

# Test Case 7: Dividend = 0, Divisor = 3 (0 / 3 = 0, remainder 0)
force -freeze sim:/division_fsm.dividend 4'b0000  # Dividend = 0
force -freeze sim:/division_fsm.divisor 4'b0011   # Divisor = 3
force -freeze sim:/division_fsm.go 1
run 500ns
force -freeze sim:/division_fsm.go 0
run 500ns

# End simulation
quit
