renderChart3 <- function(expr, env = parent.frame(), quoted = FALSE) {
        func <- shiny::exprToFunction(expr, env, quoted)
        function() {
                rChart_ <- func()
                cht_style <- paste("rChart {width: ",
                                   rChart_$params$width,
                                   "; height: ",
                                   rChart_$params$height,
                                   "}", sep = "")
                cht <- paste(capture.output(rChart_$print()), collapse = '\n')
                #fcht <- paste(c(cht_style, cht), collapse = '\n')
                fcht <- paste(c(cht), collapse = '\n')
                fcht <- gsub("\\\\", "\\", fcht, fixed=T)
                HTML(fcht)
        }
}