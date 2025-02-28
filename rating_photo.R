# 加載必要的庫
library(dplyr)
library(ggplot2)
library(tidyr)

# 假設 `final_data` 已經包含計算好的數據
# 以下代碼基於您提供的數據結構進行可視化

# 1. 數據處理 - 長格式轉換，用於堆疊柱狀圖
long_data <- final_data %>%
  select(region, housing_score, school_score, crime_score, mall_score) %>%
  pivot_longer(cols = housing_score:mall_score, names_to = "score_type", values_to = "score")

# 2. 堆疊柱狀圖 - 各地區分數構成
ggplot(long_data, aes(x = reorder(region, -score), y = score, fill = score_type)) +
  geom_bar(stat = "identity", position = "stack", width = 0.7) +
  labs(title = "各地區分數權重分佈", x = "地區", y = "分數", fill = "分數類型") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 3. 條形圖 - 各地區總分排名
ggplot(final_data, aes(x = reorder(region, -total_score), y = total_score, fill = region)) +
  geom_bar(stat = "identity", width = 0.7) +
  labs(title = "各地區總分排名", x = "地區", y = "總分") +
  scale_fill_brewer(palette = "Paired") +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")