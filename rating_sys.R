# 加載必要的庫
library(dplyr)

# 1. 加載數據
housing_data <- read.csv("housing_data.csv", stringsAsFactors = FALSE)
school_summary <- read.csv("school_summary.csv", stringsAsFactors = FALSE)
crime_rate_data <- read.csv("crime_rate_data.csv", stringsAsFactors = FALSE)

# 定義商場數據文件列表與地區對應關係
mall_data_files <- list(
  "mall_tw.csv" = "荃灣",
  "mall_tp.csv" = "大埔",
  "mall_tm.csv" = "屯門",
  "mall_st.csv" = "沙田",
  "mall_sk.csv" = "西貢",
  "mall_kc.csv" = "葵青",
  "mall_island.csv" = "離島",
  "mall_yl.csv" = "元朗"
)

# 加載商場數據並添加 region 列
mall_data <- lapply(names(mall_data_files), function(file) {
  read.csv(file, stringsAsFactors = FALSE) %>%
    mutate(region = mall_data_files[[file]])
}) %>%
  bind_rows()

# 計算每個地區的商場數量
mall_summary <- mall_data %>%
  group_by(region) %>%
  summarise(mall_count = n(), .groups = "drop")

# 2. 整合數據
# 統一學校數據的地區名稱
school_summary <- school_summary %>%
  mutate(地區 = case_when(
    地區 == "元朗區" ~ "元朗",
    地區 == "北區" ~ "北區",
    地區 == "大埔區" ~ "大埔",
    地區 == "屯門區" ~ "屯門",
    地區 == "沙田區" ~ "沙田",
    地區 == "荃灣區" ~ "荃灣",
    地區 == "葵青區" ~ "葵青",
    地區 == "西貢區" ~ "西貢",
    地區 == "離島區" ~ "離島",
    TRUE ~ 地區
  ))

# 統一 housing_data 的地區名稱
housing_data <- housing_data %>%
  rename(region = subregion.name)

# 整合所有數據
final_data <- housing_data %>%
  left_join(school_summary, by = c("region" = "地區")) %>%
  left_join(crime_rate_data, by = c("region" = "district")) %>%
  left_join(mall_summary, by = "region") %>%
  mutate(mall_count = replace_na(mall_count, 0))  # 填充缺失商場數據

# 3. 計算標準化分數與綜合評分

# 標準化函數
normalize <- function(x, reverse = FALSE) {
  if (all(is.na(x))) return(rep(0, length(x)))  # 如果全是 NA，返回 0
  x <- replace_na(x, 0)  # 替換 NA 為 0
  if (reverse) {
    return((max(x, na.rm = TRUE) - x) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)) * 100)
  }
  return((x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)) * 100)
}

# 計算各指標的分數
final_data <- final_data %>%
  mutate(
    housing_score = (
      normalize(as.numeric(gsub("[^0-9.]", "", `price.mean`)), reverse = TRUE) * 0.4 +
        normalize(`net_area.mean`) * 0.4 +
        normalize(`mtr_walking_time_seconds.mean`, reverse = TRUE) * 0.2
    ),
    school_score = normalize(band1_ratio) * 0.7 + normalize(band2_ratio) * 0.3,
    crime_score = normalize(crime_rate, reverse = TRUE),
    mall_score = normalize(mall_count)
  ) %>%
  mutate(
    total_score = housing_score * 0.4 +
      school_score * 0.3 +
      crime_score * 0.2 +
      mall_score * 0.1
  )

# 4. 輸出結果
final_data <- final_data %>%
  select(region, housing_score, school_score, crime_score, mall_score, total_score) %>%
  arrange(desc(total_score))

print(final_data)