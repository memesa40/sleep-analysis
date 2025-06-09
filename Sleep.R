
# does gender affect sleep ??
## here is data from Zendels et al., Cogent Psychology (2021)
### I'll use this data to generate random samples
install.packages("tidyverse")
install.packages("tibble")
install.packages("infer")


library(tidyverse)
library(tibble)
library(infer)

set.seed(123)
n <- 173

gender_levels <- c("male", "female", "nonbinary")
gender_probs <- c(0.5, 0.5, 0.0058)
gender <- sample(gender_levels, size = n, replace = TRUE, prob = gender_probs)

race_levels <- c("caucasian", "african american", "asian american", "mixed/other")
race_probs <- c(119, 22, 20, 12) / 173
race <- sample(race_levels, size = n, replace = TRUE, prob = race_probs)

age <- rnorm(n, mean = 33.31, sd = 9.87)
socio_economic_status <- rnorm(n, mean = 4.76, sd = 1.76)

sleep_disorder_levels <- c("Insomnia", "Narcolepsy", "Sleep Apnea", "Sleepwalking","No diagnosed disorder")
sleep_disorder_counts <- c(14, 1, 15, 2,141)
sleep_disorders <- sample(sleep_disorder_levels, size = n, replace = TRUE, prob = sleep_disorder_counts / sum(sleep_disorder_counts))

hygiene <- numeric(n)
sleep_quality <- numeric(n)
sleep_duration <- numeric(n)

 n <- 173

 
 for (i in seq_len(n)) {
   if (gender[i] == "male") {
     hygiene[i] <- rnorm(1, 79.69, 26.60)
     sleep_quality[i] <- max(min(rnorm(1, 5.22, 3.79), 10), 0)
     sleep_duration[i] <- rnorm(1, 7.48, 1.64)
   } else if (gender[i] == "female") {
     hygiene[i] <- rnorm(1, 76.45, 20.97)
     sleep_quality[i] <- max(min(rnorm(1, 6.05, 3.74), 10), 0)
     sleep_duration[i] <- rnorm(1, 7.17, 1.17)
   } else {
     hygiene[i] <- rnorm(1, mean(c(79.69, 76.45)), mean(c(26.60, 20.97)))
     sleep_quality[i] <- max(min(rnorm(1, mean(c(5.22, 6.05)), mean(c(3.79, 3.74))), 10), 0)
     sleep_duration[i] <- rnorm(1, mean(c(7.48, 7.17)), mean(c(1.64, 1.17)))
   }
 }
 
 
 simulated_data <- tibble(
   Age = age,
   Gender = gender,
   Race = race,
   SES = socio_economic_status,
   Sleep_Disorder = sleep_disorders,
   Hygiene = hygiene,
   Sleep_Quality = sleep_quality,
   Sleep_Duration = sleep_duration
 )
head(simulated_data)

# who sleeps worse 
simulated_data %>% 
  ggplot(aes(Gender, Sleep_Quality, color = Gender)) +
  geom_boxplot() +
  geom_jitter()

simulated_data %>%
  ggplot(aes(SES, Sleep_Quality, color = SES)) +
  geom_point() +
  scale_color_continuous()



simulated_data %>%
  ggplot(aes(Hygiene, Sleep_Quality, color = Hygiene))+
  geom_point() +
  scale_color_gradient(low = "green", high = "darkblue")

simulated_data %>% 
  ggplot(aes(x = Age, y = Sleep_Quality, alpha = 0.7, color = Sleep_Disorder)) +
  geom_point(stat = "identity", position = "dodge") +  
  facet_wrap(Race~.)+
  scale_color_manual(values = c("Insomnia"="#BF8233", "Narcolepsy"="#337EBF","No diagnosed disorder"="#C6D372","Sleep Apnea"="#D372C0","Sleepwalking"="#4BD7BB"))

# i will remove the "no diagnosed disorder" from the sleep disorder group 

simulated_data_disorders_only <- simulated_data %>%
  filter(Sleep_Disorder != "No diagnosed disorder" )

simulated_data_disorders_only %>% 
  ggplot(aes(x = Age, y = Sleep_Quality, color = Sleep_Disorder)) +
  geom_point(stat = "identity", position = "dodge") +  
  facet_wrap(Gender~.)

