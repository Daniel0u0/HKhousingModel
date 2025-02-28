# 安裝並載入 包
library(lubridate)
library(ggplot2)

# 讀取文件
bus_data <- read.csv("frequencies.txt", header = TRUE, sep = ",")

# 查看數據結構
head(bus_data)


# 轉換 start_time 和 end_time 為時間對象
bus_data <- bus_data %>%
  mutate(
    start_time = hms(start_time),
    end_time = hms(end_time),
    headway_mins = headway_secs / 60  # 將 headway_secs 轉換為分鐘
  )

# 查看處理後的數據
head(bus_data)

# 提取小時字段
bus_data <- bus_data %>%
  mutate(hour = hour(start_time))  # 提取小時部分

# 查看數據
head(bus_data)

# 按小時計算平均等車時間
average_wait_time_by_hour <- bus_data %>%
  group_by(hour) %>%
  summarise(mean_wait_time = mean(headway_mins, na.rm = TRUE)) %>%
  arrange(hour)  # 按小時排序

# 查看結果
print(average_wait_time_by_hour)

library(ggplot2)

# 繪製折線圖
ggplot(average_wait_time_by_hour, aes(x = hour, y = mean_wait_time)) +
  geom_line(color = "blue", size = 1) +  # 添加折線
  geom_point(color = "red", size = 2) +  # 添加數據點
  scale_x_continuous(
    limits = c(0, 23),  # 限制 x 軸範圍
    breaks = seq(0, 23, by = 1),  # 設置 x 軸刻度
    labels = sprintf("%02d:00", seq(0, 23, by = 1))  # 格式化標籤為時間
  ) +
  labs(
    title = "每小時平均等待時間",
    x = "時間（小時）",
    y = "平均等車時間（分鐘）"
  ) +
  theme_minimal()