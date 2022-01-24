library(shiny)

server <- function(input, output) {
  roster_paths <- reactive({
    full_paths <- list.files(
      "student_rosters/",
      pattern = ".+\\.csv",
      full.names = TRUE
    )

    display_paths <- basename(full_paths)

    names(full_paths) <- display_paths

    full_paths
  })

  output$file_select_dropdown <- renderUI({
    selectInput(
      "selected_file",
      "Select student roster:",
      roster_paths()
    )
  })

  selected_roster_df <- reactive({
    req(input$selected_file)
    read.csv(input$selected_file)
  })

  output$student_dt <- DT::renderDataTable({
    selected_roster_df()
  })

  absent_idxs <- reactive(
    input$student_dt_rows_selected
  )

  absent_df <- reactive(
    student_df[absent_idxs(), ]
  )

  output$absent_list <- renderPrint({
    absent_df()$student
  })

  observeEvent(input$write_absences, {
    req(length(absent_idxs()) > 0)

    if (nchar(input$output_label)) {
      prefix <- paste0(input$output_label, "_")
    } else {
      prefix <- "absences_"
    }

    time_stamp <- strftime(Sys.time(), "%Y_%m_%d_%H%M%S")
    file_name <- paste0(prefix, time_stamp, ".csv")

    write.csv(
      absent_df(),
      file.path("attendance_results", file_name),
      row.names = FALSE
    )
  })
}
