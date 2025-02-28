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

# 計算每呎價的四分位距 (IQR)
iqr <- IQR(house_data$每呎價_實, na.rm = TRUE) # 四分位距
q1 <- quantile(house_data$每呎價_實, 0.25, na.rm = TRUE) # 第一四分位數
q3 <- quantile(house_data$每呎價_實, 0.75, na.rm = TRUE) # 第三四分位數

# 定義異常值範圍
lower_bound <- q1 - 1.5 * iqr # 下限
upper_bound <- q3 + 1.5 * iqr # 上限

# 打印異常值範圍
cat("每呎價的異常值範圍：", lower_bound, "到", upper_bound, "\n")

# 移除每呎價的極端值
house_data_cleaned <- house_data %>%
  filter(
    每呎價_實 >= lower_bound & 每呎價_實 <= upper_bound # 僅保留在合理範圍內的數據
  )

# 檢查清理後的數據
cat("清理後的數據行數：", nrow(house_data_cleaned), "\n")

# 將數據轉換為長格式以便於繪製箱形圖
house_long <- house_data_cleaned %>%
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
    title = "房屋數據的箱形圖（移除極端值）",
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