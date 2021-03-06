############################
###chemFlagTable
############################


###Render the table
output$chemFlagTable <- DT::renderDataTable(
        reports$chemFlagTable,
        ##extensions = list(FixedColumns = list(leftColumns = 1)),
        server=TRUE,
        rownames= FALSE,
        options = list(
                scrollX=TRUE,
                autoWidth=TRUE,
                pageLength = 25)
)

output$chemFlagTableOut <- downloadHandler(
        filename = function() {"chemFlagTableOut"},
        content = function(file) {
                write.table(reports$chemFlagTable,sep="\t", col.names = T, row.names = F,na="", quote = FALSE,
                            file)
        }
)

############################
###sampleFlagTable
############################


###Render the table
output$pestFlagTable <- DT::renderDataTable(
        reports$pestFlagTable,
        #extensions = list(FixedColumns = list(leftColumns = 1)),
        server=TRUE,
        rownames= FALSE,
        options = list(
                scrollX=TRUE,
                autoWidth=TRUE,
                pageLength = 25)
)

output$pestFlagTableOut <- downloadHandler(
        filename = function() {"pestFlagTableOut"},
        content = function(file) {
                write.table(reports$pestFlagTable,sep="\t", col.names = T, row.names = F,na="", quote = FALSE,
                            file)
        }
)

############################
###resultFlagTable
############################

###Render the table

output$resultFlagTable <- DT::renderDataTable(
        reports$resultFlagTable,
        #extensions = list(FixedColumns = list(leftColumns = 1)),
        server=TRUE,
        #selection = 'single',
        #rownames= FALSE,
        options = list(
                scrollX=TRUE,
                autoWidth=TRUE,
                pageLength = 25)
)


###Download table
output$resultFlagTableOut <- downloadHandler(
        filename = function() {"resultFlagTableOut"},
        content = function(file) {
                write.table(reports$resultFlagTable,sep="\t", col.names = T, row.names = F,na="", quote = FALSE,
                            file)
        }
)

###Add to notes
observeEvent(input$resultFlagTable_popNotes, {
        print(input$resultFlagTable_rows_selected)
        updateTextInput(session, 
                        "sidebar_flaggedRecord",
                        value = reports$resultFlagTable$RECORD_NO[as.numeric(input$resultFlagTable_rows_selected)]
        )
        updateTextInput(session, 
                        "parmSel_sidebar",
                        value = reports$resultFlagTable$PARM_CD[as.numeric(input$resultFlagTable_rows_selected)]
        )
        updateSelectInput(session,
                          "sidebar_dqiCode",
                          selected=NA)
        updateRadioButtons(session,
                           "sidebar_flaggedStatus",
                           selected="No selection")
        updateTextInput(session, 
                        "sidebar_flaggedComment",
                        value = " "
        )
})
############################
###Wide Data table
############################


###Render the table
try({
        output$wideDataTable <- DT::renderDataTable(
                if(!is.null(input$siteSel_wideDataTable))
                {
                        if(as.character(input$siteSel_wideDataTable == "All"))
                        {
                                subset(dataTable,as.Date(SAMPLE_START_DT) >= input$startDate_wideDataTable &
                                               as.Date(SAMPLE_START_DT) <= input$endDate_wideDataTable)
                        } else 
                        {
                                subset(dataTable, SITE_NO %in% as.character(input$siteSel_wideDataTable) &
                                               as.Date(SAMPLE_START_DT) >= input$startDate_wideDataTable &
                                               as.Date(SAMPLE_START_DT) <= input$endDate_wideDataTable)
                        }
                },
                #extensions = list(FixedColumns = list(leftColumns = 1)),
                server=TRUE,
                rownames= FALSE,
                options = list(
                        scrollX=TRUE,
                        autoWidth=TRUE,
                        pageLength = 25)
        )
})

output$wideDataTableOut <- downloadHandler(
        filename = function() {"wideDataTableOut"},
        content = function(file) {
                write.table(dataTable,sep="\t", col.names = T, row.names = F,na="", quote = FALSE,
                            file)
        }
)


############################
###Long Data table
############################


