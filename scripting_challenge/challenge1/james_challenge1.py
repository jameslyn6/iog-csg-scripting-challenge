#!/usr/intel/bin/python3.7.4
#######################################################################
# INTEL CONFIDENTIAL
# Copyright 2022 Intel Corporation All Rights Reserved.
#
# FILE:  day3.py
# AUTHOR:  James Lynch (jameslyn)
# USAGE: run in shell
# DESCRIPTION: this script reads "puzzle_input.txt" from Advent of Code
# Day 3 into a list and computes "gamma rate" and "epsilon rate" which 
# is then multiplied together to produce the power consumption
# VERSION:
#   1.0, 6/20/2022
#
#######################################################################
import statistics
from statistics import mode

def main():
        gamma_rate = ""
        epsilon_rate = ""

        with open("puzzle_input.txt", 'r', encoding='utf-8') as file:
                lines = file.read().splitlines() #read text file lines into a list
                for index, line in enumerate(lines):
                        lines[index] = list(line) #creates a list of each character in every line in list "lines"
                        
        for i in range(len(line)): # goes through every character in each line
                gamma_rate += mode([line[i] for line in lines]) # iterates through each column of "lines" and appends the mode of that column to the string "gamma_rate"

        epsilon_rate = gamma_rate.replace('1', '2')
        epsilon_rate = epsilon_rate.replace('0', '1')
        epsilon_rate = epsilon_rate.replace('2', '0') # not's gamma_rate to get epsilon_rate

        power_consumption = int(gamma_rate, 2) * int(epsilon_rate, 2) #converts epsilon and gamma rate to integers and multiplies together to get power consumption
        print("The epsilon rate is: " + str(int(epsilon_rate, 2)) + " (" + epsilon_rate + ")" + '\n' + "The gamma rate is: " + str(int(gamma_rate, 2)) + " (" + gamma_rate + ")" + '\n' + "The total power consumption is: " + str(power_consumption)) #converts the integeres to strings to print to shell
        
main()