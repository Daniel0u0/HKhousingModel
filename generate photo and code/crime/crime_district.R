# 安裝所需的套件（如果尚未安裝）
if (!require(dplyr)) install.packages("dplyr")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(tidyr)) install.packages("tidyr")

# 載入套件
library(dplyr)
library(ggplot2)
library(tidyr)

# 數據整理：新界2020至2023年罪案數字
crime_data <- data.frame(
  區域 = c("沙田", "屯門", "葵青", "荃灣", "元朗", "北區", "西貢", "離島"),
  `2020` = c(5063, 3059, 3942, 2390, 4970, 2347, 3485, 1358),
  `2021` = c(5387, 3049, 3946, 2389, 4967, 2344, 3481, 1356),
  `2022` = c(6218, 3658, 4466, 2873, 5811, 2729, 4053, 1579),
  `2023` = c(7069, 4273, 5527, 3346, 6958, 3284, 4872, 1899)
)

# 檢查列名
print(colnames(crime_data)) # 確認列名是否與指定的年份匹配

# 如果列名有多餘字符（例如 "X2020"），清理列名
colnames(crime_data) <- gsub("^X", "", colnames(crime_data)) # 去掉前綴 "X"
colnames(crime_data) <- trimws(colnames(crime_data))        # 去掉空格

# 將數據轉換為長格式（tidy data）
crime_data_long <- crime_data %>%
  pivot_longer(
    cols = c(`2020`, `2021`, `2022`, `2023`), # 指定年份列
    names_to = "年份",
    values_to = "罪案數字"
  )

# 繪製柱狀圖
ggplot(crime_data_long, aes(x = 區域, y = 罪案數字, fill = 年份)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "2020 至 2023 年新界各區罪案數字變化",
    x = "區域",
    y = "罪案數字",
    fill = "年份"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )