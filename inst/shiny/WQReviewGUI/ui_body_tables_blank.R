tabItem(tabName = "blankTable",
        fluidPage(
                pageWithSidebar(
                        headerPanel("Blank summary table"),
                        sidebarPanel(
                                selectInput("siteSel_blankTable","Station",choices="",multiple=TRUE),
                                dateInput("startDate_blankTable", "Start date for blank summary", 
                                               value=Sys.Date() - 365*3),
                                dateInput("endDate_blankTable", "End date for blank summary", 
                                          value=Sys.Date()),
                                ###sidebar options
                                width=3
                        ),
                        mainPanel(
                                downloadButton('blankTableOut', 'Download tab delimited table'),
                                h3(textOutput("blankTableWarning")),
                                DT::dataTableOutput("blankTable")
                        )
                )
        )
)

