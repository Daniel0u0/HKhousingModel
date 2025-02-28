# 安裝必要的套件（如果尚未安裝）
if (!require("httr")) install.packages("httr")
if (!require("jsonlite")) install.packages("jsonlite")
if (!require("dplyr")) install.packages("dplyr")
if (!require("stringr")) install.packages("stringr")

# 加載套件
library(httr)
library(jsonlite)
library(dplyr)
library(stringr)

# 定義 API URL 和請求頭
base_url <- "https://hk.centanet.com/findproperty/api/Transaction/Search"

headers <- c(
  "Authorization" = "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IkY3MkYxRDVFMThEMjRDMDc4QzUyREVFMEEzRTZEQjI3NzE2RDE0Q0RSUzI1NiIsInR5cCI6ImF0K2p3dCIsIng1dCI6Ijl5OGRYaGpTVEFlTVV0N2dvLWJiSjNGdEZNMCJ9.eyJuYmYiOjE3MzUzNTU1NDgsImV4cCI6MTc0MzEzMTU0OCwiaXNzIjoiaHR0cHM6Ly9tcy5jZW50YW5ldC5jb20vbWVtYmVyIiwiYXVkIjpbImNlbnRhbmV0YXBpIiwiaHR0cHM6Ly9tcy5jZW50YW5ldC5jb20vbWVtYmVyL3Jlc291cmNlcyJdLCJjbGllbnRfaWQiOiJudXh0X2N1c3RvbV9vaWRjIiwic3ViIjoiY2UyZWYzMjctMGQ1YS00YjgyLWEwZTktNmQwNTcwNTM4MTk1IiwiYXV0aF90aW1lIjoxNzM1MzU1NTQ4LCJpZHAiOiJsb2NhbCIsImxvZ2luX3R5cGUiOiJBbm9ueW1vdXMiLCJqdGkiOiJBNThEQUQ1NDY3OTkzQzkxNDUwNEFENjA1N0RDQTk2NiIsImlhdCI6MTczNTM1NTU0OCwic2NvcGUiOlsiY2VudGFuZXRhcGkiXX0.YZtqdMMShxK3uCMAv_OpQqm_tw5_5BLjBVhJuvLCaUsH6ZdCj_Rp2qdb86G85CltMTU11mhmqQd-LusvnC2vDaf5YB3ZfGVENR7SA6imQQ9aOgoUoQIOXsXWcgbi5jFB4-rkn-cb7hF7JF1qLkRMpoT3ruk3b5vTRaLAXWdKOoMnUYM5wjPBqxC8hYF4d-cLFOM_Fl5tVKIjwegMFwWsSmOwXHtd71mDj9VuNR3RcpYA8rqHzNKriZ8fhmJIO3kqb43DYaz6NQ0yBRPRZSrwsyLJHb-LNmxkVlEWLMOGJcA3WBhyJxMRzCsGnH8q7tw4kS7OhE6A-0SGRGUs2Yb7Lw",
  "Content-Type" = "application/json"
)

# 定義 payload 請求參數
payload <- list(
  postType = "Sale",
  day = "Day1095",
  sort = "InsOrRegDate",
  order = "Descending",
  size = 24,  # 每頁返回的記錄數量
  offset = 0, # 起始位置
  pageSource = "search",
  currency = "HKD",
  areaUnit = "Feet"
)

# 定義 fetch_data 函數
fetch_data <- function(offset) {
  payload$offset <- offset
  response <- POST(
    url = base_url,
    body = toJSON(payload, auto_unbox = TRUE),
    add_headers(.headers = headers),
    encode = "json"
  )
  
  if (status_code(response) != 200) {
    print("API 返回錯誤信息：")
    print(content(response, as = "text", encoding = "UTF-8"))
    stop(paste("API 請求失敗，狀態碼：", status_code(response)))
  }
  
  response_data <- content(response, as = "parsed", encoding = "UTF-8")
  return(response_data)
}

# 獲取第一頁數據以確認總記錄數量
initial_data <- fetch_data(0)
total_records <- initial_data$count
print(paste("總記錄數量:", total_records))

# 初始化空列表以存放數據
all_data <- list()

# 獲取總頁數
total_pages <- ceiling(total_records / payload$size)

# 循環處理所有頁面
for (page in 0:(total_pages - 1)) {
  offset <- page * payload$size
  print(paste("正在處理第", page + 1, "頁數據，offset=", offset, "..."))
  
  # 嘗試獲取當前頁數據
  tryCatch({
    page_data <- fetch_data(offset)
    if (!is.null(page_data$data)) {
      all_data[[length(all_data) + 1]] <- page_data$data
    }
  }, error = function(e) {
    print(paste("第", page + 1, "頁數據請求失敗，跳過該頁！"))
    print(e) # 打印錯誤信息
  })
  
  # 等待 1 秒
  #Sys.sleep(1)
}

# 合併所有數據
combined_data <- bind_rows(lapply(all_data, function(x) {
  data.frame(
    日期 = sapply(x, function(item) substr(item$insDate, 1, 10)),
    地址 = sapply(x, function(item) item$displayText$addr$line1),
    成交價 = sapply(x, function(item) ifelse(!is.null(item$transactionPrice), item$transactionPrice / 10000, NA)), # 單位轉換為萬
    面積_實 = sapply(x, function(item) ifelse(!is.null(item$nArea), item$nArea, NA)),
    每呎價_實 = sapply(x, function(item) ifelse(!is.null(item$nUnitPrice), item$nUnitPrice, NA)),
    資料來源 = sapply(x, function(item) ifelse(!is.null(item$dataSource), item$dataSource, NA)),
    stringsAsFactors = FALSE
  )
}))

# 保存為 CSV 文件
write.csv(combined_data, "house.csv", row.names = FALSE, fileEncoding = "UTF-8")
print("數據已保存為house.csv")