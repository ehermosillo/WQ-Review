###This contains all the ui elements for the chargebalance plot tab.
###It is sourced from the ui-body tab, which is eventually sourced from the ui tab.
###These are contained in individual scripts just for organization sake.


tabItem(tabName = "cbPlot",
        fluidPage(
               pageWithSidebar(
                       headerPanel("Chargebalance Timeseries"),
                       sidebarPanel(
                               ###Controls items for plot
                               #dateInput("newThreshold_cb", "New samples threshold",max=Sys.Date(),value=Sys.Date()-30),
                               selectInput("siteSel_cb","Station",choices="",multiple=TRUE),
                               selectInput("facetSel_cb","Multi-site options",choices=c("Multisite","Facet"),multiple=FALSE),
                               checkboxInput("labelDQI_cb","Label DQI codes"),
                               verbatimTextOutput("cb_hoverinfo"),
                               ###Sidebar options
                               width=3
                               
                       ),
                       mainPanel(
                               
                ###This displays the primary plot interaction output
                box(
                        plotOutput("qwcbPlot", click="plot_click_cb",brush="plot_brush_cb", hover="plot_hover"),
                        #verbatimTextOutput("brushx"),
                        
                        ###Box options
                        width=12,
                        collapsible=TRUE),
                
                ###This displays the zoomed plot interaction output
                
                box(
                        plotOutput("qwcbPlot_zoom", click="plot_click_cb", hover="plot_hover"),
                        ###Box options
                        width=12,
                        collapsible=TRUE),
                
                ###This displays the plot interaction output
                
                box(
                        DT::dataTableOutput("cb_clickinfo"),
                        DT::dataTableOutput("cb_brushinfo"),
                        ###Box options
                        width=12,
                        collapsible=TRUE)
                       )
        )
)
)