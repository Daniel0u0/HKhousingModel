# 加載必要的套件
library(dplyr)

# 定義所有 CSV 文件的路徑
csv_files <- c("mall_island.csv", "mall_kc.csv", "mall_sk.csv", 
               "mall_st.csv", "mall_tm.csv", "mall_tp.csv", 
               "mall_tw.csv", "mall_yl.csv")

# 初始化結果列表
file_row_counts <- list()

# 遍歷所有文件，計算每個文件的行數
for (file in csv_files) {
  # 讀取 CSV 文件，但不讀取第一行
  data <- read.csv(file, skip = 1)
  
  # 計算行數
  file_row_counts[[file]] <- nrow(data)
}

# 查看每個文件的行數
print("每個文件的行數（不包括第一行）：")
print(file_row_counts)