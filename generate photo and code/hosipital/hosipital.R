# 安裝所需的套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")

# 加載 ggplot2 套件
library(ggplot2)

# **私人診所數據**
private_clinics <- data.frame(
  Region = c("新界西", "新界東"),
  Count = c(770, 616)
)

# 繪製私人診所數據柱狀圖
private_clinics_plot <- ggplot(private_clinics, aes(x = Region, y = Count, fill = Region)) +
  geom_bar(stat = "identity", width = 0.6) +
  labs(
    title = "私人診所數據",
    x = "地區",
    y = "診所數量",
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
  scale_fill_manual(values = c("新界西" = "#4CAF50", "新界東" = "#2196F3"))

# 顯示私人診所數據圖
print(private_clinics_plot)

# **醫院聯網數據**
hospital_network <- data.frame(
  Region = c("新界西", "新界東"),
  Count = c(8, 9)
)

# 繪製醫院聯網數據柱狀圖
hospital_network_plot <- ggplot(hospital_network, aes(x = Region, y = Count, fill = Region)) +
  geom_bar(stat = "identity", width = 0.6) +
  labs(
    title = "醫院聯網數據",
    x = "地區",
    y = "醫院數量",
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
  scale_fill_manual(values = c("新界西" = "#4CAF50", "新界東" = "#2196F3"))

# 顯示醫院聯網數據圖
print(hospital_network_plot)