# to clearly view age's effects we can create age groups and compare 

simulated_data <- simulated_data %>%
  mutate(Age_Group = cut(Age,
                         breaks = c(0, 15, 30, 45, 60, 75, 90),
                         labels = c("0-15", "15-30", "30-45", "45-60","60-75", "75-90"),
                         right = FALSE))

simulated_data %>%
  ggplot(aes(Sleep_Quality, color= Age_Group))+
  geom_boxplot()


simulated_data %>%
  ggplot(aes(Sleep_Duration, color= Sleep_Disorder))+
  geom_boxplot()


#it would seem that the greatest difference seen in sleep quality is seen among different genders and sleep disorders
##

simulated_data %>%
  ggplot(aes(sample = Sleep_Quality, color = Gender)) +
  geom_qq() +
  geom_qq_line() +
  facet_wrap(~Sleep_Disorder) +
  scale_color_manual(values = 
                       c("female" = "#CC6CE7",
                         "male" = "#FFDE59", 
                         "nonbinary" = "#BFD641"))+
  labs(title = "QQ Plot of Sleep Quality by Gender and Sleep Disorder",x = "Theoretical Quantiles",y = "Sample Quantiles")

simulated_data %>%
  ggplot(aes(sample = Sleep_Duration, color = Gender)) +
  geom_qq() +
  geom_qq_line() +
  facet_wrap(~Sleep_Disorder) +
  scale_color_manual(values = 
                       c("female" = "#6AC2AA",
                         "male" = "#C26A84", 
                         "nonbinary" = "#BFD641"))+
  labs(title = "QQ Plot of Sleep Duration by Gender and Sleep Disorder",x = "Theoretical Quantiles",y = "Sample Quantiles")


# it would also seem that males had better sleep quantity and females had better sleep quality despite the sleep disorder
## is it a random finding ???
### or does it mean smth ¯\\_(ツ)_/¯ ??

simulated_data_filtered <- simulated_data %>%
  filter(Gender %in% c("male", "female"))%>%
  mutate(Sleep_Quality_Class = ifelse(Sleep_Quality < median(Sleep_Quality), "high quality", "low quality") )


diff_orig <- simulated_data_filtered %>%
  group_by(Gender) %>%
  summarize(mean_qu = mean(Sleep_Quality))%>%
  summarize(stat = diff(mean_qu)) %>%
  pull(stat) 
diff_orig

sleep_null <- simulated_data_filtered %>%
  specify(Sleep_Quality ~ Gender) %>%
  hypothesize(null = "independence") %>%
  generate(reps = 1000, type = "permute") %>%
  calculate(stat = "diff in means", order = c("male", "female"))

sleep_null %>% ggplot(aes(x = stat)) +
  geom_histogram(binwidth = 0.1, fill = "#809FE3", color = "grey") +
  geom_vline(xintercept = diff_orig, color = "red", linewidth = 0.7) +
  annotate("rect", xmin = -Inf, xmax = diff_orig, ymin = -Inf, ymax = Inf, fill = "red", alpha = 0.2) +
  labs(title = "Permutation Distribution of Difference in means",
       x = "Difference in means (Male - Female)",
       y = "Count")

# null hypothesis cannot be rejected :@ i think 
## we will calculated the p-value as well, for good measure

sleep_null %>%
  summarize(p_value = mean(stat <= diff_orig))

sleep_null%>%
  get_p_value(obs_stat = diff_orig, direction = "less")

# finally i will create a regression model

multiple_regressions <- lm(Sleep_Quality ~ Gender + Age + Race + SES + Hygiene, data = simulated_data_filtered)
summary(multiple_regressions)


#Gender had the smallest and least significant effect on sleep quality.
#Race (Mixed/Other) had the largest and statistically significant negative effect (at the 0.05 level)
## overall these factors don't explain variance in sleep quality 
## This analysis is just practice and does not necessarily reflect a real world conclusion
## I have also used the CLT to create two equal groups in females and males but with the same proportions of characteristics
### the accuracy is therefore is highly dependent on the randomness in group selection and the underlying distribution of the original data
