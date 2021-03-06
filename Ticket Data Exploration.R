library(readr)
library(dplyr)
library(civis)
library(lubridate)
library(ggplot2)
#Good until Christmas +2 VV
#Sys.setenv(CIVIS_API_KEY = 'e55b1cc634361b4a71cdd072d0dec1bfb8df0522aba379d7d2a422f124abf8ba')

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

df.car.amt[which(df.car.amt$No_Tickets > 100),] %>% 
  .[order(.$Av_Per_Tkt, decreasing = TRUE),]


##### MOST PROFITABLE ROUTE #####


rt <- unique(as.character(tics$route)) %>% 
  .[which(. != "")]

df.rt.amt <- data.frame("Route" = as.character(),
                        "No_Tickets" = as.numeric(),
                        "Av_Per_Tkt" = as.numeric()
)
for (i in rt){
  d <- nrow(tics[which(as.character(tics$route) == i),])
  am <- sum(na.omit(tics$amountdue[which(as.character(tics$route) == i)]))
  ad <- data.frame("Route" = i,
                   "No_Tickets" = d,
                   "Av_Per_Tkt" = round(am/d, digits = 2)
  )
  df.rt.amt <- rbind(df.rt.amt, ad)
}

df.rt.amt[order(df.rt.amt$No_Tickets, decreasing = TRUE),]

##### TICKET VOLUME BY TIME OF DAY #####

na.omit(unique(as.numeric(as.character(tics$ticketissuetime))))
tics$ticketissuetime <- gsub(":", "", as.character(tics$ticketissuetime))
tics$ISSUE_HOUR <- as.numeric(as.character(tics$ticketissuetime))
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR < 100)] <- 0
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 100 & tics$ISSUE_HOUR < 200)] <- 1
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 200 & tics$ISSUE_HOUR < 300)] <- 2
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 300 & tics$ISSUE_HOUR < 400)] <- 3
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 400 & tics$ISSUE_HOUR < 500)] <- 4
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 500 & tics$ISSUE_HOUR < 600)] <- 5
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 600 & tics$ISSUE_HOUR < 700)] <- 6
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 700 & tics$ISSUE_HOUR < 800)] <- 7
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 800 & tics$ISSUE_HOUR < 900)] <- 8
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 900 & tics$ISSUE_HOUR < 1000)] <- 9
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 1000 & tics$ISSUE_HOUR < 1100)] <- 10
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 1100 & tics$ISSUE_HOUR < 1200)] <- 11
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 1200 & tics$ISSUE_HOUR < 1300)] <- 12
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 1300 & tics$ISSUE_HOUR < 1400)] <- 13
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 1400 & tics$ISSUE_HOUR < 1500)] <- 14
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 1500 & tics$ISSUE_HOUR < 1600)] <- 15
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 1600 & tics$ISSUE_HOUR < 1700)] <- 16
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 1700 & tics$ISSUE_HOUR < 1800)] <- 17
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 1800 & tics$ISSUE_HOUR < 1900)] <- 18
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 1900 & tics$ISSUE_HOUR < 2000)] <- 19
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 2000 & tics$ISSUE_HOUR < 2100)] <- 20
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 2100 & tics$ISSUE_HOUR < 2200)] <- 21
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 2200 & tics$ISSUE_HOUR < 2300)] <- 22
tics$ISSUE_HOUR[which(tics$ISSUE_HOUR >= 2300 & tics$ISSUE_HOUR < 2400)] <- 23


hr <- unique((tics$ISSUE_HOUR)) %>% 
  .[which(. != "")]

df.hr.amt <- data.frame("Hour" = as.character(),
                        "No_Tickets" = as.numeric(),
                        "Av_Per_Tkt" = as.numeric()
)
for (i in hr){
  d <- nrow(tics[which(as.character(tics$ISSUE_HOUR) == i),])
  am <- sum(na.omit(tics$amountdue[which(as.character(tics$ISSUE_HOUR) == i)]))
  ad <- data.frame("Hour" = i,
                   "No_Tickets" = d,
                   "Av_Per_Tkt" = round(am/d, digits = 2)
  )
  df.hr.amt <- rbind(df.hr.amt, ad)
}

df.hr.amt[order(df.hr.amt$Av_Per_Tkt, decreasing = TRUE),]
df.hr.amt[order(df.hr.amt$No_Tickets, decreasing = TRUE),]
hrdat <- df.hr.amt[order(df.hr.amt$Hour, decreasing = TRUE),]

hr.g <- ggplot(data = hrdat, aes(x = hrdat$Hour))
hr.g + 
  geom_line(mapping = aes(y = hrdat$No_Tickets))

hr.g +
  geom_line(mapping = aes(y = hrdat$Av_Per_Tkt))


##### TICKET VOLUME BY DAY OF WEEK #####


tics$DOW <- weekdays(as.Date(as.character(tics$ticketissuedate), format = "%m/%d/%Y"))


dow <- unique((tics$DOW)) %>% 
  .[which(is.na(.) == FALSE)]

df.dow.amt <- data.frame("Weekday" = as.character(),
                        "No_Tickets" = as.numeric(),
                        "Av_Tic_Per_Day" = as.numeric(),
                        "Av_Per_Tkt" = as.numeric()
)
for (i in dow){
  d <- nrow(tics[which(as.character(tics$DOW) == i),])
  am <- sum(na.omit(tics$amountdue[which(as.character(tics$DOW) == i)]))
  apd <- round(nrow(tics[which(as.character(tics$DOW) == i),])/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == i)])), digits = 1)
  ad <- data.frame("Hour" = i,
                   "No_Tickets" = d,
                   "Av_Tic_Per_Day" = apd,
                   "Av_Per_Tkt" = round(am/d, digits = 2)
  )
  df.dow.amt <- rbind(df.dow.amt, ad)
}