longDataTableReactive <<- reactive({
        if(!is.null(input$siteSel_longDataTable))
        {
                if(as.character(input$siteSel_longDataTable == "All"))
                {
                        subset(plotTable, 
                               as.Date(SAMPLE_START_DT) >= input$startDate_longDataTable &
                                       as.Date(SAMPLE_START_DT) <= input$endDate_longDataTable)
                } else {
                        subset(plotTable, SITE_NO %in% as.character(input$siteSel_longDataTable) &
                                       as.Date(SAMPLE_START_DT) >= input$startDate_longDataTable &
                                       as.Date(SAMPLE_START_DT) <= input$endDate_longDataTable)
                }
        }
})

###Render the table
output$longDataTable <- DT::renderDataTable(
        longDataTableReactive(),
        #extensions = list(FixedColumns = list(leftColumns = 1)),
        server=TRUE,
        #selection = 'single',
        rownames= TRUE,
        options = list(
                scrollX=TRUE,
                autoWidth=TRUE,
                pageLength = 25)
)

##Download the table
output$longDataTableOut <- downloadHandler(
        filename = function() {"longDataTableOut"},
        content = function(file) {
                write.table(plotTable,sep="\t", col.names = T, row.names = F,na="", quote = FALSE,
                            file)
        }
)

###Add to notes
observeEvent(input$longDataTable_popNotes, {
        updateTextInput(session, 
                        "sidebar_flaggedRecord",
                        value = longDataTableReactive()$RECORD_NO[as.numeric(input$longDataTable_rows_selected)]
        )
        updateTextInput(session, 
                        "parmSel_sidebar",
                        value = longDataTableReactive()$PARM_CD[as.numeric(input$longDataTable_rows_selected)]
        )
        updateSelectInput(session,
                          "sidebar_dqiCode",
                          selected=NA)
        updateRadioButtons(session,
                           "sidebar_flaggedStatus",
                           selected="No selection")
        updateTextInput(session, 
                        "sidebar_flaggedComment",
                        value = " "
        )
})

############################
###CB table
############################


###Render the table
output$balanceTable <- DT::renderDataTable(
        if(!is.null(input$siteSel_balanceTable))
        {
                if(as.character(input$siteSel_balanceTable == "All"))
                {
                        subset(reports$BalanceDataTable, as.Date(SAMPLE_START_DT) >= input$startDate_balanceTable &
                                       as.Date(SAMPLE_START_DT) <= input$endDate_balanceTable)
                } else {
                        subset(reports$BalanceDataTable, SITE_NO %in% as.character(input$siteSel_balanceTable) &
                                       as.Date(SAMPLE_START_DT) >= input$startDate_balanceTable &
                                       as.Date(SAMPLE_START_DT) <= input$endDate_balanceTable)
                }
        },
        #extensions = list(FixedColumns = list(leftColumns = 1)),
        server=TRUE,
        rownames= TRUE,
        options = list(
                scrollX=TRUE,
                autoWidth=TRUE,
                pageLength = 25)
)

output$BalanceDataTableOut <- downloadHandler(
        filename = function() {"BalanceDataTableOut"},
        content = function(file) {
                write.table(reports$BalanceDataTable,sep="\t", col.names = T, row.names = F,na="", quote = FALSE,
                            file)
        }
)
############################
###Rep table
############################

###Render the table
output$repTable <- DT::renderDataTable(
        if(!is.null(input$siteSel_repTable))
        {
                if(as.character(input$siteSel_repTable == "All"))
                {
                        subset(reports$repTable, as.Date(Env_SAMPLE_START_DT) >= input$startDate_repTable &
                                       as.Date(Env_SAMPLE_START_DT) <= input$endDate_repTable)
                }else {
                        subset(reports$repTable, SITE_NO %in% as.character(input$siteSel_repTable) &
                                       as.Date(Env_SAMPLE_START_DT) >= input$startDate_repTable &
                                       as.Date(Env_SAMPLE_START_DT) <= input$endDate_repTable)
                }
        },
        server=TRUE,
        rownames= TRUE,
        #extensions = list(FixedColumns = list(leftColumns = 1)),
        options = list(
                scrollX=TRUE,
                autoWidth=TRUE,
                pageLength = 25)
)

output$repTableOut <- downloadHandler(
        filename = function() {"repTableOut"},
        content = function(file) {
                write.table(reports$repTable,sep="\t", col.names = T, row.names = F,na="", quote = FALSE,
                            file)
        }
)

