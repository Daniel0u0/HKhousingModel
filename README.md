Hong Kong Housing Prediction & Livability Score Model (HKhousingModel)

An R-based predictive modeling project focused on Hong Kong housing data across all 18 districts, with a special emphasis on the New Territories. This tool evaluates regional attributes to predict property trends and generates a composite livability score to assist in residential decision-making.

📌 Project Highlights

18-District Data Integration: Comprehensive analysis leveraging spatial and environmental datasets across Hong Kong's 18 districts.

Focused New Territories Predictions: Dedicated predictive modeling tailored to the nuances of key areas in the New Territories (e.g., Sha Tin, Tuen Mun, Yuen Long, Tai Po).

Livability Scoring Index: A custom scoring algorithm that translates complex urban variables into an intuitive residential score.

R & RStudio Ecosystem: Built entirely using R for statistics, machine learning, and visualization.

🛠️ Tech Stack & Dependencies

Environment: RStudio

Language: R

Recommended Packages:

tidyverse (Data manipulation and transformation)

ggplot2 (Data visualization)

caret / randomForest / stats (Machine learning & predictive modeling)

sf / leaflet (Spatial analytics and mapping, if applicable)

📂 Repository Structure

HKhousingModel/
├── data/               # Raw and processed datasets
├── scripts/            # R scripts (data cleaning, modeling, scoring)
├── models/             # Trained models (.rds / .RData)
├── output/             # Predictions, plots, and analysis reports
├── README.md           # Project documentation
└── HKhousingModel.Rproj # RStudio project file


(Note: Adjust the folder structure above to match your exact repository layout.)

🚀 Getting Started

1. Clone the Repository

git clone https://github.com/Daniel0u0/HKhousingModel.git
cd HKhousingModel


2. Install Required Packages

Open RStudio and run the following in your console:

install.packages(c("tidyverse", "caret", "ggplot2"))


3. Run the Model

Open HKhousingModel.Rproj in RStudio and execute the main pipeline script:

source("scripts/main.R")


📊 Livability Scoring Methodology

The livability score evaluates districts based on several key dimensions:

Accessibility: Proximity to MTR stations and major bus network connectivity.

Amenities & Infrastructure: Density of commercial spaces, green parks, and essential public facilities.

Affordability Ratio: Projected housing prices relative to median income levels.

Environment & Quality of Life: Population density, noise metrics, and spaciousness indicators.

🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page or submit a pull request.

Fork the Project

Create your Feature Branch (git checkout -b feature/NewFeature)

Commit your Changes (git commit -m 'Add NewFeature')

Push to the Branch (git push origin feature/NewFeature)

Open a Pull Request

📄 License

Distributed under the MIT License.
