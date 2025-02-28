# 安裝必要的套件
if (!require("rvest")) install.packages("rvest")
if (!require("dplyr")) install.packages("dplyr")  # 用於數據操作

# 加載套件
library(rvest)
library(dplyr)

# 網站 URL
url <- "https://www.td.gov.hk/mini_site/atd/2023/tc/section7-5.html"

# 下載網頁內容
webpage <- read_html(url)

# 提取表格數據
table_data <- webpage %>%
  html_node("table") %>%  # 定位到網頁中的第一個表格
  html_table(fill = TRUE)  # 自動提取表格內容為數據框

# 查看提取的數據
print("提取的數據：")
print(table_data)

# 保存數據到 CSV 文件
write.csv(table_data, "traffic_accidents_by_district_2013_2022.csv", row.names = FALSE, fileEncoding = "UTF-8")

cat("表格數據已提取並保存為 'traffic_accidents_by_district_2013_2022.csv'")