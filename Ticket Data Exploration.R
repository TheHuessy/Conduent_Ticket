library(readr)
library(dplyr)
library(civis)
library(lubridate)
#Good until Christmas +2 VV
Sys.setenv(CIVIS_API_KEY = 'e55b1cc634361b4a71cdd072d0dec1bfb8df0522aba379d7d2a422f124abf8ba')

##### LOAD IN DATASETS FROM CIVIS #####
tics <- read_civis('sandbox.conduent_tickets')
pays <- read_civis('sandbox.conduent_payments')
pens <- read_civis('sandbox.conduent_penalties')


##### EXPLORE TICKETS #####

head(tics)

#This field shows that tickets are "issued" on random days, some of which have yet to happen
sort(unique(as.Date(as.character(tics$ticketissuedate), format = "%m/%d/%Y")))

#Processing date seems to be a better match as it shows the date that the ticket was printed
sort(unique(as.Date(as.character(tics$ticketprocdate), format = "%m/%d/%Y")))
tics[which(as.Date(as.character(tics$ticketprocdate), format = "%m/%d/%Y") == "2018-11-18"),]

#example of misleading ticket from 2019 (it was 12/2018 when this was run...)
tics[which(year(as.Date(as.character(tics$ticketissuedate), format = "%m/%d/%Y")) == "2019"),]

##### ISSUING AUTHORITY #####

#get list of issuing authorities
ia <- unique(as.character(tics$agencynameissuingagency)) %>% 
  .[which(. != "")]

df.ia.freq <- data.frame("Issuing_Authority" = as.character(),
                         "No_Tickets" = as.numeric()
                         )
for (i in ia){
  d <- nrow(tics[which(as.character(tics$agencynameissuingagency) == i),])
  ad <- data.frame("Issuing_Authority" = i,
                   "No_Tickets" = d
                   )
  df.ia.freq <- rbind(df.ia.freq, ad)
}

df.ia.freq


##### DIFFERENT TYPES OF TICETS #####
tty <- unique(as.character(tics$violationdesc)) %>% 
  .[which(. != "")]

df.tty.freq <- data.frame("Ticket_Type" = as.character(),
                         "No_Tickets" = as.numeric()
)
for (i in tty){
  d <- nrow(tics[which(as.character(tics$violationdesc) == i),])
  ad <- data.frame("Ticket_Type" = i,
                   "No_Tickets" = d
  )
  df.tty.freq <- rbind(df.tty.freq, ad)
}

df.tty.freq[order(df.tty.freq$No_Tickets, decreasing = TRUE),]


##### LOOKING AT STATE DESCRIMINATION #####
plt <- unique(as.character(tics$rpplate)) %>% 
  .[which(. != "")]

df.plt.freq <- data.frame("Origin_State" = as.character(),
                          "No_Tickets" = as.numeric()
)
for (i in plt){
  d <- nrow(tics[which(as.character(tics$rpplate) == i),])
  ad <- data.frame("Origin_State" = i,
                   "No_Tickets" = d
  )
  df.plt.freq <- rbind(df.plt.freq, ad)
}

df.plt.freq[order(df.plt.freq$No_Tickets, decreasing = TRUE),]

##### CAR TYPES #####

car <- unique(as.character(tics$make)) %>% 
  .[which(. != "")]

df.car.freq <- data.frame("Car_Make" = as.character(),
                          "No_Tickets" = as.numeric()
)
for (i in car){
  d <- nrow(tics[which(as.character(tics$make) == i),])
  ad <- data.frame("Car_Make" = i,
                   "No_Tickets" = d
  )
  df.car.freq <- rbind(df.car.freq, ad)
}

df.car.freq[order(df.car.freq$No_Tickets, decreasing = TRUE),]


###### CAR TYPES AND AMOUNT #####

car <- unique(as.character(tics$make)) %>% 
  .[which(. != "")]

df.car.amt <- data.frame("Car_Make" = as.character(),
                         "No_Tickets" = as.numeric(),
                         "Total_AMT" = as.numeric(),
                         "Av_Per_Tkt" = as.numeric()
                         )
for (i in car){
  d <- nrow(tics[which(as.character(tics$make) == i),])
  am <- sum(na.omit(tics$amountdue[which(as.character(tics$make) == i)]))
  ad <- data.frame("Car_Make" = i,
                   "No_Tickets" = d,
                   "Total_AMT" = am,
                   "Av_Per_Tkt" = round(am/d, digits = 2)
  )
  df.car.amt <- rbind(df.car.amt, ad)
}

df.car.amt[order(df.car.amt$Av_Per_Tkt, decreasing = TRUE),]







#Finding my MF ticket...
#tics[which(as.character(tics$streetname) == "BALLARD"),]




