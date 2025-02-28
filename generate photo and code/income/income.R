# 加載必要的庫
library(dplyr)
library(ggplot2)

# 定義數據框，包含每個區域的收入中位數
data <- data.frame(
  區域 = c("中西區", "灣仔區", "西貢區", "南區", "東區", "沙田區", "大埔區", 
         "觀塘區", "油尖旺區", "黃大仙區", "深水埗區", "元朗區", "荃灣區", 
         "屯門區", "葵青區", "北區", "離島區"),
  收入中位數 = c(42600, 40500, 40400, 36000, 34400, 33800, 31700,
            31500, 30700, 30500, 30500, 30500, 30000,
            26500, 26000, 25500, 25000)
)

# 定義新界東和新界西的區域
new_territories_east <- c("沙田區", "西貢區", "大埔區", "北區")
new_territories_west <- c("屯門區", "元朗區", "荃灣區", "葵青區", "離島區")

# 添加一列，標註每個區域是否屬於新界東或新界西
data <- data %>%
  mutate(
    地區 = case_when(
      區域 %in% new_territories_east ~ "新界東",
      區域 %in% new_territories_west ~ "新界西",
      TRUE ~ "其他"
    )
  )

# 計算新界東和新界西的收入中位數統計
result <- data %>%
  filter(地區 %in% c("新界東", "新界西")) %>%
  group_by(地區) %>%
  summarise(
    平均收入中位數 = mean(收入中位數),
    總收入中位數 = sum(收入中位數)
  )

# 繪製棒形圖
ggplot(result, aes(x = 地區, y = 平均收入中位數, fill = 地區)) +
  geom_bar(stat = "identity", width = 0.5) +
  labs(title = "新界東與新界西收入中位數比較",
       x = "地區",
       y = "平均收入中位數 (港元)") +
  theme_minimal() +
  scale_fill_manual(values = c("新界東" = "steelblue", "新界西" = "darkorange")) +
  theme(axis.text.x = element_text(size = 12),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, hjust = 0.5))