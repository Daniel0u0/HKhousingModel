# 安裝並載入必要的套件（如果尚未安裝）
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(dplyr)) install.packages("dplyr")
if (!require(tidyr)) install.packages("tidyr")

library(ggplot2)
library(dplyr)
library(tidyr)

# 讀取 house.csv 文件
# 確保文件路徑正確
house_data <- read.csv("house.csv", stringsAsFactors = FALSE)

# 將成交價、面積_實、每呎價_實轉換為數值類型（如果是字符型數據，去掉逗號後轉換為數值）
house_data$成交價 <- as.numeric(gsub(",", "", house_data$成交價))
house_data$面積_實 <- as.numeric(gsub(",", "", house_data$面積_實))
house_data$每呎價_實 <- as.numeric(gsub(",", "", house_data$每呎價_實))

# 將數據轉換為長格式以便於繪製箱形圖
house_long <- house_data %>%
  select(成交價, 面積_實, 每呎價_實) %>% # 選擇需要的列
  pivot_longer(
    cols = everything(), # 將所有列轉換為長格式
    names_to = "變量",   # 新列名為變量
    values_to = "值"     # 新列名為值
  )

# 繪製箱形圖
ggplot(house_long, aes(x = 變量, y = 值, fill = 變量)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 16, outlier.size = 2) +
  labs(
    title = "房屋數據的箱形圖",
    x = "變量",
    y = "值"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.position = "none" # 隱藏圖例
  )