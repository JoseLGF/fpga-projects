print ("Running the MAC sequence generator.")

# List of input values
values = [
	[1,5],
	[2,6],
	[3,7],
	[4,8],
	[0,0],
	[1,5],
	[2,6],
	[3,7],
	[4,8],
	[5,9]
]

print ("Input values: " + str(values))

# mac state variables
mac_prod = 0
mac_acc  = 0

# perform the mac function
exec_step = 0

while exec_step < len(values):
	# This iteration's values
	step_values = values[exec_step]
	# multiply
	mac_prod = step_values[0] * step_values[1]
	# accumulate with previous values
	mac_acc = mac_acc + mac_prod
	
	print("Iteration " + str(exec_step) + ": " + str(mac_acc))
	exec_step = exec_step + 1

print ("MAC final result: " + str(mac_acc))

