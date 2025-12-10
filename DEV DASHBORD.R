# Load necessary libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(readr)
library(lubridate)
library(stringr)
library(DT)

# ==============================================================================
# UI Definition (User Interface)
# ==============================================================================
ui <- dashboardPage(
  skin = "red", # YouTube red theme
  
  dashboardHeader(title = "YouTube Comment Visualizer"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard Overview", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Data Explorer", tabName = "data", icon = icon("table")),
      
      # Sidebar Filters
      br(),
      h4("  Filter Options", style = "color: white; margin-left: 15px;"),
      selectInput("topicFilter", "Select Video Topic:", 
                  choices = c("All"), selected = "All"),
      selectInput("sentimentFilter", "Select Sentiment:", 
                  choices = c("All"), selected = "All")
    )
  ),
  
  dashboardBody(
    tabItems(
      # --- Tab 1: Dashboard Overview ---
      tabItem(tabName = "dashboard",
              # Top Info Boxes
              fluidRow(
                valueBoxOutput("totalCommentsBox"),
                valueBoxOutput("avgLikesBox"),
                valueBoxOutput("topSentimentBox")
              ),
              
              # Row 2: Sentiment & Topic Analysis
              fluidRow(
                box(
                  title = "Sentiment Distribution", status = "primary", solidHeader = TRUE,
                  plotOutput("sentimentPlot", height = 300)
                ),
                box(
                  title = "Top Video Topics by Volume", status = "primary", solidHeader = TRUE,
                  plotOutput("topicPlot", height = 300)
                )
              ),
              
              # Row 3: Engagement & Geography
              fluidRow(
                box(
                  title = "User Engagement (Likes) by Sentiment", status = "warning", solidHeader = TRUE,
                  plotOutput("engagementPlot", height = 300)
                ),
                box(
                  title = "Top 10 User Countries", status = "warning", solidHeader = TRUE,
                  plotOutput("countryPlot", height = 300)
                )
              )
      ),
      
      # --- Tab 2: Data Explorer ---
      tabItem(tabName = "data",
              fluidRow(
                box(
                  title = "Raw Data View", width = 12, status = "primary",
                  dataTableOutput("rawTable")
                )
              )
      )
    )
  )
)

# ==============================================================================
# Server Logic
# ==============================================================================
server <- function(input, output, session) {
  
  # 1. Load and Clean Data
  # We use reactive() to load data once and apply cleaning
  cleaned_data <- reactive({
    # Check if file exists
    file_name <- "C:\\Users\\AFRAAH AKBAR\\Downloads\\youtube_educational_comments_uncleaned_500.csv"
    if (!file.exists(file_name)) {
      stop("File not found! Please ensure 'youtube_educational_comments_uncleaned_500.csv' is in your working directory.")
    }
    
    df <- read_csv(file_name, show_col_types = FALSE)
    
    # Data Preprocessing Steps
    df_clean <- df %>%
      mutate(
        # Standardize text case
        sentiment = str_to_title(str_trim(sentiment)),
        video_topic = str_to_title(str_trim(video_topic)),
        user_country = str_to_title(str_trim(user_country)),
        
        # Fix messy dates using lubridate (handles multiple formats)
        date_clean = parse_date_time(date, orders = c("mdy", "dmy", "dmY", "mdY", "Ymd")),
        
        # Handle missing or messy countries
        user_country = ifelse(is.na(user_country) | user_country == "", "Unknown", user_country)
      ) %>%
      filter(!is.na(sentiment)) # Remove rows with no sentiment
    
    return(df_clean)
  })
  
  # 2. Update Filters dynamically based on data
  observe({
    df <- cleaned_data()
    updateSelectInput(session, "topicFilter", 
                      choices = c("All", sort(unique(df$video_topic))))
    updateSelectInput(session, "sentimentFilter", 
                      choices = c("All", sort(unique(df$sentiment))))
  })
  
  # 3. Filter Data based on UI inputs
  filtered_data <- reactive({
    df <- cleaned_data()
    
    if (input$topicFilter != "All") {
      df <- df %>% filter(video_topic == input$topicFilter)
    }
    if (input$sentimentFilter != "All") {
      df <- df %>% filter(sentiment == input$sentimentFilter)
    }
    df
  })
  
  # 4. Outputs
  
  # -- Value Boxes --
  output$totalCommentsBox <- renderValueBox({
    valueBox(
      nrow(filtered_data()), "Total Comments", icon = icon("comments"), color = "blue"
    )
  })
  
  output$avgLikesBox <- renderValueBox({
    avg_likes <- round(mean(filtered_data()$likes, na.rm = TRUE), 0)
    valueBox(
      avg_likes, "Avg Likes per Comment", icon = icon("thumbs-up"), color = "green"
    )
  })
  
  output$topSentimentBox <- renderValueBox({
    df <- filtered_data()
    if(nrow(df) > 0) {
      top_sent <- df %>% count(sentiment) %>% top_n(1, n) %>% pull(sentiment)
    } else {
      top_sent <- "N/A"
    }
    valueBox(
      top_sent, "Dominant Sentiment", icon = icon("heart"), color = "red"
    )
  })
  
  # -- Plot 1: Sentiment Distribution --
  output$sentimentPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = sentiment, fill = sentiment)) +
      geom_bar() +
      scale_fill_brewer(palette = "Pastel1") +
      theme_minimal() +
      labs(x = "Sentiment", y = "Count") +
      theme(legend.position = "none")
  })
  
  # -- Plot 2: Topic Popularity (Top 10) --
  output$topicPlot <- renderPlot({
    # Use full dataset for this plot to show context, or filtered if preferred
    # Here we use filtered to reflect user selection if they filter by sentiment
    data_to_plot <- filtered_data() %>%
      count(video_topic) %>%
      top_n(10, n)
    
    ggplot(data_to_plot, aes(x = reorder(video_topic, n), y = n)) +
      geom_bar(stat = "identity", fill = "#cc181e") + # YouTube red
      coord_flip() +
      theme_minimal() +
      labs(x = "Topic", y = "Number of Comments")
  })
  
  # -- Plot 3: Engagement (Likes) vs Sentiment --
  output$engagementPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = sentiment, y = likes, fill = sentiment)) +
      geom_boxplot(alpha = 0.7) +
      scale_fill_brewer(palette = "Pastel1") +
      theme_minimal() +
      labs(x = "Sentiment", y = "Likes") +
      theme(legend.position = "none")
  })
  
  # -- Plot 4: Country Distribution --
  output$countryPlot <- renderPlot({
    data_to_plot <- filtered_data() %>%
      count(user_country) %>%
      top_n(10, n)
    
    ggplot(data_to_plot, aes(x = reorder(user_country, n), y = n)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      coord_flip() +
      theme_minimal() +
      labs(x = "Country", y = "Comment Count")
  })
  
  # -- Data Table --
  output$rawTable <- renderDataTable({
    filtered_data() %>%
      select(username, video_topic, comment_text, sentiment, likes, user_country)
  }, options = list(scrollX = TRUE))
}

# ==============================================================================
# Run the Application
# ==============================================================================
shinyApp(ui = ui, server = server)