df.dow.amt[order(df.dow.amt$Av_Tic_Per_Day, decreasing = TRUE),]

##### TICKET VOLUME BY DAY OF WEEK BY TIME OF DAY #####


hr <- unique((tics$ISSUE_HOUR)) %>% 
  .[which(. != "")]

df.dow.avmat <- data.frame("Hour" = as.character(),
                           "Monday" = as.numeric(),
                           "Tuesday" = as.numeric(),
                           "Wednesday" = as.numeric(),
                           "Thursday" = as.numeric(),
                           "Friday" = as.numeric(),
                           "Saturday" = as.numeric(),
                           "Sunday" = as.numeric()
)

for (y in hr){
    mond <- round(nrow(tics[which(as.character(tics$DOW) == "Monday" & as.character(tics$ISSUE_HOUR) == y),])/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Monday")])), digits = 1)
    tued <- round(nrow(tics[which(as.character(tics$DOW) == "Tuesday" & as.character(tics$ISSUE_HOUR) == y),])/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Tuesday")])), digits = 1)
    wedd <- round(nrow(tics[which(as.character(tics$DOW) == "Wednesday" & as.character(tics$ISSUE_HOUR) == y),])/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Wednesday")])), digits = 1)
    thud <- round(nrow(tics[which(as.character(tics$DOW) == "Thursday" & as.character(tics$ISSUE_HOUR) == y),])/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Thursday")])), digits = 1)
    frid <- round(nrow(tics[which(as.character(tics$DOW) == "Friday" & as.character(tics$ISSUE_HOUR) == y),])/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Friday")])), digits = 1)
    satd <- round(nrow(tics[which(as.character(tics$DOW) == "Saturday" & as.character(tics$ISSUE_HOUR) == y),])/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Saturday")])), digits = 1)
    sund <- round(nrow(tics[which(as.character(tics$DOW) == "Sunday" & as.character(tics$ISSUE_HOUR) == y),])/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Sunday")])), digits = 1)
    
    ad <- data.frame("Hour" = y,
                     "Monday" = mond,
                     "Tuesday" = tued,
                     "Wednesday" = wedd,
                     "Thursday" = thud,
                     "Friday" = frid,
                     "Saturday" = satd,
                     "Sunday" = sund)
    
    df.dow.avmat <- rbind(df.dow.avmat, ad)
    
    print(paste("Finished with Hour", y, "of", length(hr)))
    }
  
                   
df.dow.avmat[order(df.dow.avmat$Hour, decreasing = FALSE),]  



##### AVERAGE TICKET AMOUNT BY DAY OF WEEK BY TIME OF DAY #####


hr <- unique((tics$ISSUE_HOUR)) %>% 
  .[which(. != "")]

df.dow.ptamt <- data.frame("Hour" = as.character(),
                           "Monday" = as.numeric(),
                           "Tuesday" = as.numeric(),
                           "Wednesday" = as.numeric(),
                           "Thursday" = as.numeric(),
                           "Friday" = as.numeric(),
                           "Saturday" = as.numeric(),
                           "Sunday" = as.numeric()
)

for (y in hr){
  mond <- round(sum(na.omit(tics$amountdue[which(as.character(tics$DOW) == "Monday" & as.character(tics$ISSUE_HOUR) == y)]))/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Monday")])), digits = 0)
  tued <- round(sum(na.omit(tics$amountdue[which(as.character(tics$DOW) == "Tuesday" & as.character(tics$ISSUE_HOUR) == y)]))/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Tuesday")])), digits = 0)
  wedd <- round(sum(na.omit(tics$amountdue[which(as.character(tics$DOW) == "Wednesday" & as.character(tics$ISSUE_HOUR) == y)]))/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Wednesday")])), digits = 0)
  thud <- round(sum(na.omit(tics$amountdue[which(as.character(tics$DOW) == "Thursday" & as.character(tics$ISSUE_HOUR) == y)]))/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Thursday")])), digits = 0)
  frid <- round(sum(na.omit(tics$amountdue[which(as.character(tics$DOW) == "Friday" & as.character(tics$ISSUE_HOUR) == y)]))/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Friday")])), digits = 0)
  satd <- round(sum(na.omit(tics$amountdue[which(as.character(tics$DOW) == "Saturday" & as.character(tics$ISSUE_HOUR) == y)]))/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Saturday")])), digits = 0)
  sund <- round(sum(na.omit(tics$amountdue[which(as.character(tics$DOW) == "Sunday" & as.character(tics$ISSUE_HOUR) == y)]))/length(unique(tics$ticketissuedate[which(as.character(tics$DOW) == "Sunday")])), digits = 0)
  
  ad <- data.frame("Hour" = y,
                   "Monday" = mond,
                   "Tuesday" = tued,
                   "Wednesday" = wedd,
                   "Thursday" = thud,
                   "Friday" = frid,
                   "Saturday" = satd,
                   "Sunday" = sund)
  
  df.dow.ptamt <- rbind(df.dow.ptamt, ad)
  
  print(paste("Finished with Hour", which(hr == y), "of", length(hr)))
}


df.dow.ptamt[order(df.dow.ptamt$Hour, decreasing = FALSE),]  




#tics[which(as.character(tics$streetname) == "BALLARD"),]
#tics[which(as.character(tics$issuingofficername) == "NEE-- SHARON"),]



