#' dygraph interactive plot for time series data
#' 
#' R interface to interactive time series plotting using the 
#' \href{http://dygraphs.com}{dygraphs} JavaScript library.
#' 
#' @param data Time series data (must be an \link[xts]{xts} object or an object 
#'   which is convertible to \code{xts}).
#' @param periodicity Periodicity of data (automatically detected via
#'   \link[xts:periodicity]{xts::periodicity} if not specified).
#' @param main Main plot title (optional)
#' @param xlab X axis label
#' @param ylab Y axis label
#' @param group Group to associate this plot with. The x-axis zoom level of 
#'   plots within a group is automatically synchronized.
#' @param width Width in pixels (optional, defaults to automatic sizing)
#' @param height Height in pixels (optional, defaults to automatic sizing)
#'   
#' @return Interactive dygraph plot
#'   
#' @note
#' See the \href{http://rstudio.github.io/dygraphs/}{online documentation} for
#' additional details and examples.
#' 
#' @examples 
#' library(dygraphs)
#' lungDeaths <- cbind(mdeaths, fdeaths)
#' dygraph(lungDeaths)
#' 
#' @export
dygraph <- function(data, main = NULL, xlab = NULL, ylab = NULL,
                    periodicity = NULL, group = NULL, 
                    width = NULL, height = NULL) {
  
  # convert data to xts
  if (!xts::is.xts(data))
    data <- xts::as.xts(data)
  
  # auto-detect periodicity if not otherwise specified
  if (is.null(periodicity)) {
    if (nrow(data) < 2) {
      periodicity <- defaultPeriodicity(data)
    } else {
      periodicity <- xts::periodicity(data)
    }
  }
  
  # extract time
  time <- time(data)
  
  # get data as a named list
  data <- zoo::coredata(data)
  data <- unclass(as.data.frame(data))
   
  # merge time back into list and convert to JS friendly string
  timeColumn <- list()
  timeColumn[[periodicity$label]] <- asISO8601Time(time)
  data <- append(timeColumn, data)
  
  # create native dygraph attrs object
  attrs <- list()
  attrs$title <- main
  attrs$xlabel <- xlab
  attrs$ylabel <- ylab
  attrs$labels <- names(data)
  attrs$legend <- "auto"
  attrs$retainDateWindow <- FALSE
  attrs$axes$x <- list() 
  attrs$axes$x$pixelsPerLabel <- 50
   
  # create x (dygraph attrs + some side data)
  x <- list()
  x$attrs <- attrs
  x$scale <- periodicity$scale
  x$group <- group
  x$annotations <- list()
  x$shadings <- list()
  x$events <- list()
  
  # Add attributes required for defining custom series. When a dySeries call
  # is made it places series definition in "manual mode". In this case we
  # need to save the original data.
  attr(x, "time") <- time
  attr(x, "data") <- data
  attr(x, "autoSeries") <- 2
  
  # add data (strip names first so we marshall as a 2d array)
  names(data) <- NULL
  x$data <- data
    
  # create widget
  htmlwidgets::createWidget(
    name = "dygraphs",
    x = x,
    width = width,
    height = height,
    htmlwidgets::sizingPolicy(viewer.padding = 10, browser.fill = TRUE)
  )
}


#' Shiny bindings for dygraph
#' 
#' Output and render functions for using dygraph within Shiny 
#' applications and interactive Rmd documents.
#' 
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{"100\%"},
#'   \code{"400px"}, \code{"auto"}) or a number, which will be coerced to a
#'   string and have \code{"px"} appended.
#' @param expr An expression that generates a dygraph
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This 
#'   is useful if you want to save an expression in a variable.
#'   
#' @name dygraph-shiny
#'
#' @export
dygraphOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "dygraphs", width, height)
}

#' @rdname dygraph-shiny
#' @export
renderDygraph <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, dygraphOutput, env, quoted = TRUE)
}

