# ✈️ Airline Delay Analysis – 2024

**Author**: Abhishek Verma  
**Location**: Chicago, IL  
**Date**: June 2025  

---

## 🧠 Overview

This project investigates the key drivers of **flight delays** in U.S. domestic air travel and builds predictive models to help airlines and airports better anticipate disruptions. Using **2024 data** from the **U.S. Bureau of Transportation Statistics**, this analysis blends **statistical techniques** and **machine learning** to explore how factors like weather, carrier issues, and late arrivals impact delay outcomes.

The results inform **data-driven decision-making** for aviation stakeholders seeking to reduce costs, optimize operations, and improve the passenger experience.

---

## 📂 Project Files

| File | Description |
|------|-------------|
| `airlinedata_final_log.csv` | Cleaned dataset after preprocessing |
| `Airline_Delay_Cause.csv` | Raw dataset from BTS |
| `ProjectCode_SAS.sas` | SAS code for descriptive, regression, and ANOVA analysis |
| `ProjectCode_R.R` | R code for logistic regression and random forest |
| `Airline_Delay_Report.Rmd` | Full R Markdown report (summary, results, recommendations) |

---

## 🎯 Objective

- Identify **main contributors** to airline delays.
- Develop **predictive models** (regression, logistic, random forest).
- Quantify how **delay type**, **season**, **carrier**, and **airport size** affect outcomes.
- Recommend strategies for **forecasting and reducing delays**.

---

## 🔍 Key Questions Answered

1. What are the most common and impactful causes of flight delays?
2. How do seasonal patterns and airport/carrier characteristics influence delays?
3. Can we **predict high-delay scenarios** using machine learning?
4. Which **delay types** are most predictive of poor outcomes?
5. How do results differ between **linear models** and **ensemble models**?

---

## 📊 Key Findings

| Delay Type       | Avg. Delay (mins) | Std Dev | Insights                          |
|------------------|-------------------|---------|-----------------------------------|
| Late Aircraft     | 7.34              | 1.44    | Largest and most variable         |
| Carrier           | 6.74              | 1.22    | Strongest correlation to outcome  |
| NAS               | 5.33              | 1.80    | High unpredictability             |
| Weather           | 3.42              | 1.31    | Seasonally driven                 |
| Security          | 0.32              | 0.22    | Minimal overall impact            |

- 📈 **Carrier** and **late aircraft delays** are the strongest predictors of total delay rate.
- 🌦 **Seasonal effects** are statistically significant, especially in Q2 and Q3.
- 🌍 **Busy airports** show lower average delays per flight, likely due to better resource optimization.
- 📉 Security delays have **negative/insignificant** impact in regression models.

---

## 🧪 Predictive Modeling Performance

| Model Type          | Accuracy | AUC   | Key Strength                       |
|---------------------|----------|-------|------------------------------------|
| Simple Regression    | —        | —     | Interpretable baseline             |
| Multiple Regression  | —        | —     | R² = 0.518, best continuous fit    |
| Logistic Regression  | 70.2%    | 0.762 | Good for binary interpretation     |
| ✅ Random Forest      | **74.6%**| **0.805** | Captures nonlinear delay patterns  |

---

## 📁 Variable Highlights

| Variable         | Description                        |
|------------------|-------------------------------------|
| `DelayRate`       | Total delay minutes per flight     |
| `log_DelayRate`   | Log-transformed delay rate         |
| `BusyAirportFlag` | Binary flag for large hub airports |
| `SeasonalQuarter` | Q1 to Q4 (derived from flight date)|
| `high_delay_rate` | Binary outcome (top 35% delays)    |

---

## 🧠 Recommendations

1. **Monitor Carrier & Aircraft Turnaround**: Most predictive of major delays.
2. **Use Random Forest Model** for operational alerts and planning.
3. **Improve scheduling in Q2/Q3** when delays spike due to traffic & weather.
4. **Deploy delay dashboards** for real-time flight and gate monitoring.
5. **Integrate live FAA and NOAA feeds** to enhance predictive power.

---

## 🛠 Tools Used

- **Languages**: R, SAS  
- **Packages**: `sqldf`, `randomForest`, `caret`, `pROC`, `ggplot2`  
- **Data Format**: `.csv`  
- **Statistical Methods**: Descriptive stats, ANOVA, regression  
- **ML Models**: Logistic Regression, Random Forest  

---

## 📈 Result Summary

| Metric                        | Value       |
|------------------------------|-------------|
| Total Flights Analyzed       | 21,842      |
| Top Delay Type               | Late Aircraft (7.34 min avg) |
| R² (Multiple Regression)     | 0.518       |
| Accuracy (Random Forest)     | 74.6%       |
| AUC (Random Forest)          | 0.805       |
| Best Predictors              | Carrier, Late Aircraft, Weather |

---

## 📬 Contact

Feel free to connect or reach out via LinkedIn for feedback or collaboration opportunities.

---

> _“Small delays ripple across entire networks. Data helps us catch the first raindrop before the flood.”_
