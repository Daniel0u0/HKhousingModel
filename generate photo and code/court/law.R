# 安裝所需的套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")

# 加載 ggplot2 套件
library(ggplot2)

# 數據輸入
court_data <- data.frame(
  Region = c("新界東", "新界東", "新界西"),
  Court = c("粉嶺", "沙田", "屯門")
)

# 繪製法院分佈圖
court_plot <- ggplot(court_data, aes(x = Region, fill = Court)) +
  geom_bar(stat = "count", width = 0.6) +
  labs(
    title = "新界東與新界西法院分佈",
    x = "地區",
    y = "法院數量",
    fill = "法院名稱"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 12)
  ) +
  scale_fill_manual(values = c("粉嶺" = "#2196F3", "沙田" = "#4CAF50", "屯門" = "#FFC107"))

# 顯示法院分佈圖
print(court_plot)