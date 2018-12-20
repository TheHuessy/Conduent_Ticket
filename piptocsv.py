##A little script that reads in the pipe-delineated files for tickets, replaces all commas with '--',
##all slashes ('\') with nothing (''), and then replaces all pipes ('|') with commas, creating new,
##easier to load csvs.

import csv
import os

fnames = []
##### CHECKING XEROX REPOSITORY #####
#for dirname, dirnames, filenames in os.walk('H:/My Documents/Git Code Examples/Conduent_Ticket/Data Imports/'):
for dirname, dirnames, filenames in os.walk('Z:/XEROX/'):
	for filename in filenames:
		if 'ticket_extract' in filename:
			#print(os.path.join(dirname,filename))	
			fnames.append(os.path.join(filename))


##### LOOKING AT WHAT HAS ALREADY BEEN TRANSFORMED #####
cnames = []
for dirname, dirnames, filenames in os.walk('H:/My Documents/Git Code Examples/Conduent_Ticket/Data Imports/Comma_Add/'):
	for filename in filenames:
		if 'ticket_extract' in filename:
			#print(os.path.join(dirname,filename))	
			cnames.append(os.path.join(filename))

##### CREATING LIST OF NEW FILE NAMES #####
#This is a little redundant but it allows me to produce more informative console outputs
nnames = []
for fn in fnames:
	if fn not in cnames:
		nnames.append(fn)

##### ITERATING THROUGH THE FILE NAMES THAT AREN'T PRESENT IN TRANSFORMED REPOSITORY #####
if len(nnames) > 0:
	for nn in nnames:
		with open(str('Z:/XEROX/'+nn), 'r') as file:
			filedata = file.read()
		filedata = filedata.replace(',', '--')
		filedata = filedata.replace('|', ',')
		filedata = filedata.replace('\\', '')
		with open('H:/My Documents/Git Code Examples/Conduent_Ticket/Data Imports/Comma_Add/'+nn, 'w') as file:
			file.write(filedata)
		print("Finished file conversion " + str(nnames.index(nn)+1) + " of " + str(len(nnames)))
	print("Goodbye")
else:
	print("No new datasets!")
	print("Goodbye")






