library(readr)
library(dplyr)
library(civis)
#Good until Christmas +2 VV
Sys.setenv(CIVIS_API_KEY = 'e55b1cc634361b4a71cdd072d0dec1bfb8df0522aba379d7d2a422f124abf8ba')

##### LOAD IN DATASETS FROM CIVIS #####
tics <- read_civis('sandbox.conduent_tickets')
pays <- read_civis('sandbox.conduent_payments')
pens <- read_civis('sandbox.conduent_penalties')


##### EXPLORE TICKETS #####

head(tics)




 
# fulld <- merge(x = tics, y = pays, by.x = 'ticketnumber', by.y = 'payticketnumber')
# head(fulld)




#write_civis(ticq, 'sandbox.conduent_tickets', if_exists = "drop")
#write.csv(ticq, "H:/My Documents/Git Code Examples/Conduent_Ticket/tickets.csv", row.names = FALSE)
#write_civis(payq, 'sandbox.conduent_payments', if_exists = "drop")
#write_civis(penq, 'sandbox.conduent_penalties', if_exists = "drop")



