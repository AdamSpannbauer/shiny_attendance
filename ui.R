library(shiny)

ui <- fluidPage(
  fluidRow(
    br(),
    column(
      width = 6, offset = 3,
      inputPanel(
        uiOutput("file_select_dropdown"),
        radioButtons(
          "selected_is_absent",
          "Selected rows mean:",
          c("Absent", "Present"),
          selected = "Present"
        )
      ),
      DT::dataTableOutput("student_dt"),
      hr(),
      h4("Students currently marked absent:"),
      verbatimTextOutput("absent_list"),
      inputPanel(
        textInput(
          "output_label",
          "Output file label:",
          "absent_students"
        ),
        actionButton(
          "write_absences",
          label = "submit",
          icon = icon("send", verify_fa = FALSE)
        )
      )
    )
  )
)
