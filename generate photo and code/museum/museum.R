# 加載必要的庫
library(dplyr)
library(ggplot2)
library(tidyr)

# 定義博物館數據
data <- data.frame(
  博物館名稱 = c(
    "香港文化博物館",
    "上窰民俗文物館",
    "三棟屋博物館"
  ),
  地區 = c("新界東", "新界東", "新界西"),
  year_2013 = c(624310, 42382, 91268),
  year_2018 = c(733811, 40177, 111265),
  year_2019 = c(666162, 39638, 95632),
  year_2020 = c(111888, 20984, 13142),
  year_2021 = c(336895, 26592, 32878),
  year_2022 = c(328381, 3003, 38019),
  year_2023 = c(724011, 41128, 97109)
)

# 整理數據：將數據從寬表格轉換為長表格
data_long <- data %>%
  pivot_longer(
    cols = starts_with("year_"),
    names_to = "年份",
    values_to = "人流量"
  ) %>%
  mutate(
    年份 = as.numeric(gsub("year_", "", 年份)) # 提取年份數字
  )

# 計算新界東和新界西的總參觀人次
region_data <- data_long %>%
  group_by(地區, 年份) %>%
  summarise(總人流量 = sum(人流量), .groups = "drop")

# 繪製折線圖
ggplot(region_data, aes(x = 年份, y = 總人流量, color = 地區, group = 地區)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "新界東與新界西博物館參觀人次（2013-2023）",
    x = "年份",
    y = "總參觀人次",
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