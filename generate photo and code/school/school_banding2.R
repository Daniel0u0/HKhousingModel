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

# 計算東、西區的總 Band 1 學校數量
region_band1_summary <- schools %>%
  filter(收生 == "BAND 1") %>% # 只篩選 Band 1 的學校
  group_by(Region) %>%         # 按東/西區分組
  summarise(TotalBand1 = n())  # 計算每個區域的 Band 1 總數量

# 查看結果
print(region_band1_summary)

# 繪製東、西區總 Band 1 學校數量的比較圖
ggplot(region_band1_summary, aes(x = Region, y = TotalBand1, fill = Region)) +
  geom_bar(stat = "identity") +
  labs(
    title = "東區與西區總 Band 1 學校數量比較",
    x = "區域",
    y = "總 Band 1 學校數量",
    fill = "區域"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.text.x = element_text(size = 12),
    axis.title = element_text(size = 14),
    legend.position = "none"  # 隱藏圖例（因只有兩個區域）
  )