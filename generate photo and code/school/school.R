# 安裝必要的套件
if (!require("rvest")) install.packages("rvest")
if (!require("dplyr")) install.packages("dplyr")
if (!require("stringr")) install.packages("stringr")  # 用於清理文字

# 加載套件
library(rvest)
library(dplyr)
library(stringr)

# 網頁 URL
url <- "https://www.edb.gov.hk/en/student-parents/sch-info/sch-search/schlist-by-district/school-list-yl.html"

# 下載網頁內容
webpage <- read_html(url)

# 提取包含學校名稱和地址的 <td> 標籤，並進一步提取其內部表格
school_info_nodes <- webpage %>%
  html_nodes("td.bodytxt") %>%
  html_nodes("table")

# 初始化空數據框存儲結果
school_data <- data.frame(School_Name = character(0), Address = character(0), stringsAsFactors = FALSE)

# 遍歷每個學校的表格，提取學校名稱和地址
for (node in school_info_nodes) {
  # 提取學校名稱（第一個 <td>）
  school_name <- node %>%
    html_nodes("tr:nth-child(1) td.bodytxt") %>%  # 第一個 <tr> 的 <td>
    html_text(trim = TRUE)
  
  # 提取地址（第二個 <td>）
  address <- node %>%
    html_nodes("tr:nth-child(2) td.bodytxt") %>%  # 第二個 <tr> 的 <td>
    html_text(trim = TRUE)
  
  # 如果有多餘的空格或特殊字符，進一步清理
  school_name <- str_trim(school_name)
  address <- str_trim(address)
  
  # 將提取的數據加入數據框
  if (length(school_name) > 0 && length(address) > 0) {
    school_data <- rbind(school_data, data.frame(School_Name = school_name, Address = address, stringsAsFactors = FALSE))
  }
}

# 查看提取的數據
print(school_data)

# 保存結果到 CSV 文件
write.csv(school_data, "school_list_get.csv", row.names = FALSE, fileEncoding = "UTF-8")

cat("學校名稱和地址已提取並保存為 'school_list_get.csv'")


# 使用 R 基礎函數讀取數據
file_path <- "school_list_get.csv"  # 替換為您的文件名
data <- read.csv(file_path, stringsAsFactors = FALSE)  # stringsAsFactors 防止將文字轉換為因子

# 查看數據結構
print(head(data))

# 移除空行
# 檢查每一行是否完全為空（全是 NA 或空字串）
data <- data[!apply(data, 1, function(row) all(is.na(row) | row == "")), ]

# 移除包含 "*" 的行
# 檢查每行是否有 "*"，如果有就刪除
data <- data[!apply(data, 1, function(row) any(grepl("\\*", row))), ]


# 移除空行：检查任一列是否为空或包含空字符串
data <- data[!apply(data, 1, function(row) any(is.na(row) | row == "")), ]

# 從第 3 行開始，每 3 行保留 1 行
#data <- data[seq(1, nrow(data), by = 3), ]
# 定义需要移除的关键字列表
keywords_to_remove <- c("Tel. 電話", "Fax 傳真", "Supervisor 校監", "Head of School 校長")

# 移除包含上述关键字的行
data <- data[!apply(data, 1, function(row) any(sapply(keywords_to_remove, function(keyword) grepl(keyword, row)))), ]


# 移除 Column1 中重复的行，仅保留第一行
data <- data %>% distinct(School_Name, .keep_all = TRUE)

# 查看處理後的數據
print(data)

# 保存結果到新的 CSV 文件
write.csv(data, "clean_data.csv", row.names = FALSE, fileEncoding = "UTF-8")

cat("移除空行和包含 '*' 的行後的數據已保存為 'clean_data.csv'")
