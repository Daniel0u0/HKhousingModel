# 安裝所需的套件（如果尚未安裝）
if (!require(dplyr)) install.packages("dplyr")
if (!require(ggplot2)) install.packages("ggplot2")

# 載入套件
library(dplyr)
library(ggplot2)

# 設置工作目錄（如果需要）
# setwd("/Users/YourUsername/Desktop") # 修改為您的文件所在目錄

# 讀取兩個 CSV 文件
schools_west <- read.csv("school_west.csv", stringsAsFactors = FALSE)
schools_east <- read.csv("school_east.csv", stringsAsFactors = FALSE)

# 添加東、西標籤
schools_west <- schools_west %>% mutate(Region = "西區")
schools_east <- schools_east %>% mutate(Region = "東區")

# 合併東、西區數據
schools <- bind_rows(schools_west, schools_east)


# 確保 "收生" 欄位是字符型（避免出現因數類型數據問題）
schools$收生 <- as.character(schools$收生)

# 統計每個分區的 Band 1 學校數量，並按東/西區分組
district_band1_count <- schools %>%
  filter(收生 == "BAND 1") %>% # 只篩選 Band 1 的學校
  group_by(Region, 地區) %>%    # 按區域（東/西）和分區分組
  summarise(Band1Count = n()) %>% # 計算每個分區的 Band 1 學校數量
  mutate(Score = case_when(
    Band1Count >= 10 ~ "A", # 10 所以上 Band 1 評為 A
    Band1Count >= 5  ~ "B", # 5-9 所 Band 1 評為 B
    Band1Count >= 1  ~ "C", # 1-4 所 Band 1 評為 C
    TRUE             ~ "D"  # 沒有 Band 1 學校評為 D
  )) %>%
  arrange(Region, desc(Band1Count)) # 按區域和 Band 1 數量排序

# 查看結果
print(district_band1_count)

# 繪製東、西區 Band 1 學校數量的棒形圖
ggplot(district_band1_count, aes(x = reorder(地區, -Band1Count), y = Band1Count, fill = Score)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Region, scales = "free_x") + # 按東/西區分面顯示
  labs(
    title = "東區與西區 Band 1 學校數量及評分比較",
    x = "分區",
    y = "Band 1 學校數量",
    fill = "評分"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )