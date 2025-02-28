# 安裝所需的套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")

# 加載 ggplot2 套件
library(ggplot2)

# 數據輸入
fire_station_data <- data.frame(
  Region = c("新界東", "新界西"),
  Count = c(10, 31)
)

# 繪製柱狀圖
fire_station_plot <- ggplot(fire_station_data, aes(x = Region, y = Count, fill = Region)) +
  geom_bar(stat = "identity", width = 0.6) +
  labs(
    title = "新界東與新界西消防局數據",
    x = "地區",
    y = "消防局數量",
    fill = "地區"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.position = "none"
  ) +
  scale_fill_manual(values = c("新界東" = "#2196F3", "新界西" = "#4CAF50"))

# 顯示柱狀圖
print(fire_station_plot)