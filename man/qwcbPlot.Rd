% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qwcbPlot.R
\name{qwcbPlot}
\alias{qwcbPlot}
\title{Chargebalance timeseries plot}
\usage{
qwcbPlot(qw.data, site.selection, facet = "multisite", scales = "fixed",
  new.threshold = 60 * 60 * 24 * 30, show.smooth = FALSE,
  highlightrecords = NULL, wySymbol = FALSE, labelDQI = FALSE,
  printPlot = TRUE)
}
\arguments{
\item{qw.data}{A qw.data list generated from readNWISodbc}

\item{site.selection}{A character vector of site IDs to plot}

\item{facet}{Character string of either "multisite" for plotting all sites on one plot or "Facet" for plotting sites on individual plots}

\item{scales}{Character string to define y axis on faceted plots. Options are "free","fixed","free_x", or "free_y"}

\item{new.threshold}{The threshold value in seconds from current system time for "new" data.}

\item{show.smooth}{Add a loess smooth to plot}

\item{highlightrecords}{A character vector of record numbers to highlight in plot}

\item{wySymbol}{Make current water-year highlighted.}

\item{labelDQI}{Logical. Should points be labeled with DQI code.}

\item{printPlot}{Logical. Prints plot to graphics device if TRUE}
}
\description{
Takes output list from readNWISodbc and prints a plot of charge balance vs time. Requires charge balance = TRUE in NWISPullR
}
\examples{
data("exampleData",package="WQReview")
qwcbPlot(qw.data = qw.data,
                       site.selection = "06733000",
                       facet = "multisite",
                       scales="fixed",
                       new.threshold = 60*60*24*30,
                       highlightrecords = NULL,
                       wySymbol = FALSE,
                       labelDQI = FALSE,
                       printPlot = TRUE)
}

