####################
## Set filenames! ##
####################

location = "Location of input/output file"
filename = "nucleotide_file.txt"
outputname = "nucleotide_output.txt"

###############
## Open file ##
###############

infile = open(location+filename,"r")
sequence = infile.read().replace("\r\n","").replace("\n","")
infile.close()

#print(sequence)

########################
## Set empty variable ##
########################

A=0
T=0
G=0
C=0
N=0
Nchar = ""

############################################
## For loop and check all the nucleotides ##
############################################

for nucleotide in sequence:
    if nucleotide == "A":
        A += 1
    elif nucleotide =="T":
        T += 1
    elif nucleotide == "G":
        G += 1
    elif nucleotide == "C":
        C += 1
    else:
        N += 1
        Nchar = Nchar + nucleotide

print(A,C,G,T)

if N > 0:
    print(f"\nWe had {N} numbers of other characters in the sequence.\n {Nchar}")

#######################
## Write output file ##
#######################

outfile = open(location+outputname,"w")
outfile.write(f"{A} {C} {G} {T}")
outfile.close()
