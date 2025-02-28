# 加载必要的库
library(httr)
library(jsonlite)

# 设置 API Key
api_key <- "AIzaSyD6If8KZeVdGvAZQ6myURx7A5PR7SKC0qk"  # 替换为您的实际 Google Maps API Key

# 读取查询的 CSV 文件
queries <- read.csv("filtered_results.csv", stringsAsFactors = FALSE)  # 确保文件名正确
queries_column <- "x"  # 替换为 CSV 文件中查询列的实际列名

# 创建一个空的数据框用于存储结果
results_df <- data.frame(
  地点名称 = character(),
  楼盘名称 = character(),
  地址 = character(),
  纬度 = numeric(),
  经度 = numeric(),
  stringsAsFactors = FALSE
)

# 遍历每一行查询
for (i in 1:nrow(queries)) {
  print(i)
  # 获取当前查询关键词
  query <- queries[[queries_column]][i]
  
  # 构建 API 请求 URL，加入 region 和 location 参数限制到香港
  url <- paste0("https://maps.googleapis.com/maps/api/place/textsearch/json?",
                "query=", URLencode(query),
                "&region=hk",  # 限制搜索范围到香港
                "&location=22.3193,114.1694",  # 香港的中心坐标（纬度, 经度）
                "&radius=50000",  # 搜索半径（50公里）
                "&key=", api_key)
  
  # 发送 GET 请求
  response <- GET(url)
  
  # 检查状态码
  if (status_code(response) == 200) {
    # 将 JSON 响应解析为 R 的列表
    results <- fromJSON(content(response, "text", encoding = "UTF-8"))
    
    # 检查 API 请求是否返回结果
    if (!is.null(results$results) && length(results$results) > 0) {
      # 提取第一个结果（最相关的结果）
      first_result <- results$results[1, ]
      
      # 将结果添加到数据框
      results_df <- rbind(results_df, data.frame(
        地点名称 = query,
        楼盘名称 = first_result$name,
        地址 = first_result$formatted_address,
        纬度 = first_result$geometry$location$lat,
        经度 = first_result$geometry$location$lng,
        stringsAsFactors = FALSE
      ))
    } else {
      # 如果没有结果，记录空值，确保所有列都有值
      results_df <- rbind(results_df, data.frame(
        地点名称 = query,
        楼盘名称 = "未找到匹配结果",
        地址 = NA,
        纬度 = NA,
        经度 = NA,
        stringsAsFactors = FALSE
      ))
    }
  } else {
    # 如果 API 请求失败，记录错误信息，确保所有列都有值
    cat("API 请求失败，状态码：", status_code(response), "，查询关键词：", query, "\n")
    results_df <- rbind(results_df, data.frame(
      地点名称 = query,
      楼盘名称 = "API 请求失败",
      地址 = NA,
      纬度 = NA,
      经度 = NA,
      stringsAsFactors = FALSE
    ))
  }
}

# 保存结果到新的 CSV 文件
write.csv(results_df, "results.csv", row.names = FALSE, fileEncoding = "UTF-8")
cat("查询完成，结果已保存到 results.csv。\n")