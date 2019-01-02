library(readr)
library(dplyr)
library(XML)
library(xml2)


##### Load most recent datasets #####
system("cmd.exe", input ='python "H:/My Documents/Git Code Examples/Conduent_Ticket/piptocsv.py"')

print("Python done doing its magic")

##### Combining Ticket Data #####
f <- list.files(path = "H:/My Documents/Git Code Examples/Conduent_Ticket/Data Imports/Comma_Add") %>% 
  .[grep("ticket_extract",.)]


ticq <- data.frame("Agency.Name..Issuing.Agency." = as.character(),
                  "Ticket.Number" = as.numeric(),
                  "Ticket.Issue.Date" = as.numeric(),
                  "Ticket.Proc.Date" = as.character(),
                  "Batch.Date" = as.character(),
                  "Batch.Number" = as.numeric(),
                  "Badge....Issuing.Officer." = as.numeric(),
                  "Issuing.Officer.Division" = as.numeric(),
                  "Route" = as.character(),
                  "Street.No" = as.numeric(),
                  "Issuing.Officer.Name" = as.character(),
                  "Street.Name" = as.character(),
                  "Street.Direction" = as.character(),
                  "Street.Suffix" = as.character(),
                  "Amount.Due" = as.numeric(),
                  "Rp.Name" = as.character(),
                  "Make" = as.character(),
                  "Rp.Plate.State" = as.character(),
                  "Rp.Plate" = as.character(),
                  "Rp.Plate.Type" = as.character(),
                  "Plate.Color" = as.character(),
                  "Vehicle.Color" = as.character(),
                  "Vehicle.Color.Desc" = as.character(),
                  "Violation.Code" = as.character(),
                  "Violation.Type" = as.character(),
                  "Violation.Type.Desc" = as.character(),
                  "Violation.Class.Id" = as.character(),
                  "Violation.Class.Desc" = as.character(),
                  "Violation.Desc" = as.character(),
                  "Ticket.Issue.Time" = as.character()
                  )


for (i in 1:length(f)){
  pt <- paste("H:/My Documents/Git Code Examples/Conduent_Ticket/Data Imports/Comma_Add/", f[i], sep = "")
  g <- read.csv(pt, header = TRUE, comment.char = "", stringsAsFactors = FALSE, fill = TRUE)
  ticq <- rbind(ticq, g)
  print(paste("Finished with", i, "of", length(f)))
}

head(ticq)

##### Combining Payment Data #####

pf <- list.files(path = "Z:/XEROX/") %>% 
  .[grep("payment_extract",.)]


payq <- data.frame("Pay.Type" = as.character(),
                   "Pay.Ticket.Number" = as.numeric(),
                   "Pay.Accnt.Desc" = as.character(),
                   "Pay.Method" = as.character(),
                   "Pay.Proc.Date" = as.character(),
                   "Pay.Proc.Time" = as.character(),
                   "Pay.Deposit.Date" = as.character(),
                   "Pay.Batch.Num" = as.numeric(),
                   "Pay.Clerk" = as.character(),
                   "Payment.Amt" = as.numeric())




for (i in 1:length(pf)){
  pt <- paste("Z:/XEROX/", pf[i], sep = "")
  g <- read.table(pt, sep = "|", header = TRUE, comment.char = "", stringsAsFactors = FALSE, fill = TRUE)
  payq <- rbind(payq, g)
  print(paste("Finished with", i, "of", length(f)))
}

head(payq)

##### Combining Penalty Data #####

f <- list.files(path = "Z:/XEROX/") %>% 
  .[grep("penalty_extract",.)]


penq <- data.frame("Ticket.Number" = as.numeric(),
                   "Ticket.Issue.Date" = as.character(),
                   "Ticket.Proc.Date" = as.character(),
                   "Amount.Due" = as.numeric(),
                   "Total.Fine.Amount" = as.numeric(),
                   "Interest.Due" = as.character(),
                   "Fine.Amount" = as.numeric(),
                   "Penalty.1" = as.numeric(),
                   "Penalty.2" = as.character(),
                   "Penalty.3" = as.character(),
                   "Penalty.4" = as.character(),
                   "Penalty.5" = as.character(),
                   "Reduction.Amount" = as.numeric(),
                   "Total.Paid" = as.numeric(),
                   "Unapplied.Amount" = as.character(),
                   "Penalty.Date..1st.Occurrence." = as.character(),
                   "Penalty.Date..2nd.Occurrence." = as.character(),
                   "Penalty.Date..3rd.Occurrence." = as.character()
                   )




for (i in 1:length(f)){
  pt <- paste("Z:/XEROX/", f[i], sep = "")
  g <- read.table(pt, sep = "|", header = TRUE, comment.char = "", stringsAsFactors = FALSE, fill = TRUE)
  penq <- rbind(penq, g)
  print(paste("Finished with", i, "of", length(f)))
}

#head(penq)

#Good until Christmas VV
Sys.setenv(CIVIS_API_KEY = 'd2fa85f949d28d5ecd911f7f25a882156a05679e697bb9ef55b961f3525e8903')

library(civis)

write_civis(ticq, 'sandbox.conduent_tickets', if_exists = "drop")
#write.csv(ticq, "H:/My Documents/Git Code Examples/Conduent_Ticket/tickets.csv", row.names = FALSE)
write_civis(payq, 'sandbox.conduent_payments', if_exists = "drop")
write_civis(penq, 'sandbox.conduent_penalties', if_exists = "drop")



