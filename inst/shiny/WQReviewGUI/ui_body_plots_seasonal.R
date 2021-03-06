###This contains all the ui elements for the seasonal plot tab.
###It is sourced from the ui-body tab, which is eventually sourced from the ui tab.
###These are contained in individual scripts just for organization sake.


tabItem(tabName = "seasonalPlot",
        fluidPage(
                pageWithSidebar(
                        headerPanel("Seasonal plot"),
                        sidebarPanel(
                                ###Controls items for plot
                                #dateInput("newThreshold_seasonal", "New samples threshold",max=Sys.Date(),value=Sys.Date()-30),
                                selectInput("siteSel_seasonal","Station",choices="",multiple=TRUE),
                                selectInput("parmSel_seasonal","Parameter",choices="",multiple=FALSE),
                                selectInput("facetSel_seasonal","Multi-site options",choices=c("Multisite","Facet"),multiple=FALSE),
                                checkboxInput("labelDQI_seasonal","Label DQI codes"),
                                checkboxInput("fit_seasonal",label="Add LOESS",value=FALSE),
                                verbatimTextOutput("seasonal_hoverinfo"),
                                
                                #h3("Review comments"),
                                #textInput("seasonal_flaggedRecord",label="Record #"),
                                #radioButtons("seasonal_flaggedStatus",choices=c("No selection","Looks good","Not OK"),label="Status"),
                                #selectInput("seasonal_dqiCode",choices = c(NA,"R","Q","I","S","O","X","U","A","P"),label="DQI Code",multiple=FALSE),
                                #textInput("seasonal_flaggedComment",label = "Comment"),
                                #actionButton(inputId = "seasonal_addRecord",label="Add record"),
                                
                                ###Sidebar options
                                width=3
                        ),
                        mainPanel(
                ###This displays the primary plot interaction output
                box(
                        plotOutput("qwseasonalPlot", click="plot_click_seasonal",brush="plot_brush_seasonal",hover="plot_hover"),
                        #verbatimTextOutput("brushx"),
                        
                        ###Box options
                        width=12,
                        collapsible=TRUE),
                
                ###This displays the zoomed plot interaction output
                
                box(
                        plotOutput("qwseasonalPlot_zoom", click="plot_click_seasonal",hover="plot_hover"),
                        ###Box options
                        width=12,
                        collapsible=TRUE),
                
                ###This displays the plot interaction output
                
                box(
                        actionButton(inputId = "seasonal_popNotes",label="Add to notes"),
                        DT::dataTableOutput("seasonal_clickinfo"),
                        DT::dataTableOutput("seasonal_brushinfo"),
                        ###Box options
                        width=12,
                        collapsible=TRUE)
                        )
        )
)
)