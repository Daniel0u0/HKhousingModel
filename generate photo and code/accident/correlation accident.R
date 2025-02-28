# 安裝所需套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(reshape2)) install.packages("reshape2")
if (!require(GGally)) install.packages("GGally")

# 載入套件
library(ggplot2)
library(reshape2)
library(GGally)

# 第一組數據：2020-2023 年交通意外宗數
traffic_count <- data.frame(
  District = c("大埔", "元朗", "屯門", "北區", "西貢", "沙田", "荃灣", "葵青", "離島"),
  `2020` = c(1074, 1571, 754, 690, 725, 1403, 926, 858, 322),
  `2021` = c(1211, 1859, 944, 812, 803, 1617, 962, 973, 365),
  `2022` = c(900, 1384, 687, 645, 682, 1455, 941, 896, 361),
  `2023` = c(NA, 776, 369, NA, 139, 574, 992, NA, NA)
)

# 第二組數據：交通意外區域嚴重程度
severity_data <- data.frame(
  District = c("大埔", "元朗", "屯門", "北區", "西貢", "沙田", "荃灣", "葵青", "離島"),
  Fatal = c(5, 14, 3, 4, 5, 5, 3, 12, 3),
  Serious = c(34, 41, 28, 29, 65, 114, 92, 89, 48),
  Minor = c(841, 1483, 813, 652, 662, 1367, 903, 929, 478),
  Total = c(880, 1538, 844, 685, 732, 1486, 998, 1030, 529)
)

# 合併數據
merged_data <- merge(traffic_count, severity_data, by = "District")

# 計算相關性矩陣（去掉 District 列）
correlation_matrix <- cor(merged_data[,-1], use = "complete.obs")

# 熱圖顯示相關性矩陣
heatmap_data <- melt(correlation_matrix)
ggplot(heatmap_data, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0, 
                       limit = c(-1, 1), space = "Lab", name = "相關性") +
  labs(title = "交通意外數據與嚴重程度的相關性", x = "", y = "") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.text.y = element_text(size = 10),
    plot.title = element_text(hjust = 0.5, size = 16)
  )

# 散點圖矩陣顯示數據關係
ggpairs(merged_data[,-1], 
        title = "交通意外數據與嚴重程度的散點圖矩陣")