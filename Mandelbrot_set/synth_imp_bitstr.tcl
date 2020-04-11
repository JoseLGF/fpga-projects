# Open project with relative path
open_project ./work/Mandelbrot_set/Mandelbrot_set.xpr

# updates the compile order based on the settings defined
# in the project file (*.xpr)
update_compile_order -fileset sources_1


# reset previous simulation files (deletes old data)
reset_run synth_1

# synth_1 is a job described in the xpr file
launch_runs synth_1 -jobs 4
wait_on_run synth_1

puts "Synthesis completed"

# Runs the implementation and
# Generate the bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

puts "Bitstream generation completed"