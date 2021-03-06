###This contains all the ui elements for the timeseries plot tab.
###It is sourced from the ui-body tab, which is eventually sourced from the ui tab.
###These are contained in individual scripts just for organization sake.


tabItem(tabName = "timeSeries",
        fluidPage(
        pageWithSidebar(
                
               headerPanel("Timeseries"), 
                sidebarPanel(        
                        ###Controls items for plot
                        #dateInput("newThreshold", "New samples threshold",max=Sys.Date(),value=Sys.Date()-30),
                        selectInput("siteSel_TS","Station",choices="",multiple=TRUE),
                        selectInput("parmSel_TS","Parameter",choices="",multiple=FALSE),
                        selectInput("facetSel_TS","Multi-site options",choices=c("Multisite","Facet"),multiple=FALSE),
                        checkboxInput("labelDQI_timeseries","Label DQI codes"),
                        checkboxInput("fit_timeseries",label="Add LOESS",value=FALSE),
                        tags$div(title="Plot interactions won't work with hydrograph display",
                                 checkboxInput("showQ",label="Display hydrograph",value=FALSE)
                        ),
                        verbatimTextOutput("timeseries_hoverinfo"),
                        
                        #h3("Review comments"),
                        #textInput("timeseries_flaggedRecord",label="Record #"),
                        #radioButtons("timeseries_flaggedStatus",choices=c("No selection","Looks good","Not OK"),label="Status"),
                        #selectInput("timeseries_dqiCode",choices = c(NA,"R","Q","I","S","O","X","U","A","P"),label="DQI Code",multiple=FALSE),
                        #textInput("timeseries_flaggedComment",label = "Comment"),
                        #actionButton(inputId = "timeseries_addRecord",label="Add record"),
                        
                        
                        ###Sidebar options
                        width=3
                ),
               mainPanel(
                box(
                        plotOutput("qwtsPlot", click="plot_click_timeseries",brush="plot_brush_timeseries",hover="plot_hover"),
                        #verbatimTextOutput("tableOut"),
                        
                        ###Box options
                        width=12,
                        collapsible=TRUE
                        ),
                
                ###This displays the zoomed plot interaction output
                
                box(
                        plotOutput("qwtsPlot_zoom", click="plot_click_timeseries",hover="plot_hover"),
                        #dataTableOutput("hoverinfo"),
                        ###Box options
                        width=12,
                        collapsible=TRUE
                        ),
                
                ###This displays the plot interaction output
                
                box(
                        actionButton(inputId = "timeseries_popNotes",label="Add to notes"),
                        DT::dataTableOutput("timeseries_clickinfo"),
                        DT::dataTableOutput("timeseries_brushinfo"),
                        ###Box options
                        width=12,
                        collapsible=TRUE)
               )
        )
)
)