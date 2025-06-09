# 💤 Does Gender Affect Sleep?  
*A Simulation-Based Statistical Exploration Using R*

This R project simulates sleep data to explore whether gender influences sleep quality, hygiene, and duration. It is inspired by **Zendels et al., Cogent Psychology (2021)** and is intended as a statistical learning exercise using simulation, visualization, permutation testing, and linear regression.

> ⚠️ **Disclaimer:** In this project, I use simulated data for practice purposes ONLY. Conclusions are not generalizable to real populations.

---

## 🧪 Hypothesis

**Null Hypothesis (H₀):** There is no difference in sleep quality between male and female participants.  
**Alternative Hypothesis (H₁):** There is a difference in sleep quality between male and female participants.

---

## 🧰 Requirements

Install the necessary R packages before running:

```r
install.packages("tidyverse")
install.packages("tibble")
install.packages("infer")
```
## ▶️ How to Run

1. Open the project in **RStudio** or another R environment.
2. Clone the repository or download the `.R` file.
3. Run the entire script from top to bottom.

### 📈 Review Outputs

- Simulated dataset  
- Exploratory plots  
- Permutation test and p-value  
- Regression model summary  

> 📌 **Tip:** For reproducible results, the script includes `set.seed(123)`.

---

## 🔍 Analysis Overview

- **Sample size:** 173  
- **Variables simulated:**  
  `gender`, `age`, `race`, `SES`, `diagnosis`, `sleep hygiene`, `sleep quality`, `sleep duration`

### 🧪 Statistical Techniques Used

- Group-wise summary and filtering  
- Permutation test (via the `infer` package) to test H₀

 ![image](https://github.com/user-attachments/assets/8e741fec-758d-4525-b91c-7da4a0610114)

- Multiple linear regression model

 ![image](https://github.com/user-attachments/assets/c51e70b3-cbff-4820-963e-1e3fcd916fab)

- Data visualization:  
  - Boxplots  
  - Scatter plots  
  - QQ plots  

---

## 📊 Visualization Examples

-  **Sleep quality by gender**
  
![Rplot05](https://github.com/user-attachments/assets/48804e31-d5d1-4e01-a01f-8b7d06b35fdc)

-  **Sleep hygiene vs. sleep quality**

 ![Rplot07](https://github.com/user-attachments/assets/fcdeb8e3-54c5-4739-91ce-4e07155e4aa8)
 
-  **Sleep quality by age**

 ![Rplot00](https://github.com/user-attachments/assets/f13445ce-d2cc-45bb-b530-81d8d6dbf1f3)

-  **Permutation test histogram**

![Rplot03](https://github.com/user-attachments/assets/66d7c85b-3d63-468e-95cc-124dba6832df)

---

## ✅ Recommended Setup

- **R version:** 4.2+  
- **RStudio:** 2023.06 or later  
- **Screen resolution:** 1080p or higher (for best plot clarity)  
- **Time to run:** Less than 1 minute  

---

## ⚠️ Limitations

-  **Simulated data**: Based on averages and assumptions; not real patient data  
-  **High dependency on randomness**: Results vary with each simulation  
-  **Assumptions**: Independence and normality assumed but may not hold true in reality
-  **QQ plots**: Show some deviations from normality  

---

## 💡 Key Concepts Explored

-  Simulating real-world-like data using summary statistics  
-  Visualizing sleep quality and duration across demographics  
-  Using permutation tests to assess group differences (via `infer`)  
-  Fitting and interpreting linear regression models  
-  Practicing `tidyverse` and `infer` workflows in R  

---

## References

Zendels, B., et al. (2021). Sleep Quality and Gender Differences. *Cogent Psychology*.
