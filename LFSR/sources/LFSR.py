# -*- coding: utf-8 -*-
"""
Created on Thu Nov  1 20:52:32 2018

@author: Luis German

This program calculates and prints the outputs of a linear-feedback shift register.
"""

start_state = 0b01001101
lfsr = start_state
period = 0 # counts the period of the LFSR



# left-shift a number R n times
def ls (R, n):
    for i in range(n):
        R *= 2
    return R
    
# right-shift a number R n times
def rs (R, n):
    for i in range(n):
        R = int(R/2)
    return R

# returns the next state of the lfsr    
def get_next(state):
    # taps: 3, 4, 5, 7
    # 4, 3, 2, 0
    bit = ( rs(state, 4) ^ rs(state, 3) ^ rs(state, 2) ^ rs(state, 0) ) & 1
    next_state = rs(state, 1) + ls(bit, 7)
    return next_state
    
# returns a string representation of an integer n as binary with b bits
def NbitBinary(n,b):
    out = ''
    for i in range(b):
        if (n%2 == 1):
            out += '1'
        else:
            out += '0'
        n = int(n/2)
    return out[::-1]
    
# program start
print(start_state)
print(hex(start_state))
lfsr = get_next(start_state)
period += 1

while(not (lfsr == start_state)):
    print(NbitBinary(lfsr, 8) + " -> " + hex(lfsr) + " -> " + str(lfsr))
    lfsr = get_next(lfsr)
    period += 1

print("Period:")
print(period)