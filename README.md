# YouTube Comment Visualizer 📊

**A Data-Driven Dashboard for Educational Insight Mining**

![Project Status](https://img.shields.io/badge/Status-Review_3_Complete-success)
![Tech Stack](https://img.shields.io/badge/Stack-R_Shiny_%7C_Python_%7C_IBM_Watsonx-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 📖 Overview

The **YouTube Comment Visualizer** is an advanced analytical tool designed to bridge the gap between raw viewer feedback and pedagogical improvement. By leveraging **IBM Watsonx** for intelligent processing and **R Shiny** for interactive visualization, this system transforms thousands of unstructured comments into actionable educational insights.

Traditional manual feedback analysis is inefficient and prone to bias. This project automates the entire data pipeline—from cleaning noisy text to visualizing sentiment trends—empowering educators and content creators to make data-informed decisions that enhance learner engagement.

---

## 🚀 Key Features

* **Real-Time Interactive Dashboard:** A dynamic interface built with **R Shiny** allowing users to filter insights by "Video Topic", "Sentiment", and "Geography" instantly.
* **Automated Data Pipeline:** A robust **Python** backend that programmatically cleans mixed date formats, removes text noise (emojis/URLs), and handles missing values.
* **AI-Powered Sentiment Analysis:** Utilizes NLP techniques to classify learner feedback into **Positive**, **Neutral**, and **Negative** categories with high accuracy.
* **Engagement Correlation:** Advanced analytics that cross-reference quantitative metrics (Like Counts) with qualitative sentiment to identify high-impact content.
* **Global Learner Mapping:** Geographic visualization tools to track and analyze the international reach of educational content.

---

## 🛠️ Technology Stack

| Category | Technology / Tool |
| :--- | :--- |
| **Frontend Interface** | R, Shiny, Shinydashboard |
| **Backend Processing** | Python (Pandas, NumPy, Regex) |
| **AI & NLP** | IBM Watsonx.ai (Sentiment Labeling) |
| **Visualization** | ggplot2, Plotly, DT (Interactive Tables) |
| **Data Storage** | Structured CSV |
| **Environment** | RStudio, Visual Studio Code |

---

## ⚙️ Methodology & Workflow

1.  **Data Acquisition:** Raw user interaction data is fetched via the YouTube Data API v3 or curated from academic Kaggle datasets.
2.  **Intelligent Preprocessing:**
    * **Noise Reduction:** Removal of spam, emojis, and special characters.
    * **Standardization:** Normalizing date formats and text casing for consistency.
3.  **Sentiment Classification:** The processed text is passed through an NLP model to assign sentiment labels.
4.  **Interactive Visualization:** The clean, structured data is rendered in the R Shiny dashboard for exploration.

---

## 📊 Visualizations Included

The dashboard features a suite of analytical charts:
* **Sentiment Distribution Bar Chart:** Visualizes the ratio of positive vs. negative feedback.
* **Topic Popularity Ranking:** Identifies the most discussed educational subjects.
* **Engagement vs. Sentiment Boxplot:** Analyzes whether controversial topics generate more engagement.
* **Geographic User Map:** Displays the top countries where the learner base is active.

---

## 🔧 Setup & Installation

### Prerequisites
* **R** (Version 4.0+) and **RStudio**.
* **Python 3.x**.

### Step 1: Data Preprocessing
Run the backend script to clean the raw dataset:
```bash
pip install pandas numpy
python preprocessing/clean_data.py
