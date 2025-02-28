# 安裝所需的套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(tidyr)) install.packages("tidyr")

# 載入套件
library(ggplot2)
library(tidyr)

# 創建數據框
school_data <- data.frame(
  Region = c("ShaTin", "TaiPo", "north", "SK", "TsuenWan", "TuenMun", "YuenLong", "KwaiTsing", "Islands"),
  Subregion = c("新界東", "新界東", "新界東", "新界東", "新界西", "新界西", "新界西", "新界西", "新界西"),
  Kindergarten = c(160, 55, 44, 120, 70, 130, 100, 66, 40),
  Primary = c(80, 30, 22, 60, 25, 55, 35, 24, 15),
  Secondary = c(120, 40, 25, 80, 65, 90, 50, 44, 20),
  Other = c(51, 12, 3, 22, 26, 31, 20, 10, 5)
)

# 將數據轉換為長格式以便於 ggplot2 繪圖
school_data_long <- pivot_longer(
  school_data,
  cols = c(Kindergarten, Primary, Secondary, Other),
  names_to = "Category",
  values_to = "Count"
)

# 繪製分組棒形圖，按新界東和新界西分類
ggplot(school_data_long, aes(x = Region, y = Count, fill = Category)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "新界東與新界西學校類別分布",
    x = "地區",
    y = "數量",
    fill = "學校類別"
  ) +
  facet_wrap(~ Subregion, scales = "free_x") +  # 按新界東和新界西分面
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )