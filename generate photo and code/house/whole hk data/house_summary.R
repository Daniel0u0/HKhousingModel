# 安裝並載入必要的套件（如果尚未安裝）
if (!require(dplyr)) install.packages("dplyr")
library(dplyr)

# 讀取 house.csv 文件
# 確保文件路徑正確
house_data <- read.csv("house.csv", stringsAsFactors = FALSE)

# 確認數據格式
str(house_data)

# 將成交價、面積_實、每呎價_實轉換為數值類型（如果是字符型數據，去掉逗號後轉換為數值）
house_data$成交價 <- as.numeric(gsub(",", "", house_data$成交價))
house_data$面積_實 <- as.numeric(gsub(",", "", house_data$面積_實))
house_data$每呎價_實 <- as.numeric(gsub(",", "", house_data$每呎價_實))

# 計算統計信息
summary_stats <- house_data %>%
  summarise(
    成交價_平均值 = mean(成交價, na.rm = TRUE),
    成交價_中位數 = median(成交價, na.rm = TRUE),
    成交價_Q1 = quantile(成交價, 0.25, na.rm = TRUE),
    成交價_Q3 = quantile(成交價, 0.75, na.rm = TRUE),
    面積_平均值 = mean(面積_實, na.rm = TRUE),
    面積_中位數 = median(面積_實, na.rm = TRUE),
    面積_Q1 = quantile(面積_實, 0.25, na.rm = TRUE),
    面積_Q3 = quantile(面積_實, 0.75, na.rm = TRUE),
    每呎價_平均值 = mean(每呎價_實, na.rm = TRUE),
    每呎價_中位數 = median(每呎價_實, na.rm = TRUE),
    每呎價_Q1 = quantile(每呎價_實, 0.25, na.rm = TRUE),
    每呎價_Q3 = quantile(每呎價_實, 0.75, na.rm = TRUE)
  )

# 將統計信息轉換為數據框（方便保存為 CSV）
summary_stats_df <- as.data.frame(t(summary_stats)) # 轉置數據框
colnames(summary_stats_df) <- c("統計值") # 添加列名
summary_stats_df$指標 <- rownames(summary_stats_df) # 添加一列指標名稱
rownames(summary_stats_df) <- NULL # 刪除行名

# 保存統計信息到新 CSV 文件
write.csv(summary_stats_df, "summary_stats.csv", row.names = FALSE)

# 輸出結果到控制台
print(summary_stats_df)