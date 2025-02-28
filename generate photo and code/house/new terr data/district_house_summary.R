# 安裝並載入必要的套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(dplyr)) install.packages("dplyr")
if (!require(tidyr)) install.packages("tidyr")

library(ggplot2)
library(dplyr)
library(tidyr)

# 手動輸入數據
data <- data.frame(
  subregion.name = c("西貢", "元朗", "沙田", "屯門", "大埔", "荃灣", "北區", "葵青", "離島"),
  Count = c(4460, 4248, 3476, 2380, 1591, 1563, 1198, 902, 605),
  price_mean = c(8934287, 6767943.74, 9623499.42, 5552915.55, 10735137.02, 7928181.96, 7005786.31, 5498832.59, 9450271.07),
  price_median = c(7555000, 5565000, 7120000, 4500000, 8000000, 6500000, 4645000, 5300000, 7000000),
  net_area_mean = c(606.83, 605.61, 659.62, 498.99, 774.18, 590.04, 614.76, 488.55, 793.49),
  net_area_median = c(540, 521, 546, 445, 586, 531, 454, 460, 646),
  price_over_net_area_mean = c(15113.13, 11344.63, 14604.64, 11301.96, 13875.76, 13182.14, 11409.73, 12644.81, 11673.07),
  price_over_net_area_median = c(14764.50, 11067.00, 14041.50, 10654.50, 13428.00, 12105.00, 10904.00, 12329.00, 11401.00),
  mtr_walking_time_seconds_mean = c(423.9, 561.75, 672.51, 499.96, 396.9, 398.74, 469.29, 383.51, 599.61)
)

# 1. 繪製價格 (price) 的箱形圖
price_data <- data %>%
  select(subregion.name, price_mean, price_median) %>%
  pivot_longer(cols = -subregion.name, names_to = "變量", values_to = "值")

ggplot(price_data, aes(x = 變量, y = 值, fill = 變量)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 16, outlier.size = 2) +
  labs(
    title = "價格 (Price) 的箱形圖",
    x = "變量",
    y = "價格 (HK$)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.position = "none"
  )

# 2. 繪製實用面積 (net area) 的箱形圖
net_area_data <- data %>%
  select(subregion.name, net_area_mean, net_area_median) %>%
  pivot_longer(cols = -subregion.name, names_to = "變量", values_to = "值")

ggplot(net_area_data, aes(x = 變量, y = 值, fill = 變量)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 16, outlier.size = 2) +
  labs(
    title = "實用面積 (Net Area) 的箱形圖",
    x = "變量",
    y = "面積 (平方呎)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.position = "none"
  )

# 3. 繪製每平方呎價格 (price over net area) 的箱形圖
price_per_area_data <- data %>%
  select(subregion.name, price_over_net_area_mean, price_over_net_area_median) %>%
  pivot_longer(cols = -subregion.name, names_to = "變量", values_to = "值")

ggplot(price_per_area_data, aes(x = 變量, y = 值, fill = 變量)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 16, outlier.size = 2) +
  labs(
    title = "每平方呎價格 (Price Over Net Area) 的箱形圖",
    x = "變量",
    y = "價格 (HK$/平方呎)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.position = "none"
  )

# 4. 繪製地鐵步行時間 (mtr walking time) 的箱形圖
mtr_time_data <- data %>%
  select(subregion.name, mtr_walking_time_seconds_mean) %>%
  pivot_longer(cols = -subregion.name, names_to = "變量", values_to = "值")

ggplot(mtr_time_data, aes(x = 變量, y = 值, fill = 變量)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 16, outlier.size = 2) +
  labs(
    title = "地鐵步行時間 (MTR Walking Time) 的箱形圖",
    x = "變量",
    y = "步行時間 (秒)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.position = "none"
  )