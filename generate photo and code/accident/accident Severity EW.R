# 安裝 ggplot2 套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")

# 載入必要的套件
library(ggplot2)
library(dplyr)
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
severity_data <- severity_data %>%
  mutate(
    Subregion = case_when(
      Region %in% c("葵青", "荃灣", "屯門", "元朗") ~ "新界西",
      Region %in% c("北區", "大埔", "沙田", "西貢", "離島") ~ "新界東",
      TRUE ~ "其他"
    )
  )

# 匯總新界東和新界西的數據
severity_grouped <- severity_data %>%
  group_by(Subregion) %>%
  summarise(
    Fatal = sum(Fatal),
    Serious = sum(Serious),
    Minor = sum(Minor)
  ) %>%
  pivot_longer(
    cols = c(Fatal, Serious, Minor), # 轉為長格式，只保留三類事故
    names_to = "Severity",
    values_to = "Count"
  )

# 繪製條形圖：新界東和新界西各3條柱狀圖
ggplot(severity_grouped, aes(x = Subregion, y = Count, fill = Severity)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "新界東與新界西的交通意外嚴重程度",
    x = "區域",
    y = "交通意外宗數",
    fill = "嚴重程度"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  )