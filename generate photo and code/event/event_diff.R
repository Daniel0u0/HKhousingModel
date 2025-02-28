# 加載必要的庫
library(dplyr)
library(ggplot2)
library(tidyr)

# 定義數據
data <- data.frame(
  區域 = c(
    "新界東", "新界東", "新界東", "新界東", "新界東",
    "新界西", "新界西", "新界西", "新界西", "新界西"
  ),
  活動類別 = c(
    "音樂會及音樂會", "戲劇", "舞蹈", "電影", "其他",
    "音樂會及音樂會", "戲劇", "舞蹈", "電影", "其他"
  ),
  year_2013 = c(800, 600, 300, 200, 100, 700, 500, 400, 300, 200),
  year_2018 = c(850, 650, 350, 250, 150, 750, 550, 450, 350, 250),
  year_2019 = c(900, 700, 400, 300, 200, 800, 600, 500, 400, 300),
  year_2020 = c(750, 550, 250, 150, 50, 650, 450, 350, 250, 150),
  year_2021 = c(800, 600, 300, 200, 100, 700, 500, 400, 300, 200),
  year_2022 = c(850, 650, 350, 250, 150, 750, 550, 450, 350, 250),
  year_2023 = c(900, 700, 400, 300, 200, 800, 600, 500, 400, 300)
)

# 整理數據：將數據從寬表格轉換為長表格
data_long <- data %>%
  pivot_longer(
    cols = starts_with("year_"),
    names_to = "年份",
    values_to = "場次"
  ) %>%
  mutate(
    年份 = as.numeric(gsub("year_", "", 年份)) # 提取年份數字
  )

# 計算新界東和新界西的活動量差異
difference_data <- data_long %>%
  group_by(活動類別, 年份) %>%
  summarise(
    新界東活動量 = sum(場次[區域 == "新界東"]),
    新界西活動量 = sum(場次[區域 == "新界西"]),
    活動量差異 = 新界東活動量 - 新界西活動量,
    .groups = "drop"
  )

# 繪製柱狀圖
ggplot(difference_data, aes(x = 年份, y = 活動量差異, fill = 活動類別)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "新界東與新界西活動量差異（2013-2023）",
    x = "年份",
    y = "活動量差異",
    fill = "活動類別"
  ) +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, hjust = 0.5),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 12)
  )