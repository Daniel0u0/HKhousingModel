# 加載必要的套件
library(ggplot2)

# 原始數據
mall_data <- data.frame(
  Region = c("離島", "葵涌", "西貢", "沙田", "屯門", "大埔", "荃灣", "元朗"),
  Malls = c(19, 40, 60, 60, 48, 59, 48, 53)
)

# 將地區分組為新界東和新界西
mall_data$Group <- ifelse(
  mall_data$Region %in% c("西貢", "沙田", "大埔"), "新界東", "新界西"
)

# 按分組計算商場總數
grouped_data <- mall_data %>%
  group_by(Group) %>%
  summarise(Total_Malls = sum(Malls))

# 查看分組結果
print(grouped_data)

# 繪製柱狀圖
ggplot(grouped_data, aes(x = Group, y = Total_Malls, fill = Group)) +
  geom_bar(stat = "identity", width = 0.6) +
  labs(
    title = "新界東與新界西的商場數量",
    x = "地區分組",
    y = "商場總數"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("新界東" = "#1f78b4", "新界西" = "#33a02c"))