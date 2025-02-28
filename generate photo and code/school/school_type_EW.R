# 安裝所需的套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")

# 載入套件
library(ggplot2)
library(dplyr)
library(tidyr)

# 創建數據框
school_data <- data.frame(
  Region = c("north", "KwaiTsing", "YuenLong", "TuenMun", "TsuenWan", "TaiPo", "SK", "ShaTin"),
  Kindergarten = c(44, 66, 100, 130, 70, 55, 120, 160),
  Primary = c(22, 24, 35, 55, 25, 30, 60, 80),
  Secondary = c(25, 44, 50, 90, 65, 40, 80, 120),
  Other = c(3, 10, 20, 31, 26, 12, 22, 51)
)

# 添加區域分類（新界東和新界西）
school_data <- school_data %>%
  mutate(
    RegionGroup = case_when(
      Region %in% c("TaiPo", "SK", "ShaTin") ~ "新界東",
      Region %in% c("north", "KwaiTsing", "YuenLong", "TuenMun", "TsuenWan") ~ "新界西",
      TRUE ~ "其他"
    )
  )

# 過濾數據，只保留新界東和新界西
school_data_filtered <- school_data %>%
  filter(RegionGroup %in% c("新界東", "新界西"))

# 將數據轉換為長格式以便於 ggplot2 繪圖
school_data_long <- pivot_longer(
  school_data_filtered,
  cols = c(Kindergarten, Primary, Secondary), # 只保留幼兒園、小學和中學
  names_to = "Category",
  values_to = "Count"
)

# 繪製分組棒形圖
ggplot(school_data_long, aes(x = RegionGroup, y = Count, fill = Category)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "新界東與新界西學校類別分布",
    x = "區域",
    y = "學校數量",
    fill = "學校類別"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.text.x = element_text(size = 12),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )