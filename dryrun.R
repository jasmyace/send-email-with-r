library(gmailr)

## edit line below to reflect YOUR json credential filename
#use_secret_file("gmailr-tutorial.json")

## edit below with email addresses from your life
test_email <- mime(
  To = "jmitchell@west-inc.com",
  From = "jmitchell@west-inc.com",
  Subject = "this is just a gmailr test",
  body = "Can you hear me now?")

send_message(test_email)

## verify that the email arrives succesfully!
