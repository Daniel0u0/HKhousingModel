# 安裝必要的套件（如果尚未安裝）
if (!require(dplyr)) install.packages("dplyr")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(ggpubr)) install.packages("ggpubr")  # 用於添加相關性標籤

# 載入套件
library(dplyr)
library(ggplot2)
library(ggpubr)

# 數據準備：2022年人口數據（手動輸入）
population_data <- data.frame(
  區域 = c("沙田", "大埔", "北區", "西貢", "荃灣", "屯門", "元朗", "葵青", "離島"),
  人口數目 = c(684300, 311300, 331200, 489800, 307800, 500500, 652500, 482400, 180100) # 人口數據
)

# 數據準備：2023年犯罪數據
crime_data <- data.frame(
  區域 = c("沙田", "大埔", "北區", "西貢", "荃灣", "屯門", "元朗", "葵青", "離島"),
  犯罪數量2023 = c(7069, 2115, 3284, 4872, 3346, 4273, 6958, 5527, 1899)  # 犯罪數據
)

# 合併人口數據與犯罪數據
data <- merge(population_data, crime_data, by = "區域")

# 計算犯罪率（每千人犯罪數量）
data <- data %>%
  mutate(犯罪率每千人 = 犯罪數量2023 / 人口數目 * 1000)

# 計算人口數目與犯罪數量的相關係數
correlation <- cor(data$人口數目, data$犯罪數量2023)

# 繪製散點圖
ggplot(data, aes(x = 人口數目, y = 犯罪數量2023)) +
  geom_point(color = "blue", size = 3) +                                 # 散點
  geom_smooth(method = "lm", color = "red", se = FALSE) +               # 添加回歸線
  labs(
    title = "人口數目與犯罪數量的相關性（新界2023）",
    x = "人口數目",
    y = "犯罪數量"
  ) +
  annotate(
    "text", x = max(data$人口數目) * 0.7, y = max(data$犯罪數量2023) * 0.9,
    label = paste("相關係數: ", round(correlation, 2)),
    size = 5, color = "darkred"
  ) +
  theme_minimal()