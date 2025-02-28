library(dplyr)
#case1
#input
data1 <- read.csv("house_price.csv")
data2 <- read.csv("crime_data.csv")

# 提取 data2 的第 3 列
data2_col <- data2[, 3]

# 找到最小行數
min_rows <- min(nrow(data1), nrow(data2))

# 裁剪數據
data1_trimmed <- data1[1:min_rows, , drop = FALSE]
data2_trimmed <- data2[1:min_rows, 3, drop = FALSE]  # 假設比較 data2 的第 1 列

# 計算相關性
correlation <- cor(data1_trimmed[, 1], data2_trimmed, use = "complete.obs")
print(paste("Correlation:", correlation))

#case2

# 載入套件
library(dplyr)
library(ggplot2)

# 讀取兩個 CSV 文件
schools_west <- read.csv("school_west.csv", stringsAsFactors = FALSE)
schools_east <- read.csv("school_east.csv", stringsAsFactors = FALSE)

# 添加東、西標籤
schools_west <- schools_west %>% mutate(Region = "西區")
schools_east <- schools_east %>% mutate(Region = "東區")

# 合併東、西區數據
schools <- bind_rows(schools_west, schools_east)

#input
data1 <- read.csv("house_price.csv")
data2 <- schools

# 提取 data2 的第 6 列
data2_col <- data2[, 6]

# 找到最小行數
min_rows <- min(nrow(data1), nrow(data2))

# 裁剪數據
data1_trimmed <- data1[1:min_rows, , drop = FALSE]
data2_trimmed <- data2[1:min_rows, 6, drop = FALSE]  # 假設比較 data2 的第 1 列

# 定義函數：刪除非數字字符
remove_non_numeric <- function(x) {
  x <- as.character(x)  # 確保是字符型
  x <- gsub("[^0-9.-]", "", x)  # 刪除非數字字符
  as.numeric(x)  # 轉換回數字型
}


# 清理所有列
data2_cleaned <- data2_trimmed %>%
  mutate_all(~ remove_non_numeric(.))

# 查看清理後的數據
head(data2_cleaned)

# 計算相關性
correlation <- cor(data1_trimmed[, 1], data2_cleaned, use = "complete.obs")
print(paste("Correlation:", correlation))