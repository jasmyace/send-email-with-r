suppressPackageStartupMessages(library(gmailr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(purrr))
library(readr)

#setwd("//lar-file-srv/Data/PSMFC_CampRST/send-email-with-r")

addrStem <- "//lar-file-srv/Data/PSMFC_CampRST/send-email-with-r"
my_dat <- read.csv(paste0(addrStem,"/addresses.csv"))

#   ---- Perhaps reduce the full list here, say, for testing.
my_dat <- my_dat[my_dat$firstName %in% c("Jason"),]

this_update  <- paste0("Environmental Convariate Database -- Update for ",Sys.Date())
email_sender <- 'Environmental Covariate Database DBA <jmitchell@west-inc.com>' # your Gmail address
body         <- "Hello, %s.

The update completed!  

Maybe more later...

Thanks,
The Environmental Covariate Database
"

edat <- my_dat %>%
  mutate(
    To = sprintf('%s <%s>', firstName, email),
    From = email_sender,
    Subject = this_update,
    body = sprintf(body, firstName)) %>%
  select(To, From, Subject, body)
edat
write_csv(edat, paste0("composed-emails",Sys.Date(),".csv"))

emails <- edat %>%
  pmap(mime)

## optional: use if you've created your own client id
# use_secret_file("gmailr-tutorial.json")
# 
safe_send_message <- safely(send_message)
sent_mail <- emails %>%
  map(safe_send_message)

saveRDS(sent_mail,paste(gsub("\\s+", "_", this_update), "sent-emails.rds", sep = "_"))
# 
# errors <- sent_mail %>%
#   transpose() %>%
#   .$error %>%
#   map_lgl(Negate(is.null))
# sent_mail[errors]