############################
###wholevpart table
############################


###Render the table
output$wholevpartTable <- DT::renderDataTable(
        if(!is.null(input$siteSel_wholevpartTable))
        {
                if(as.character(input$siteSel_wholevpartTable == "All"))
                {
                        subset(reports$wholevpartTable, as.Date(SAMPLE_START_DT) >= input$startDate_wholevpartTable &
                                       as.Date(SAMPLE_START_DT) <= input$endDate_wholevpartTable)
                } else {
                        subset(reports$wholevpartTable, SITE_NO %in% as.character(input$siteSel_wholevpartTable) &
                                       as.Date(SAMPLE_START_DT) >= input$startDate_wholevpartTable &
                                       as.Date(SAMPLE_START_DT) <= input$endDate_wholevpartTable)
                }
        },
        #extensions = list(FixedColumns = list(leftColumns = 1)),
        server=TRUE,
        rownames= TRUE,
        #container = wholevpartTableContainer,
        options = list(
                scrollX=TRUE,
                autoWidth=TRUE,
                pageLength = 25)
)

output$wholevpartTableOut <- downloadHandler(
        filename = function() {"wholevpartTableOut"},
        content = function(file) {
                write.table(reports$wholevpartTable,sep="\t", col.names = T, row.names = F,na="", quote = FALSE,
                            file)
        }
)


############################
###Blank table
############################

###Render the table
try({
        
        output$blankTable <- DT::renderDataTable(
                if(!is.null(input$siteSel_blankTable))
                {
                        suppressWarnings(blankSummary(qw.data,
                                                      STAIDS = as.character(input$siteSel_blankTable),
                                                      begin.date = input$startDate_blankTable, 
                                                      end.date = input$endDate_blankTable,
                                                      multiple = FALSE))
                },
                server=TRUE,
                rownames= TRUE,
                #extensions = list(FixedColumns = list(leftColumns = 1)),
                options = list(
                        scrollX=TRUE,
                        autoWidth=TRUE,
                        pageLength = 25)
        )
        output$blankTableOut <- downloadHandler(
                filename = function() {"blankTableOut"},
                content = function(file) {
                        write.table(blankSummary(qw.data,
                                                 STAIDS = as.character(input$siteSel_blankTable),
                                                 begin.date = input$startDate_blankTable, 
                                                 end.date = input$endDate_blankTable,
                                                 multiple = FALSE)
                                    ,sep="\t", col.names = T, row.names = F,na="", quote = FALSE,
                                    file)
                }
        )
        
})

############################
###Marked records table
############################

###Render the table
observeEvent(input$refreshMarkedRecords, {
        output$markedRecords <- DT::renderDataTable(
                markedRecords,
                server=TRUE,
                rownames= TRUE,
                #extensions = list(FixedColumns = list(leftColumns = 1)),
                options = list(
                        scrollX=TRUE,
                        autoWidth=TRUE,
                        pageLength = 25)
        )
})

observeEvent(input$deleteMarkedRecords, {
        markedRecords <<- markedRecords[!(row.names(markedRecords)%in%input$markedRecords_rows_selected),]
        output$markedRecords <- DT::renderDataTable(
                markedRecords,
                server=TRUE,
                rownames= TRUE,
                #extensions = list(FixedColumns = list(leftColumns = 1)),
                options = list(
                        scrollX=TRUE,
                        autoWidth=TRUE,
                        pageLength = 25)
        )
})

output$markedRecordsOut <- downloadHandler(
        filename = function() {"markedRecordsOut"},
        content = function(file) {
                write.table(markedRecords,sep="\t", col.names = T, row.names = F,na="", quote = FALSE,
                            file)
        }
)

observeEvent(input$flipDQI, {
        
        dqiTables <<- flipDQI(STAIDS = unique(as.character(markedRecords$SITE_NO)),
                              records = as.character(markedRecords$RECORD_NO),
                              parameters = as.character(markedRecords$PARM_CD),
                              dqiCodes = as.character(markedRecords$DQI_CD_New),
                              DSN = DSN,
                              env.db = env.db,
                              qa.db= qa.db)
        
        output$qwSample <- DT::renderDataTable(
                dqiTables$qwsample,
                server=TRUE,
                rownames= FALSE,
                #extensions = list(FixedColumns = list(leftColumns = 1)),
                options = list(
                        scrollX=TRUE,
                        autoWidth=TRUE,
                        pageLength = 25)
        )
        output$qwResult <- DT::renderDataTable(
                dqiTables$qwresult,
                server=TRUE,
                rownames= FALSE,
                #extensions = list(FixedColumns = list(leftColumns = 1)),
                options = list(
                        scrollX=TRUE,
                        autoWidth=TRUE,
                        pageLength = 25)
        )
})

