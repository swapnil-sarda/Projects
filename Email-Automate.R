library(gmailr)
library(tidyverse)
library(fs)
library(lubridate)
library(rmarkdown)
library(lubridate)


# Email Parameters ---
to <- "reciever email id"
subject <- "Automated report"
body <- str_glue("
  Hello Swapnil,
  This is an automated report containing visualisations."
)


# Save file location
file_path <- now() %>%
  str_replace_all("[[:punct]]","_")%>%
  str_replace(" ","T")%>%
  str_c("_Automated_Report.html")

#Rendering the Rmarkdown
render(
  input = "Automate.Rmd",
  output_format = "html_document",
  output_file = file_path,
  output_dir = "Home"
  )

#Gmail API automation

#Storing the client id and secret key
gm_auth_configure(path = "filename.json")

#Account through which email needs to be sent.
gm_auth(email = "sender email id")

#Email details
email <- gm_mime()%>%
  gm_to("reciever email id")%>%
  gm_from("sender email id")%>%
  gm_subject(" ")%>%
  gm_text_body(" ")%>%
  gm_attach_file(str_c("Home/",file_path)) #Location of  file to be attached


#Button to send report
shinyApp( 
  
  ui <- fluidPage(
    actionButton("Send","Send report"),
    mainPanel(
      includeHTML(str_c("Home/",file_path)
    )
  )),
  
  server <- function(input, output,session){
    
    observeEvent(input$Send, gm_send_message(email))
  }
  
)


