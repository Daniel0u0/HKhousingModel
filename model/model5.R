# 加載數據
culture_data <- read.csv("culture.csv")

# 將數據轉換為時間序列格式
library(tidyr)
culture_long <- culture_data %>%
  pivot_longer(cols = starts_with("year"), names_to = "year", values_to = "usage") %>%
  mutate(year = as.numeric(sub("year_", "", year)))

# 選擇一個地區進行分析（例如：沙田大會堂）
shatin_data <- culture_long %>% filter(地點 == "沙田大會堂")

# 構建時間序列模型
library(forecast)
shatin_ts <- ts(shatin_data$usage, start = min(shatin_data$year), end = max(shatin_data$year), frequency = 1)
shatin_model <- auto.arima(shatin_ts)

# 查看模型摘要
summary(shatin_model)

# 預測未來 5 年使用量
forecast(shatin_model, h = 5)