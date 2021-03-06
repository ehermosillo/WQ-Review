#'Blank sample timeseries
#'
#' Takes output data object from readNWISodbc and prints a timeseries plot of blanks
#' @param qw.data A qw.data list generated from readNWISodbc
#' @param new.threshold The threshold value in seconds from current system time for "new" data.
#' @param plotparm A character vector of the parameter to plot.
#' @param site.selection A character vector of site IDs to plot
#' @param show.smooth Logical to add a loess smooth to plot
#' @param highlightrecords A character vector of record numbers to highlight in plot
#' @param facet Character string of either "multisite" for plotting all sites on one plot or "Facet" for plotting sites on individual plots
#' @param scales Character string to define y axis on faceted plots. Options are "free","fixed","free_x", or "free_y"
#' @param wySymbol Make current water-year highlighted.
#' @param labelDQI Logical. Should points be labeled with DQI code.
#' @param printPlot Logical. Prints plot to graphics device if TRUE
#' @examples 
#' data("exampleData",package="WQReview")
#' qwblankPlot(qw.data = qw.data,
#'                        site.selection = "06733000",
#'                        plotparm = "00915",
#'                        new.threshold = 60*60*24*30,
#'                        show.smooth = FALSE,
#'                        highlightrecords = " ",
#'                        facet = "multisite",
#'                        scales = "fixed",
#'                        wySymbol = FALSE,
#'                        labelDQI = FALSE,
#'                        printPlot = TRUE
#'                        )
#' @import ggplot2
#' @importFrom stringr str_wrap
#' @export

qwblankPlot <- function(qw.data,
                       site.selection,
                       plotparm,
                       new.threshold = 60*60*24*30,
                       show.smooth = FALSE,
                       highlightrecords = " ",
                       facet = "multisite",
                       scales = "fixed",
                       wySymbol = FALSE,
                       labelDQI = FALSE,
                       printPlot = TRUE){
        
        ## Sets color to medium code name, not factor level, so its consistant between all plots regardles of number of medium codes in data
        medium.colors <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#D55E00","#D55E00")
        names(medium.colors) <- c("WS ","WG ","WSQ","WGQ","OAQ","OA ")
        
        ## Sets shape to Remark code name, not factor level, so its consistant between all plots regardles of number of medium codes in data
        qual.shapes <- c(19,0,2,5,4,3,6,7,8,9,11)
        names(qual.shapes) <- c("Sample","<",">","E","A","M","N","R","S","U","V")
        
        plotdata <- subset(qw.data$PlotTable,SITE_NO %in% (site.selection) & 
                                   PARM_CD==(plotparm) &
                                   MEDIUM_CD %in% c("OAQ","OA"))
        
        
        if (length(site.selection) == 1)
        {
                maintitle <- str_wrap(unique(plotdata$STATION_NM[which(plotdata$SITE_NO == (site.selection))]), width = 25)
        } else if (length(site.selection) > 1)
        {
                maintitle <- "Multisite blank plot"
        } else (maintitle <- "No site selected")
        
        
        ylabel <- str_wrap(unique(plotdata$PARM_DS[which(plotdata$PARM_CD==(plotparm))]), width = 25)
        p1 <- ggplot(data=plotdata,aes(x=SAMPLE_START_DT,y=RESULT_VA,shape = REMARK_CD, color = MEDIUM_CD))
        p1 <- p1 + geom_point(size=3)
        p1 <- p1 + ylab(paste(ylabel,"\n")) + xlab("Date")
        p1 <- p1 + scale_colour_manual("Medium code",values = medium.colors)
        p1 <- p1 + scale_shape_manual("Remark code",values = qual.shapes)
        if (facet == "Facet")
        {
                p1 <- p1 + facet_wrap(~ STATION_NM, nrow = 1, scales=scales)
        }else {}
        #p1 <- p1 + scale_x_datetime(limits=c(as.POSIXct((begin.date)),as.POSIXct((end.date))))
        ##Highlighted records labels
        if(nrow(subset(plotdata, RECORD_NO %in% highlightrecords)) >0 )
        {
                p1 <- p1 + geom_point(data=subset(plotdata, RECORD_NO %in% highlightrecords),aes(x=SAMPLE_START_DT,y=RESULT_VA),size=7,alpha = 0.5, color ="#D55E00" ,shape=19)
        }
        
        
        
        ###New sample labels
        
        if(nrow(subset(plotdata, RESULT_MD >= (Sys.time()-new.threshold))) > 0)
        {
                if(all(is.finite(plotdata$perc.diff[which(plotdata$RESULT_MD >= (Sys.time()-new.threshold))])) &
                           
                           nrow(subset(plotdata, RESULT_MD >= (Sys.time()-new.threshold))) > 0)
                        
                        
                        
                {
                        p1 <- p1 + geom_text(data=subset(plotdata,RESULT_MD >= (Sys.time()-new.threshold)),
                                             aes(x=SAMPLE_START_DT,y=RESULT_VA,color = MEDIUM_CD,label="New",hjust=1.1),show_guide=F)      
                }else{}
        } else{}
        
        if(wySymbol == TRUE)
        {
                p1 <- p1 + geom_point(data=subset(plotdata, waterYear(SAMPLE_START_DT) == waterYear(Sys.time())),
                                      aes(x=SAMPLE_START_DT,y=RESULT_VA),size=5,alpha = 0.5, color = "#F0E442",shape=19)
        }
        
        
        p1 <- p1 + theme_bw() + theme(axis.text.x = element_text(angle = 90),
                                      panel.grid.minor = element_line()) + ggtitle(maintitle)
        
        if(labelDQI == TRUE)
        {
                p1 <- p1 + geom_text(aes(label=DQI_CD),size=5,vjust="bottom",hjust="right")
        }
        
        if((show.smooth)==TRUE){
                p2 <- p1 + geom_smooth(data=subset(plotdata, MEDIUM_CD %in% (c("OAQ ","OA "))))
                if(printPlot)
                {
                        print(p2)
                }else{}
                return(p2)
        } else{
                if(printPlot)
                {
                        print(p1)
                }else{}
                return(p1)
        }
}