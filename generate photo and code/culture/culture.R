# 加載必要的庫
library(dplyr)
library(ggplot2)
library(tidyr)

# 定義地點數據
data <- data.frame(
  地點 = c(
    "沙田大會堂", "大埔文娛中心", "上水文娛中心",
    "屯門大會堂", "元朗劇院", "葵青劇院", "荃灣大會堂"
  ),
  地區 = c("新界東", "新界東", "新界東", "新界西", "新界西", "新界西", "新界西"),
  year_2013 = c(98, 86, 65, 99, 96, 99, 99),
  year_2018 = c(99, 79, 97, 100, 94, 99, 100),
  year_2019 = c(100, 74, 94, 99, 94, 99, 100),
  year_2020 = c(96, 89, 98, 96, 99, 99, 97),
  year_2021 = c(98, 90, 100, 95, 99, 99, 97),
  year_2022 = c(100, 97, 100, 99, 99, 100, 99),
  year_2023 = c(100, 97, 100, 100, 99, 100, 100)
)

# 整理數據：將數據從寬表格轉換為長表格
data_long <- data %>%
  pivot_longer(
    cols = starts_with("year_"),
    names_to = "年份",
    values_to = "使用率"
  ) %>%
  mutate(
    年份 = as.numeric(gsub("year_", "", 年份)) # 提取年份數字
  )

# 計算新界東和新界西的平均使用率
region_data <- data_long %>%
  group_by(地區, 年份) %>%
  summarise(平均使用率 = mean(使用率), .groups = "drop")

# 繪製折線圖
ggplot(region_data, aes(x = 年份, y = 平均使用率, color = 地區, group = 地區)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "新界東與新界西主要文化場地使用率（2013-2023）",
    x = "年份",
    y = "平均使用率 (%)",
    color = "地區"
  ) +
  scale_color_manual(values = c("新界東" = "steelblue", "新界西" = "darkorange")) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, hjust = 0.5),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 12)
  )