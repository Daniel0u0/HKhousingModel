# 1. 清理數據
colnames(housing_data) <- c(
  "subregion_name", "count", "price_mean", "price_median",
  "net_area_mean", "net_area_median", "price_over_net_area_mean",
  "price_over_net_area_median", "mtr_walking_time_mean"
)

housing_data$price_mean <- as.numeric(gsub("HK\\$|,", "", housing_data$price_mean))
housing_data$price_median <- as.numeric(gsub("HK\\$|,", "", housing_data$price_median))
housing_data$price_over_net_area_mean <- as.numeric(gsub("HK\\$|,", "", housing_data$price_over_net_area_mean))
housing_data$price_over_net_area_median <- as.numeric(gsub("HK\\$|,", "", housing_data$price_over_net_area_median))

# 2. 檢查數據
summary(housing_data)
colSums(is.na(housing_data))
housing_data <- na.omit(housing_data)

# 3. 構建模型
housing_model <- lm(price_mean ~ count + net_area_mean + mtr_walking_time_mean, data = housing_data)
summary(housing_model)

# 4. 模型診斷
par(mfrow = c(2, 2))
plot(housing_model)

# 5. 改進模型
housing_model_improved <- lm(price_mean ~ net_area_mean + mtr_walking_time_mean, data = housing_data)
summary(housing_model_improved)

# 6. 可視化
library(ggplot2)
ggplot(housing_data, aes(x = net_area_mean, y = price_mean)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "房價均值與住宅面積的關係", x = "住宅面積（平方米）", y = "房價均值（港元）")