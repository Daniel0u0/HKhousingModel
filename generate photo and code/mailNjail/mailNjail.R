# 安裝所需的套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")

# 加載 ggplot2 套件
library(ggplot2)

# **懲教設施數據**
correctional_facilities_data <- data.frame(
  Region = c("新界東", "新界西"),
  Count = c(3, 15)
)

# 繪製懲教設施數據柱狀圖
correctional_facilities_plot <- ggplot(correctional_facilities_data, aes(x = Region, y = Count, fill = Region)) +
  geom_bar(stat = "identity", width = 0.6) +
  labs(
    title = "新界東與新界西懲教設施數量",
    x = "地區",
    y = "懲教設施數量",
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

# 顯示懲教設施柱狀圖
print(correctional_facilities_plot)

# **郵政局數據**
post_offices_data <- data.frame(
  Region = c("新界東", "新界西"),
  Count = c(25, 31)
)

# 繪製郵政局數據柱狀圖
post_offices_plot <- ggplot(post_offices_data, aes(x = Region, y = Count, fill = Region)) +
  geom_bar(stat = "identity", width = 0.6) +
  labs(
    title = "新界東與新界西郵政局數量",
    x = "地區",
    y = "郵政局數量",
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
  scale_fill_manual(values = c("新界東" = "#FF9800", "新界西" = "#8BC34A"))

# 顯示郵政局柱狀圖
print(post_offices_plot)