##A little script that reads in the pipe-delineated files for tickets, replaces all commas with '--',
##all slashes ('\') with nothing (''), and then replaces all pipes ('|') with commas, creating new,
##easier to load csvs.

import csv
import os

fnames = []

for dirname, dirnames, filenames in os.walk('H:/My Documents/Git Code Examples/Conduent_Ticket/Data Imports/'):
	for filename in filenames:
		if 'ticket_extract' in filename:
			#print(os.path.join(dirname,filename))	
			fnames.append(os.path.join(filename))

os.chdir('H:/My Documents/Git Code Examples/Conduent_Ticket/Data Imports/')

for fn in fnames:
	with open(fn, 'r') as file:
		filedata = file.read()
	filedata = filedata.replace(',', '--')
	filedata = filedata.replace('|', ',')
	filedata = filedata.replace('\\', '')
	with open('Comma_Add/'+fn, 'w') as file:
		file.write(filedata)
	print("Finished file conversion " + str(fnames.index(fn)+1) + " of " + str(len(fnames)))
