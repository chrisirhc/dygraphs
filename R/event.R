#' dygraph event line
#' 
#' Add a vertical event line to a dygraph
#' 
#' @param dygraph Dygraph to add event line to
#' @param date Date/time for the event (must be a \code{POSIXct} object or 
#'   another object convertible to \code{POSIXct} via \code{as.POSIXct})
#' @param label Label for event. Defaults to blank.
#' @param labelLoc Location for label (top or bottom)
#' @param color Color of event line. This can be of the form "#AABBCC" or 
#'   "rgb(255,100,200)" or "yellow". Defaults to black.
#' @param strokePattern A predefined stroke pattern type ("dotted", "dashed",
#'   "dotdash", or "solid") or a custom pattern array where the even index is 
#'   a draw and odd is a space in pixels. Defaults to dashed.
#'   
#' @return A dygraph with the specified event line.
#'   
#' @note See the \href{http://rstudio.github.io/dygraphs/gallery-event-lines.html}{online 
#'   documentation} for additional details and examples.
#'   
#' @examples 
#' library(dygraphs)
#' 
#' dygraph(presidents, main = "Presidential Approval") %>%
#'   dyAxis("y", valueRange = c(0, 100)) %>%
#'   dyEvent("1950-6-30", "Korea", labelLoc = "bottom") %>%
#'   dyEvent("1965-2-09", "Vietnam", labelLoc = "bottom")
#'  
#' @export
dyEvent <- function(dygraph, 
                    date,
                    label = NULL, 
                    labelLoc = c("top", "bottom"),
                    color = "black", 
                    strokePattern = "dashed") {
  
  # create event
  event <- list()
  event$pos <- asISO8601Time(date)
  event$label <- label
  event$labelLoc <- match.arg(labelLoc)
  event$color <- color
  event$strokePattern <- resolveStrokePattern(strokePattern)
  event$axis <- "x"
 
  # add it to list of events
  dygraph$x$events[[length(dygraph$x$events) + 1]] <- event
  
  # return modified dygraph
  dygraph
}

#' dygraph limit line
#' 
#' Add a horizontal limit line to a dygraph
#' 
#' @param dygraph Dygraph to add limit line to
#' @param limit Numeric position of limit.
#' @param label Label for limit. Defaults to blank.
#' @param labelLoc Location for label (left or right).
#' @param color Color of limit line. This can be of the form "#AABBCC" or 
#'   "rgb(255,100,200)" or "yellow". Defaults to black.
#' @param strokePattern A predefined stroke pattern type ("dotted", "dashed",
#'   "dotdash", or "solid") or a custom pattern array where the even index is 
#'   a draw and odd is a space in pixels. Defaults to dashed.
#'   
#' @return A dygraph with the specified limit line.
#'   
#' @note See the \href{http://rstudio.github.io/dygraphs/gallery-event-lines.html}{online 
#'   documentation} for additional details and examples.
#'   
#' @examples 
#' library(dygraphs)
#' 
#' dygraph(presidents, main = "Presidential Approval") %>%
#'   dyAxis("y", valueRange = c(0, 100)) %>% 
#'   dyLimit(max(presidents, na.rm = TRUE), "Max",
#'           strokePattern = "solid", color = "blue")
#'  
#' @export
dyLimit <- function(dygraph, 
                    limit,
                    label = NULL, 
                    labelLoc = c("left", "right"),
                    color = "black", 
                    strokePattern = "dashed") {
  
  # create event
  event <- list()
  event$pos <- limit
  event$label <- label
  event$labelLoc <- match.arg(labelLoc)
  event$color <- color
  event$strokePattern <- resolveStrokePattern(strokePattern)
  event$axis <- "y"
  
  # add it to list of events
  dygraph$x$events[[length(dygraph$x$events) + 1]] <- event
  
  # return modified dygraph
  dygraph
}
