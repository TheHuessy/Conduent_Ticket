library(readr)
library(dplyr)
library(XML)
library(xml2)

##### Load most recent datasets #####

pay <- read.table("Z:/XEROX/payment_extract_181213.txt", sep = "|", header = TRUE, stringsAsFactors = FALSE)


f <- list.files(path = "Z:/XEROX/") %>% 
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
                  "Ticket.Issue.Time" = as.character())

lapply(tic, class)

for (i in 1:length(f)){
  pt <- paste("Z:/XEROX/", f[i], sep = "")
  g <- read.table(pt, sep = "|", header = TRUE, comment.char = "", stringsAsFactors = FALSE)
  ticq <- rbind(ticq, g)
  print(paste("Finished with", i, "of", length(f)))
}



tic <- read.table("Z:/XEROX/ticket_extract_181214.txt", sep = "|", header = TRUE, comment.char = "", stringsAsFactors = FALSE)
#tic <- read_delim("Z:/XEROX/ticket_extract_181214.txt", delim = "|", comment = "")
pen <- read.table("Z:/XEROX/penalty_extract_181214.txt", sep = "|", header = TRUE, stringsAsFactors = FALSE)
pay$Pay.Ticket.Number <- as.numeric(pay$Pay.Ticket.Number)
##### PAYMENT DATASETS #####


pay$Pay.Ticket.Number %in% tic$Ticket.Number

merge(x = tic, y = pay, by.x = 'Ticket.Number', by.y = 'Pay.Ticket.Number')


