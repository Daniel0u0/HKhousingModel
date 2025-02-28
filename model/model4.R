# 加載所需數據
traffic_severity <- read.csv("traffic_severity.csv")
crime_rate_data <- read.csv("crime_rate_data.csv")

# 合併交通數據和犯罪數據
traffic_crime_data <- merge(traffic_severity, crime_rate_data, by.x = "Region", by.y = "district")

# 構建線性回歸模型
traffic_model <- lm(Total ~ crime_rate + population, data = traffic_crime_data)

# 檢查模型摘要
summary(traffic_model)

# 殘差診斷
par(mfrow = c(2, 2))
plot(traffic_model)

# 檢查殘差是否符合正態分佈
library(ggplot2)
ggplot(data = data.frame(residuals = residuals(traffic_model)), aes(x = residuals)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "blue", alpha = 0.5) +
  geom_density(color = "red") +
  labs(title = "Residual Distribution", x = "Residuals", y = "Density")

# 如果殘差有異常，可以嘗試加入新變數
# 嘗試加入 band1_ratio 或 band2_ratio
school_summary <- read.csv("school_summary.csv")  # 假設學校數據預處理後保存為 CSV
traffic_crime_data <- merge(traffic_crime_data, school_summary, by.x = "Region", by.y = "地區")

traffic_model_improved <- lm(Total ~ crime_rate + population + band1_ratio + band2_ratio, data = traffic_crime_data)
summary(traffic_model_improved)