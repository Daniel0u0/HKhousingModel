# 加載必要的庫
library(dplyr)
library(ggplot2)

# 定義圖書館數據
data <- data.frame(
  區域 = c("葵青區", "荃灣區", "屯門區", "元朗區", "北區", "大埔區", "沙田區", "西貢區", "離島區"),
  圖書館數目 = c(3, 2, 3, 3, 4, 1, 4, 3, 7)
)

# 定義新界東和新界西的區域
new_territories_east <- c("北區", "大埔區", "沙田區", "西貢區")
new_territories_west <- c("葵青區", "荃灣區", "屯門區", "元朗區", "離島區")

# 添加一列，標註每個區域是否屬於新界東或新界西
data <- data %>%
  mutate(
    地區 = case_when(
      區域 %in% new_territories_east ~ "新界東",
      區域 %in% new_territories_west ~ "新界西",
      TRUE ~ "其他"
    )
  )

# 計算新界東和新界西的圖書館數量
result <- data %>%
  group_by(地區) %>%
  summarise(
    總圖書館數目 = sum(圖書館數目)
  )

# 繪製柱狀圖
ggplot(result, aes(x = 地區, y = 總圖書館數目, fill = 地區)) +
  geom_bar(stat = "identity", width = 0.5) +
  labs(title = "新界東與新界西的圖書館數量比較",
       x = "地區",
       y = "圖書館數目") +
  theme_minimal() +
  scale_fill_manual(values = c("新界東" = "steelblue", "新界西" = "darkorange")) +
  theme(axis.text.x = element_text(size = 12),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, hjust = 0.5))