
######################################################
###This generates content for the alerts dropdown menu
######################################################


tryCatch({
newSampleCount <- length(plotTable$RECORD_NO[plotTable$SAMPLE_CR > Sys.time() - 60*60*24*7
                                                     &!duplicated(plotTable$RECORD_NO)])
newResultCount <- length(plotTable$RECORD_NO[plotTable$RESULT_CR > Sys.time() - 60*60*24*7])
modifiedCount <- length(plotTable$RECORD_NO[plotTable$RESULT_MD > Sys.time() - 60*60*24*7])
totalSampleCount <- length(plotTable$RECORD_NO[plotTable$SAMPLE_START_DT > Sys.time() - 60*60*24*365*3
                                                       &!duplicated(plotTable$RECORD_NO)])
totalResultCount <- length(plotTable$RESULT_VA[plotTable$SAMPLE_START_DT > Sys.time() - 60*60*24*365*3])
},warning = function(w) {newSampleCount <- length(plotTable$RECORD_NO[plotTable$SAMPLE_CR > Sys.time() - 60*60*24*7
                                                                              &!duplicated(plotTable$RECORD_NO)])
                         newResultCount <- length(plotTable$RECORD_NO[plotTable$RESULT_CR > Sys.time() - 60*60*24*7])
                         modifiedCount <- length(plotTable$RECORD_NO[plotTable$RESULT_MD > Sys.time() - 60*60*24*7])

},error = function(e) {
        newSampleCount <- ""
        newResultCount <- ""
        modifiedCount <- ""
})

alertData <- data.frame(
        text = c(paste(newSampleCount,"New samples in past 7 days"),
                 paste(newResultCount,"New results in past 7 days"),
                 paste(modifiedCount,"Modified results in past 7 days"),
                 paste(nrow(reports$chemFlagTable),"Chemical check flags"),
                 paste(nrow(reports$pestFlagTable),"Pesticide flags"),
                 paste(nrow(reports$resultFlagTable),"High/low value flags")
                 ),
        icon = c("info",
                 "info",
                 "info",
                 "exclamation-triangle",
                 "exclamation-triangle",
                 "exclamation-triangle"),
        status = c("info",
                   "info",
                   "info",
                   "warning",
                   "warning",
                   "warning"),
        stringsAsFactors = FALSE
)


output$alerts <- renderMenu({

                alerts <- apply(alertData, 1, function(row) {
                        notificationItem(
                                text = row[["text"]],
                                icon = icon(row[["icon"]]),
                                status=row[["status"]]
                        )
                })
                
                dropdownMenu(type = "notifications", .list = alerts)
        })

######################################################
###This generates content for the progress dropdown menu
######################################################

tryCatch({
reviewedCount <- length(plotTable$RESULT_VA[plotTable$SAMPLE_START_DT > Sys.time() - 60*60*24*365*3
                        & (plotTable$DQI_CD %in% c("R","Q","O","X","U","A"))])/totalResultCount*100

waitingCount <- length(plotTable$RESULT_VA[plotTable$SAMPLE_START_DT > Sys.time() - 60*60*24*365*3
                                                    & plotTable$DQI_CD %in% c("I","S","P")])/totalResultCount*100
}, warning = function(w) {
        reviewedCount <- length(plotTable$RESULT_VA[plotTable$SAMPLE_START_DT > Sys.time() - 60*60*24*365*3
                                                            & (plotTable$DQI_CD %in% c("R","Q","O","X","U","A"))])/totalResultCount*100
        
        waitingCount <- length(plotTable$RESULT_VA[plotTable$SAMPLE_START_DT > Sys.time() - 60*60*24*365*3
                                                           & plotTable$DQI_CD %in% c("I","S","P")])/totalResultCount*100
}, error = function(e) {
        reviewedCount <- ""
        waitingCount <- ""
})
taskData <- data.frame(
        text = c("Reviewed results (last 3years)", "Waiting for review (last 3years)"),
        value = c(
                round(reviewedCount,0),
                round(waitingCount,0)
                ),
        color= c("green","red"),
        stringsAsFactors = FALSE
)


output$progress <- renderMenu({

        tasks <- apply(taskData, 1, function(row) {
                taskItem(
                        text = row[["text"]],
                        value = row[["value"]],
                        color = row[["color"]]
                )
        })
        
        dropdownMenu(type = "tasks", .list = tasks)
})


######################################################
###This generates content for the messages dropdown menu
######################################################
overdueCount <- ""
wayOverdueCount <- ""

tryCatch({
overdueCount <- length(plotTable$RESULT_VA[plotTable$SAMPLE_START_DT > Sys.time() - 60*60*24*30*3
                                                    & plotTable$DQI_CD %in% c("I","S")])

wayOverdueCount <- length(plotTable$RESULT_VA[plotTable$SAMPLE_START_DT < Sys.time() - 60*60*24*30*3
                                                   & plotTable$DQI_CD %in% c("I","S")])
},warning = function(w) {
        overdueCount <- length(plotTable$RESULT_VA[plotTable$SAMPLE_START_DT > Sys.time() - 60*60*24*30*3
                                                           & plotTable$DQI_CD %in% c("I","S")])
        
        wayOverdueCount <- length(plotTable$RESULT_VA[plotTable$SAMPLE_START_DT < Sys.time() - 60*60*24*30*3
                                                              & plotTable$DQI_CD %in% c("I","S")])
}, error = function(e) {
        
        overdueCount <- 0
        wayOverdueCount <- 0
})

output$messages <- renderMenu({
        dropdownMenu(type = "messages",

        messageItem(
                from="DQI Police",
                message = paste(overdueCount,"results in DQI of I, S, or P < 90 days."),
                icon = icon("exclamation-triangle")
                ),
        

        
                messageItem(
                        from="DQI Police",
                        message = paste(wayOverdueCount,"results in DQI of I, S, or P > 90 days!"),
                        icon = icon("exclamation-triangle")
                        )
        
      
        )
        
})