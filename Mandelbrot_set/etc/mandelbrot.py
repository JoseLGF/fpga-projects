# Mandelbrot set generator
# This program generates the mandelbrot set based on the inputs provided to it.
# Inputs:
#	1. The x position of the center of the display
#	2. The y position of the center of the display
#	3. The zoom level of the view
#	4. The number of iterations for each point
# Outputs:
#	1. An image file containing the generated mandelbrot set
#	2. A log file containing all the values required for generating the image

from PIL import Image
import numpy as np
import sys

def main():
	# arguments parse
	number_params = 3
	if not (len(sys.argv) == number_params+1):
		print("Error, wrong number of arguments provided")
		exit(1)

	# Arguments check
	center_x	= float(sys.argv[1])
	center_y	= float(sys.argv[2])
	zoom_lvl	= float(sys.argv[3])
	max_iter	= 100
	
	coords = scale_view(center_x, center_y, zoom_lvl)
	iterations = []
	# calculate the mandelbrot function for each individual point
	for point in coords:
		iterations.append(mandelbrot(point[0], point[1], max_iter))
		
	# generate the image with the iterations vector
	generate_image(iterations)


def mandelbrot(c_x, c_y, max_iter):
	# This function repeats the complex calculation repeatedly and returns the
	# iteration where the function diverges, or the max iteration.
	iter = 0
	x = 0
	y= 0
	while(x*x + y*y <= 2*2 and iter < max_iter):
		x_temp	= x*x - y*y	+ c_x
		y 		= 2*x*y 	+ c_y
		x		= x_temp
		iter	= iter + 1
	
	return iter

def scale_view(center_x, center_y, zoom_lvl):
	# returns a list of 640 x 480 (x, y) values corresponding to the points on
	# the view point.
	
	# screen resolution
	res_x = 640
	res_y = 480
	
	coords = []
	
	for screen_x in range(0, res_x):
		for screen_y in range(0, res_y):
			coords.append(\
				scale_point(screen_x, screen_y, center_x, center_y, zoom_lvl))
				
	return coords

def scale_point(screen_x, screen_y, center_x, center_y, zoom_lvl):
	# Maps a point on the screen to a point in the complex plane.
	# A zoom level of 1 maps the view to the area:
	# x: [-2.5, 1]
	# y: [-1  , 1]
	
	x = translate(screen_x, 0, 639, -2.5, 1)
	y = translate(screen_y, 0, 479, -1  , 1)
	
	return x, y

def translate(value, old_min, old_max, new_min, new_max):
	# translates a value in a range to a value in a new range.
    # Figure out how 'wide' each range is
    old_span = old_max - old_min
    new_span = new_max - new_min

    # Convert the left range into a 0-1 range (float)
    valueScaled = float(value - old_min) / float(old_span)

    # Convert the 0-1 range into a value in the right range.
    return new_min + (valueScaled * new_span)
	

def generate_image(iterations):
	# code to generate an image using PIL
	w, h = 640, 480
	data = np.zeros((h, w, 3), dtype=np.uint8)
	
	print("iterations vector: " + str(len(iterations)))
	print("Writing values to image")
	for x in range(640):
		for y in range(480):
			val = 2 * iterations[x*480 + y]
			#print("x: " + str(x) + ", y: " + str(y) + " -> " + str(val))
			data[y, x] = [val, 0, 0] 
	
	img = Image.fromarray(data, 'RGB')
	img.save('my.png')
	print("Finished writing to image")

if __name__ == "__main__":
	main()



