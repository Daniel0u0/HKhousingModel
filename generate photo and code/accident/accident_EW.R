# 安裝 ggplot2 套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")

# 載入 ggplot2 套件
library(ggplot2)
library(dplyr)

# 創建數據框
traffic_data <- data.frame(
  Year = c(rep(2020, 9), rep(2021, 9), rep(2022, 9), rep(2023, 9)),
  District = rep(c("大埔", "元朗", "屯門", "北區", "西貢", "沙田", "荃灣", "葵青", "離島"), 4),
  Accidents = c(1074, 1571, 754, 690, 725, 1403, 926, 858, 322, # 2020
                1211, 1859, 944, 812, 803, 1617, 962, 973, 365, # 2021
                900, 1384, 687, 645, 682, 1455, 941, 896, 361, # 2022
                NA, 776, 369, NA, 139, 574, 992, NA, NA) # 2023
)

# 添加區域分類（新界東和新界西）
traffic_data <- traffic_data %>%
  mutate(
    RegionGroup = case_when(
      District %in% c("大埔", "北區", "西貢", "沙田") ~ "新界東",
      District %in% c("元朗", "屯門", "荃灣", "葵青", "離島") ~ "新界西",
      TRUE ~ "其他"
    )
  )

# 按區域分類匯總數據
traffic_data_grouped <- traffic_data %>%
  filter(RegionGroup %in% c("新界東", "新界西")) %>% # 只保留新界東和新界西
  group_by(Year, RegionGroup) %>%
  summarise(Accidents = sum(Accidents, na.rm = TRUE), .groups = "drop") # 匯總交通意外數

# 繪製折線圖
ggplot(traffic_data_grouped, aes(x = Year, y = Accidents, color = RegionGroup, group = RegionGroup)) +
  geom_line(linewidth = 1) + # 替換 size 為 linewidth
  geom_point(size = 3) +
  labs(
    title = "2020-2023年新界東與新界西交通意外宗數",
    x = "年份",
    y = "交通意外宗數",
    color = "區域分類"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  )