data <- read.csv("house.csv", stringsAsFactors = FALSE)

# 提取第 3 列
third_column <- data[[3]]

# 查看第 3 列數據
print(third_column)

# 如果需要保存第 3 列為新的 CSV 文件
write.csv(data.frame(House_Price = third_column), "house_price.csv", row.names = FALSE)

