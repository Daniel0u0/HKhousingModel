# 安裝 ggplot2 套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")

# 載入必要的套件
library(ggplot2)
library(tidyr)

# 創建數據框
severity_data <- data.frame(
  Region = c("葵青", "荃灣", "屯門", "元朗", "北區", "大埔", "沙田", "西貢", "離島"),
  Fatal = c(12, 3, 3, 14, 4, 5, 5, 5, 3),
  Serious = c(89, 92, 28, 41, 29, 34, 114, 65, 48),
  Minor = c(929, 903, 813, 1483, 652, 841, 1367, 662, 478),
  Total = c(1030, 998, 844, 1538, 685, 880, 1486, 732, 529)
)

# 添加地區分類（新界東和新界西）
severity_data$Subregion <- c(
  "新界西", "新界西", "新界西", "新界西", # 新界西: 葵青, 荃灣, 屯門, 元朗
  "新界東", "新界東", "新界東", "新界東", "新界東"  # 新界東: 北區, 大埔, 沙田, 西貢, 離島
)

# 只篩選新界東和新界西的數據
filtered_data <- severity_data

# 將數據轉換為長格式以便於可視化
severity_long <- tidyr::pivot_longer(
  filtered_data, 
  cols = c(Fatal, Serious, Minor, Total), 
  names_to = "Severity", 
  values_to = "Count"
)

# 繪製條形圖：按交通意外嚴重程度排序
ggplot(severity_long, aes(x = reorder(Region, -Count), y = Count, fill = Severity)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "新界東與新界西的交通意外嚴重程度排行",
    x = "區域",
    y = "交通意外宗數",
    fill = "嚴重程度"
  ) +
  facet_wrap(~ Subregion, scales = "free_x") + # 按地區分面板顯示
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  )