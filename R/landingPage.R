#' @name createLandingPage
#' 
#' @title Create landing page in shiny qc when no `SummarizedExperiment` is 
#' supplied
#' 
#' @description
#' The function `createLandingPage` will load the UI when the `launch` button
#' is hit. It will pass the loaded `SUmmarizedExperiment` object to the 
#' function `FUN` and will load the tab panels (`show("tabPanelSE")`) and will
#' hide the upload interface `hide("uploadSE")`.
#' 
#' @details 
#' Internal usage in `shinyQC`. Modified from `iSEE` package. 
#' 
#' @param seUI `function` or `NULL`
#' @param seLoad `function` or `NULL`
#' @param requireButton `logical`
#' 
#' @examples
#' \dontrun{
#' createLandingPage(seUI = NULL, seLoad = NULL, requireButton = TRUE)
#' }
#' 
#' @author authors of `iSEE` package, adjusted by Thomas Naake
#' 
#' @importFrom shiny fileInput renderUI tagList actionButton observeEvent
#' @importFrom shiny showNotification insertTab
#' @importFrom shinyjs show hide
#' @importFrom methods is
#' 
#' @noRd
createLandingPage <- function(seUI = NULL, seLoad = NULL, 
    requireButton = TRUE) {
    
    if (is.null(seUI)) {
        seUI <- function(id) shiny::fileInput(id, 
            "SummarizedExperiment RDS file:", multiple = FALSE)
    }
    if (is.null(seLoad)) {
        seLoad <- function(x) readRDS(x$datapath)
    }

    force(requireButton)
    
    function (FUN, input, output, session, app_server) {
        
        output$allPanels <- shiny::renderUI({
            shiny::tagList(
                seUI("upload"),
                if (requireButton) shiny::actionButton("launch", 
                                                            label = "Launch")
            )
        })
        
        target <- if (requireButton) "launch" else "upload"
        
        shiny::observeEvent(input[[target]], {
            se2 <- try(seLoad(input[["upload"]]))
            if (is(se2, "try-error")) {
                shiny::showNotification("invalid SummarizedExperiment supplied", 
                                                                type = "error")
            } else {
                
                if (!is(se2, "SummarizedExperiment")) 
                    stop("se is not of class 'SummarizedExperiment'")
                if (is.null(rownames(se2))) 
                    stop("rownames(se) is NULL")
                if (is.null(colnames(se2)))
                    stop("colnames(se) is NULL")
                
                ## access the assay slot
                a <- SummarizedExperiment::assay(se2)
                
                ## access the colData slot and add the rownames as a new column to cD
                ## (will add the column "rowname")
                cD <- SummarizedExperiment::colData(se2) |> as.data.frame()
                if (!all(colnames(se2) == rownames(cD)))
                    stop("colnames(se) do not match rownames(colData(se))")
                if (!all(colnames(a) == rownames(cD)))
                    stop("colnames(assay(se)) do not match rownames(colData(se))")
                
                ## if the launch button was pressed and the se is valid
                ## load the tabPanel and hide the upload button
                ## tabPanel for tab "Measured Values"
                missingValue2 <- missingValuesSE(se2)
                if (missingValue2) shiny::insertTab(inputId = "tabs", 
                    tP_measuredValues_all(), target = "Samples", 
                    position = "after")
                ## tabPanel for tab "Missing Values"
                if (missingValue2) shiny::insertTab(inputId = "tabs", 
                    tP_missingValues_all(), target = "Measured Values", 
                    position = "after")
                shinyjs::show("tabPanelSE")
                shinyjs::show("sidebarPanelSE")
                shinyjs::hide("uploadSE")
                FUN(SE = se2, MISSINGVALUE = missingValue2)
            }
        }, ignoreNULL = TRUE, ignoreInit = TRUE)
        
        invisible(NULL)
    }
}
