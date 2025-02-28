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
  區域 = c("沙田", "大埔", "北區", "西貢", "荃灣", "屯門", "元朗", "葵青", "離島"),
  `2020` = c(5063, 3148, 2347, 3485, 2390, 3059, 4970, 3942, 1358),
  `2021` = c(5387, 3346, 2344, 3481, 2389, 3049, 4967, 3946, 1356),
  `2022` = c(6218, 3148, 2729, 4053, 2873, 3658, 5811, 4466, 1579),
  `2023` = c(7069, 2115, 3284, 4872, 3346, 4273, 6958, 5527, 1899)
)

# 檢查列名
print(colnames(crime_data))

# 清理列名（如果列名有多餘字符）
colnames(crime_data) <- gsub("^X", "", colnames(crime_data))  # 去掉前綴 "X"
colnames(crime_data) <- trimws(colnames(crime_data))         # 去掉空格

# 添加新界東和新界西標籤
crime_data <- crime_data %>%
  mutate(
    區域分類 = case_when(
      區域 %in% c("沙田", "大埔", "北區", "西貢") ~ "新界東",
      區域 %in% c("荃灣", "屯門", "元朗", "葵青", "離島") ~ "新界西"
    )
  )

# 按區域分類（新界東、新界西）合併數字
crime_data_grouped <- crime_data %>%
  group_by(區域分類) %>%
  summarise(
    `2020` = sum(`2020`),
    `2021` = sum(`2021`),
    `2022` = sum(`2022`),
    `2023` = sum(`2023`)
  )

# 將數據轉換為長格式（tidy data）
crime_data_long <- crime_data_grouped %>%
  pivot_longer(
    cols = starts_with("20"), # 選擇包含年份的列
    names_to = "年份",
    values_to = "罪案數字"
  )

# 繪製柱狀圖
ggplot(crime_data_long, aes(x = 區域分類, y = 罪案數字, fill = 年份)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "2020 至 2023 年新界東與新界西罪案數字變化",
    x = "區域分類",
    y = "罪案數字",
    fill = "年份"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.text.x = element_text(size = 12),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )