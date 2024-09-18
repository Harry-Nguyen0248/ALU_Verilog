# Load the design for part2 (quadratic equation ALU)
vsim work.quadratic_fsm work.quadratic_datapath

# Setup wave signals for observation
add wave -r /*

# Initialize signals
force -freeze sim:/quadratic_fsm/clk 0 0, 1 50 -r 100
force -freeze sim:/quadratic_fsm/reset 1
force -freeze sim:/quadratic_fsm.go 0
force -freeze sim:/quadratic_fsm.A 0
force -freeze sim:/quadratic_fsm.B 0
force -freeze sim:/quadratic_fsm.C 0
force -freeze sim:/quadratic_fsm.x 0

# Reset the system
run 100ns
force -freeze sim:/quadratic_fsm/reset 0

# Test Case 1: A = 2, B = 3, C = 4, x = 1 (2*1^2 + 3*1 + 4 = 9)
force -freeze sim:/quadratic_fsm.A 4'b0010   # A = 2
force -freeze sim:/quadratic_fsm.B 4'b0011   # B = 3
force -freeze sim:/quadratic_fsm.C 4'b0100   # C = 4
force -freeze sim:/quadratic_fsm.x 4'b0001   # x = 1
force -freeze sim:/quadratic_fsm.go 1        # Start calculation
run 500ns
force -freeze sim:/quadratic_fsm.go 0
run 500ns

# Test Case 2: A = 1, B = 1, C = 1, x = 2 (1*2^2 + 1*2 + 1 = 7)
force -freeze sim:/quadratic_fsm.A 4'b0001   # A = 1
force -freeze sim:/quadratic_fsm.B 4'b0001   # B = 1
force -freeze sim:/quadratic_fsm.C 4'b0001   # C = 1
force -freeze sim:/quadratic_fsm.x 4'b0010   # x = 2
force -freeze sim:/quadratic_fsm.go 1        # Start calculation
run 500ns
force -freeze sim:/quadratic_fsm.go 0
run 500ns

# Test Case 3: A = 3, B = 2, C = 1, x = 2 (3*2^2 + 2*2 + 1 = 17)
force -freeze sim:/quadratic_fsm.A 4'b0011   # A = 3
force -freeze sim:/quadratic_fsm.B 4'b0010   # B = 2
force -freeze sim:/quadratic_fsm.C 4'b0001   # C = 1
force -freeze sim:/quadratic_fsm.x 4'b0010   # x = 2
force -freeze sim:/quadratic_fsm.go 1        # Start calculation
run 500ns
force -freeze sim:/quadratic_fsm.go 0
run 500ns

# Test Case 4: A = 0, B = 1, C = 1, x = 3 (0*3^2 + 1*3 + 1 = 4)
force -freeze sim:/quadratic_fsm.A 4'b0000   # A = 0
force -freeze sim:/quadratic_fsm.B 4'b0001   # B = 1
force -freeze sim:/quadratic_fsm.C 4'b0001   # C = 1
force -freeze sim:/quadratic_fsm.x 4'b0011   # x = 3
force -freeze sim:/quadratic_fsm.go 1        # Start calculation
run 500ns
force -freeze sim:/quadratic_fsm.go 0
run 500ns

# Test Case 5: A = 2, B = 0, C = 1, x = 3 (2*3^2 + 0*3 + 1 = 19)
force -freeze sim:/quadratic_fsm.A 4'b0010   # A = 2
force -freeze sim:/quadratic_fsm.B 4'b0000   # B = 0
force -freeze sim:/quadratic_fsm.C 4'b0001   # C = 1
force -freeze sim:/quadratic_fsm.x 4'b0011   # x = 3
force -freeze sim:/quadratic_fsm.go 1        # Start calculation
run 500ns
force -freeze sim:/quadratic_fsm.go 0
run 500ns

# Test Case 6: A = 4, B = 2, C = 0, x = 2 (4*2^2 + 2*2 + 0 = 24)
force -freeze sim:/quadratic_fsm.A 4'b0100   # A = 4
force -freeze sim:/quadratic_fsm.B 4'b0010   # B = 2
force -freeze sim:/quadratic_fsm.C 4'b0000   # C = 0
force -freeze sim:/quadratic_fsm.x 4'b0010   # x = 2
force -freeze sim:/quadratic_fsm.go 1        # Start calculation
run 500ns
force -freeze sim:/quadratic_fsm.go 0
run 500ns

# Test Case 7: A = 1, B = 0, C = 5, x = 3 (1*3^2 + 0*3 + 5 = 14)
force -freeze sim:/quadratic_fsm.A 4'b0001   # A = 1
force -freeze sim:/quadratic_fsm.B 4'b0000   # B = 0
force -freeze sim:/quadratic_fsm.C 4'b0101   # C = 5
force -freeze sim:/quadratic_fsm.x 4'b0011   # x = 3
force -freeze sim:/quadratic_fsm.go 1        # Start calculation
run 500ns
force -freeze sim:/quadratic_fsm.go 0
run 500ns

# End simulation
quit
