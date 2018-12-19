import os

fnames = []
#print(fnames)

for dirname, dirnames, filenames in os.walk('H:/My Documents/Git Code Examples/Conduent_Ticket/Data Imports/'):
	for filename in filenames:
		if 'ticket_extract' in filename:
			#print(os.path.join(dirname,filename))	
			fnames.append(os.path.join(dirname,filename))

#for fn in fnames:
fn = fnames[1]
with open(fn, 'r') as file:
	filedata = file.read()
filedata = filedata.replace('|', ',')
with open(fn, 'w') as file:
	file.write(filedata)