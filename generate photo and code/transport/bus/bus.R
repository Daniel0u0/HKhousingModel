# 安裝必要的套件
if (!require("rvest")) install.packages("rvest")
if (!require("dplyr")) install.packages("dplyr")

# 載入套件
library(rvest)
library(dplyr)

# 指定目標 URL
url <- "https://hkbus.fandom.com/wiki/新界專營巴士路線列表/三位數/新界東"

# 讀取網頁內容
webpage <- read_html(url)

# 找到所有的 <tr> 標籤（表格的每一行數據）
rows <- webpage %>%
  html_nodes("table[border='1'] tr") # 選擇表格中的所有 <tr>

# 提取數據
data <- rows %>%
  html_nodes("td") %>% # 找到每一行中的 <td>
  html_text(trim = TRUE) # 提取文字，並去掉多餘的空格

# 將數據轉換為數據框
# 表格中每行有 3 個欄位：路線號、起訖點、全程收費
table <- matrix(data, ncol = 3, byrow = TRUE) %>%
  as.data.frame()

# 設定列名稱
colnames(table) <- c("路線號", "起訖點", "全程收費")

# 移除表頭的多餘行（如果提取到表頭，需手動確認數據）
table <- table %>%
  filter(路線號 != "路線號") # 過濾掉表頭

# 查看表格內容
print(table)

# 將表格保存為 CSV 文件
write.csv(table, "bus_routes_new_territories_west.csv", row.names = FALSE)