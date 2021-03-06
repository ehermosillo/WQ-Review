###This contains all the ui elements for the blank plot tab.
###It is sourced from the ui-body tab, which is eventually sourced from the ui tab.
###These are contained in individual scripts just for organization sake.


tabItem(tabName = "blankPlot",
        fluidPage(
                pageWithSidebar(
                        headerPanel("Blank sample timeseries"),
                        sidebarPanel(
                                ###Controls items for plot
                                #dateInput("newThreshold_blank", "New samples threshold",max=Sys.Date(),value=Sys.Date()-30),
                                selectInput("siteSel_blank","Station",choices="",multiple=TRUE),
                                selectInput("parmSel_blank","Parameter",choices="",multiple=FALSE),
                                selectInput("facetSel_blank","Multi-site options",choices=c("Multisite","Facet"),multiple=FALSE),
                                verbatimTextOutput("blank_hoverinfo"),
                               
                                 ###Sidebar options
                                width=3
                                
                        ),
                        mainPanel(
                                ###This displays the primary plot interaction output
                                box(
                                        plotOutput("qwblankPlot", click="plot_click_blank",brush="plot_brush_blank", hover="plot_hover"),
                                        #verbatimTextOutput("brushx"),
                                        
                                        ###Box options
                                        width=12,
                                        collapsible=TRUE),
                                
                                ###This displays the zoomed plot interaction output
                                
                                box(
                                        plotOutput("qwblankPlot_zoom", click="plot_click_blank", hover="plot_hover"),
                                        ###Box options
                                        width=12,
                                        collapsible=TRUE),
                                
                                ###This displays the plot interaction output
                                
                                box(
                                        actionButton(inputId = "blank_popNotes",label="Add to notes"),
                                        DT::dataTableOutput("blank_clickinfo"),
                                        DT::dataTableOutput("blank_brushinfo"),
                                        ###Box options
                                        width=12,
                                        collapsible=TRUE)
                        )
                )
        )
)