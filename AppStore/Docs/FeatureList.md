# ReverseWorld - Feature List

## App Overview
- **App Name**: ReverseWorld
- **Bundle ID**: com.ggsheng.ReverseWorld
- **Core Concept**: A mind-bending reverse reality app that flips, mirrors, reverses, and inverts real-world rules. Users experience mirror modes, reverse text, discover daily reverse rules, and explore parallel realities.
- **Target Users**: 欧美青少年、青年、中年 (14-45 years old)
- **App Language**: English (primary), no Chinese characters in UI
- **Platform**: iOS 17.0+

---

## 功能清单 (60+ Features)

### 1. 镜像世界 (Mirror World)
1. 实时镜像摄像头 - 前置摄像头镜像翻转显示
2. 镜像拍照 - 拍出镜像照片
3. 镜像视频录制 - 录制造反的镜像视频
4. 镜像画廊 - 查看历史镜像作品
5. 左右翻转切换 - 一键切换左右镜像
6. 镜像特效 - 镜像时添加梦幻滤镜

### 2. 反话翻译器 (Reverse Translator)
7. 文字反转 - 输入文字输出完全反转的文字
8. 镜像文字 - 把文字变成镜像效果阅读
9. 上下颠倒 - 文字上下颠倒显示
10. 反序播放 - 整句单词顺序反转
11. 语音输入反转 - 语音输入后反转文字
12. 反话生成器 - 把正常句子变成字面反话

### 3. 今日规则 (Today's Reverse Rule)
13. 每日规则推送 - 每天一个颠覆性规则
14. 规则日历 - 查看历史规则
15. 规则倒计时 - 距离下一个规则还有多久
16. 规则挑战 - 完成规则获得奖励
17. 规则分享 - 分享规则给朋友
18. 自定义规则 - 创建你自己的反向规则

### 4. 逆向日记 (Reverse Journal)
19. 逆向书写 - 不是写"做了什么"，而是写"避免了什么"
20. 时光倒流回顾 - 从后往前读日记
21. 反向情绪追踪 - 记录什么让你平静而不是焦虑
22. 逆向成就 - 今天你避免了什么的成就系统

### 5. 平行世界探索 (Parallel Explorer)
23. 二选一模拟 - 如果做了不同选择会怎样？
24. 命运分支 - 展示人生决定的分支图
25. 反向时间线 - 从未来回看现在的视角
26. 平行宇宙生成 - AI 生成不同选择的结果

### 6. 物理学反转 (Physics Flip)
27. 倒流视频 - 把正常视频变成倒放
28. 声音反转 - 把正常声音变成倒放
29. 倒放GIF - 创建倒放循环动图
30. 反弹效果 - 把物理规律反转的视觉特效

### 7. 反向美学 (Reverse Aesthetics)
31. 反向滤镜 - 把照片颜色完全反转（底片效果）
32. 镜像拼贴 - 把照片镜像拼接成艺术
33. 负片模式 - 经典负片视觉效果
34. 反向色彩 - 把白天变夜晚，夏天变冬天

### 8. 个人中心 (Profile)
35. 反向统计 - 反向记录你的数据
36. 成就徽章 - 收集所有反向成就
37. Reverse Days - 连续使用天数
38. 规则收藏 - 收藏的规则列表
39. 设置反向偏好 - 自定义反向效果强度

### 9. 工具箱 (Toolbox)
40. 截图反转 - 一键反转截图内容
41. 剪贴板反转 - 把剪贴板内容反转
42. 数字计算器 - 反向计算（输结果出算式）
43. 密码反转器 - 把密码反转后保存

### 10. 设置 (Settings)
44. 深色/浅色主题 - 主题切换
45. 通知设置 - 规则推送时间
46. 语言设置 - 英语为主
47. 隐私政策 - 完整隐私政策
48. 联系我们 - support@techidaily.com
49. 评分入口 - App Store 评分
50. 分享好友 - 分享 App

---

## Identifier Capabilities 推荐

| 功能 | Capabilities |
|------|-------------|
| 摄像头镜像 | NSCameraUsageDescription |
| 照片保存/读取 | NSPhotoLibraryUsageDescription, NSPhotoLibraryAddUsageDescription |
| 语音输入 | NSSpeechRecognitionUsageDescription |
| 通知 | UIBackgroundModes: remote-notification |

---

## 技术架构

- **UI Framework**: SwiftUI
- **Architecture**: MVVM
- **Data Storage**: UserDefaults (设置), 文件系统 (媒体)
- **Camera**: AVFoundation (镜像处理)
- **AI**: 设备端处理（无云端 AI）
- **分享**: UIActivityViewController