output$qwResultOut <- downloadHandler(
        filename = function() {"qwResultOut"},
        content = function(file) {
                write.table(dqiTables$qwresult,
                            sep="\t", col.names = F, row.names = F,na="", quote = FALSE,
                            file = file)
        }
)

output$qwSampleOut <- downloadHandler(
        filename = function() {"qwSampleOut"},
        content = function(file) {
                write.table(dqiTables$qwsample,
                            sep="\t", col.names = F, row.names = F,na="", quote = FALSE,
                            file = file)
        }
)
###############################
###Needs review sidebar table
###############################
###Can't get this to look nice in sidebar yet, tabled for now

# output$needsReviewTable <- DT::renderDataTable(
#        formatStyle(
#                DT::datatable(
#                        plotTable[plotTable$DQI_CD %in% c("I","S","P"),c("SITE_NO","PARM_CD","DQI_CD","RECORD_NO")],
#                        ##extensions = list(FixedColumns = list(leftColumns = 1)),
#                        rownames= FALSE,
#                        options = list(
#                                searching=FALSE,
#                                scrollX=TRUE,
#                                autoWidth=TRUE)
#                ), columns = 1:4, color="black"),
#        server=TRUE
# )

###############################
###DQI Flip table
###############################
dqiTable <<- plotTable[plotTable$DQI_CD %in% c("I","S","P"),
                               c("RECORD_NO","SITE_NO","STATION_NM","SAMPLE_START_DT","MEDIUM_CD","PARM_CD","PARM_NM","DQI_CD")]
dqiTable <<- transmute(dqiTable,
                       #RECORD_NO = RECORD_NO,
                       SITE_NO = as.factor(SITE_NO),
                       #STATION_NM = STATION_NM,
                       SAMPLE_START_DT = SAMPLE_START_DT,
                       #MEDIUM_CD = as.factor(MEDIUM_CD),
                       PARM_CD = as.factor(PARM_CD),
                       PARM_NM = as.factor(PARM_NM),
                       DQI_CD = as.factor(DQI_CD))

# dqiTableReactive <<- reactive({
#         if(!is.null(input$siteSel_dqiTable))
#         {
#                 if(as.character(input$siteSel_dqiTable == "All"))
#                 {
#                         subset(dqiTable, 
#                                as.Date(SAMPLE_START_DT) >= input$startDate_dqiTable &
#                                        as.Date(SAMPLE_START_DT) <= input$endDate_dqiTable)
#                 } else {
#                         subset(dqiTable, SITE_NO %in% as.character(input$siteSel_dqiTable) &
#                                        as.Date(SAMPLE_START_DT) >= input$startDate_dqiTable &
#                                        as.Date(SAMPLE_START_DT) <= input$endDate_dqiTable)
#                 }
#         }
# })

output$dqiTable <- DT::renderDataTable(
        dqiTable,
        rownames= TRUE,
        filter="top",
        server=TRUE
)

observeEvent(input$dqiTable_popNotes, {
        updateTextInput(session, 
                        "sidebar_flaggedRecord",
                        value = dqiTableReactive()$RECORD_NO[as.numeric(input$dqiTable_rows_selected)]
        )
        updateTextInput(session, 
                        "parmSel_sidebar",
                        value = dqiTableReactive()$PARM_CD[as.numeric(input$dqiTable_rows_selected)]
        )
        updateSelectInput(session,
                          "sidebar_dqiCode",
                          selected=NA)
        updateRadioButtons(session,
                           "sidebar_flaggedStatus",
                           selected="No selection")
        updateTextInput(session, 
                        "sidebar_flaggedComment",
                        value = " "
        )
        
        ###Remove entry from unnaproved data table
        dqiTable <<- dqiTable[!(row.names(dqiTable)%in%input$dqiTable_rows_selected),]
        
})

