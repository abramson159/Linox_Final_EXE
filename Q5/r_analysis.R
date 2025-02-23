# טעינת חבילות
library(dplyr)
library(ggplot2)

# קריאת קובץ ה-CSV
data <- read.csv("animal_data.csv")

# יצירת קובץ פלט
output_file <- "5_R_outputs.txt"
sink(output_file)

cat("🔍 **R Analysis Results**\n\n")

# 1️⃣ Group by Species and Calculate Mean Weight
cat("\n1️⃣ Mean Weight by Species:\n")
mean_weight <- data %>%
  group_by(Species) %>%
  summarise(Mean_Weight = mean(Weight, na.rm = TRUE))
print(mean_weight)

# 2️⃣ Calculate Total Weight by Species
cat("\n2️⃣ Total Weight by Species:\n")
total_weight <- data %>%
  group_by(Species) %>%
  summarise(Total_Weight = sum(Weight, na.rm = TRUE))
print(total_weight)

# 3️⃣ Plotting Image - Weight Distribution by Sex
cat("\n3️⃣ Generating Weight Distribution Plot by Sex...\n")
ggplot(data, aes(x = Sex, y = Weight, fill = Sex)) +
  geom_boxplot() +
  ggtitle("Weight Distribution by Sex") +
  theme_minimal()
ggsave("weight_distribution_by_sex.png")

# 4️⃣ Count Number of Records per Species
cat("\n4️⃣ Number of Records per Species:\n")
record_count <- data %>%
  group_by(Species) %>%
  summarise(Record_Count = n())
print(record_count)

# סיום כתיבת הפלט
sink()

cat("\n✅ Analysis completed successfully. Results saved to 5_R_outputs.txt.\n")
