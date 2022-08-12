# code challenge using python

import sys
import statistics
from statistics import mode

def main ():

    try:
        arg = sys.argv[1]
    except IndexError:
        raise SystemExit(f"Usage: {sys.argv[0]} <puzzle_input_file>")

    #open file into list of lines
    with open(sys.argv[1],"r") as file:
        lines = file.read().splitlines() #use splitlines to get a each line as its own entry in list

    #now list stuff
    #get length of the list
    length = len(lines)
    line_length = len(lines[0])
    print(f"There are {length} lines in the file")
    print(f"The first line is {line_length} bits")
    print("Checking if all other bits are the same length", end =": ")
    

    for index,line in enumerate(lines):
        lines[index] = list(line)
        temp_length = len(line)
        if(temp_length != line_length) :
            print(f"ERROR the input at index {index}: {line} is not the same length as the first line with length of {line_length}" )
            exit(1)
   
    print("PASS")

    #now iterating per position
    gamma = get_most_common(lines,line_length)

    #convert to string
    gamma_rate = ''.join(map(str, gamma))
    epsilon_rate = inverse_string(gamma_rate) 

    print(f"  gamma binary: {gamma_rate}    gamma decimal: {int(gamma_rate,2)}")
    print(f"epsilon binary: {epsilon_rate}  epsilon decimal: {int(epsilon_rate,2)}")

    #get O2
    #find most common value per bit position (gamma)
    #parse list to only consider entries starting with that value
    
#    o2list = lines.copy()
#    for i in range(line_length):
#        o2mostcommon=get_most_common(o2list,line_length)
#        o2list = parse_list(o2list,i,o2mostcommon[i])
#        if (len(o2list) == 1): break
#
#
#    co2list = lines.copy()
#    for i in range(line_length):
#        co2mostcommon=get_most_common(co2list,line_length)
#        co2leastcommon = inverse_string(str(co2mostcommon[i]))
#        co2list = parse_list(co2list,i,int(co2leastcommon))
#        if (len(co2list) == 1): break

    o2list  = scrub_list(lines,line_length,0)
    co2list = scrub_list(lines,line_length,1)


    o2 = get_most_common(o2list,line_length)
    co2 = get_most_common(co2list,line_length)

    o2_rate = ''.join(map(str,o2))
    co2_rate = ''.join(map(str,co2))

    print(f"     o2 binary: {o2_rate}       o2 decimal: {int(o2_rate,2)}")
    print(f"    co2 binary: {co2_rate}      co2 decimal: {int(co2_rate,2)}")



def get_most_common(inputlist,line_length):

    #for any input list return the most common value by index
    #ie
    #101
    #001
    #010
    #101
    # returns
    #101
    #if same number of 1,0 return 1

    bit = [0] * (line_length)
    threshold = (len(inputlist) / 2)

    for i in range(line_length):
        sum = 0 

        for j in range(len(inputlist)):
                line = inputlist[j]
                sum += int(line[i])
        if (sum >= threshold): bit[i]=1

    return(bit)
                

def inverse_string(inputstring):
    b_dict = {'0':'1','1':'0'}
    outstring = ''
    for i in inputstring:
        outstring += b_dict[i]
    return(outstring)


def parse_list(inputlist, position, value):
    outlist = []
    for i, line in enumerate(inputlist):
        inputlist[i] = list(line)
        if (int(line[position]) == value):
            outlist.append(line)

    return(outlist)

def scrub_list(inputlist, line_length, lcm):
    mylist = inputlist.copy()
    for i in range(line_length):
        mostcommon=get_most_common(mylist,line_length)
        if lcm:
            parselistval = inverse_string(str(mostcommon[i]))
        else:
            parselistval = mostcommon[i]
        mylist = parse_list(mylist,i,int(parselistval))
        if (len(mylist) == 1): break
    return(mylist)

main()





