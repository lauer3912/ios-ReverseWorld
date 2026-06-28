# ReverseWorldGo — App Store Listing Metadata

> 由 AI Agent 生成，Human 对照此文件在 App Store Connect 填写信息
> 所有字段为**具体值（非占位符）**
>
> Last Updated: 2026-06-28 (Katherine-E2wa1m audit + fixes per SOUL.md #44 iOS App 修复 SOP)

---

## 第一步：App 信息

| 字段 | 值 |
|------|-----|
| App Store 名称 | ReverseWorldGo |
| Bundle ID | com.ggsheng.ReverseWorld |
| 主要语言 | English (US) |
| 完整版本号 | 3.0.0 (MARKETING_VERSION, per project.yml) |
| Build 号 | 2 (CURRENT_PROJECT_VERSION, 升自 1 → 2) |
| 创建日期 | 2026-06-26 (per ASC API: createdDate 2026-06-26T03:06:53-07:00) |
| APP_ID (ASC) | 6784627660 |
| SKU | ReverseWorld-001 |

---

## 第二步：价格与分发

| 字段 | 值 |
|------|-----|
| 价格层级 | Free (with IAP) |
| 分发地区 | 所有可用地区 |
| 版权 | Copyright © 2026 ReverseWorldGo ZhiFeng Sun |

---

## 第三步：App 隐私（App Store Connect 逐项选择）

| 数据类型 | 是否收集 | 说明 |
|---------|---------|------|
| 位置 | 否 | 不收集位置数据 |
| 联系信息 | 否 | 不收集联系人 |
| 标识符 | 否 | 不追踪用户 |
| 浏览器 | 否 | 无浏览器功能 |
| 使用数据 | 否 | 本地存储，不上传 |
| 健康 | 否 | 不涉及健康数据 |
| 历史搜索 | 否 | 不记录搜索历史 |
| 用户生成内容 | 是 | 用户创建的镜像照片/视频、文字反转内容 |
| 照片 | 是 | 用户导入照片进行镜像/反转处理 |
| 视频 | 是 | 用户录制的镜像视频 (NSMicrophone + NSCamera) |
| 语音 | 是 | 语音输入功能（语音转文字，NSSpeechRecognition） |
| 日历 | 否 | 不访问日历 |
| 购买历史 | 是 | App 内购买记录本地存储 |

---

## 第四步：App 功能描述

### 关键词（100字符内，逗号分隔）
```
mirror,reverse,flip,world,invert,parallel,reality,cam,camera,text,video,photo
```

### 描述（English）

**ReverseWorldGo** — See the World Differently

Experience reality in reverse! Mirror your world, reverse your text, and discover daily rules that flip your perspective. A mind-bending journey into parallel realities awaits.

**Features:**
- **Mirror Camera** — Front camera with live mirror effect
- **Reverse Translator** — Flip text, create mirror writing, upside-down text
- **Today's Reverse Rule** — New rule every day that flips reality
- **Parallel Explorer** — "What if" simulations of different choices
- **Physics Flip** — Reverse videos and sounds
- **Reverse Aesthetics** — Negative filters, day-to-night effects

**Premium Features:**
- All mirror filters unlocked
- Ad-free experience
- Unlimited reverse journal entries
- Priority rule updates

Download ReverseWorldGo and explore the flip side!

### 促销文本（170字符内）
```
Mirror your world. Reverse your text. Discover parallel realities. Download ReverseWorldGo and see things differently!
```

---

## 第五步：技术支持

| 字段 | 值 |
|------|-----|
| 技术支持网址 | https://lauer3912.github.io/ios-ReverseWorld/PrivacyPolicy.html |
| 隐私政策网址 | https://lauer3912.github.io/ios-ReverseWorld/PrivacyPolicy.html |

---

## 第六步：内购产品配置

### 订阅产品（Auto-Renewable Subscription）

**订阅组名称**: PremiumGroup

| 产品 ID | 价格等级 | 显示名称(EN) | 描述(EN) | 时长 | 审核截图 |
|--------|---------|-------------|---------|------|---------|
| ReverseWorld.premium_monthly | Tier 2 ($0.99) | Premium Monthly | Unlock all premium features: all filters, ad-free, unlimited entries | 1 Month | ✅ IAP_ReverseWorld_PremiumMonthly_iPhone69.png |
| ReverseWorld.premium_yearly | Tier 15 ($29.99) | Premium Yearly | Best value: unlock all premium features for a full year | 1 Year | 待上传 |

**Introductory Offers（试用）**:

| 产品 ID | 优惠类型 | 时长 | 说明 |
|--------|---------|------|------|
| ReverseWorld.premium_yearly | Free Trial | 7 Days | 7-day free trial for Premium Yearly |

---

## 第七步：年龄分级

| 字段 | 值 |
|------|-----|
| 年龄分级 | 4+ |
| 评级机构 | Apple |

---

## 第八步：截图文件清单

> 截图文件位于 `AppStore/Screenshots/` 目录下

### iPhone 6.9" (1320×2868)

| 序号 | 页面名称 | 文件名 | 尺寸 |
|------|---------|--------|------|
| 01 | Home / Daily Rule | 01_Home.png | 1320×2868 |
| 02 | Mirror Camera | 02_Mirror.png | 1320×2868 |
| 03 | Reverse Translator | 03_Translate.png | 1320×2868 |
| 04 | Daily Rules | 04_Rules.png | 1320×2868 |
| 05 | Profile / Settings | 05_Profile.png | 1320×2868 |

### iPad 12.9" (2048×2732)

| 序号 | 页面名称 | 文件名 | 尺寸 |
|------|---------|--------|------|
| 01 | Tab 1 (Home) | 00_tab1.png | 2048×2732 |
| 02 | Tab 2 (Mirror) | 01_tab2.png | 2048×2732 |
| 03 | Tab 3 (Translator) | 02_tab3.png | 2048×2732 |
| 04 | Tab 4 (Rules) | 03_tab4.png | 2048×2732 |
| 05 | Tab 5 (Profile) | 04_tab5.png | 2048×2732 |

> 注: iPad 截图是 2026-06-27 10:49 CST 用 simctl `-initialTab` launch args 截的 5 个 tab (per #44 #3 + Plan L4)

### IAP 截图

| 产品 | 文件名 |
|------|--------|
| ReverseWorld.premium_monthly | AppStore/Screenshots/InAppPurchase/IAP_ReverseWorld_PremiumMonthly_iPhone69.png |

---

## 第九步：构建版本 (最新上传)

| 字段 | 值 |
|------|-----|
| 版本号 | 3.0.0 (MARKETING_VERSION) |
| Build 号 | 2 (升自 1 → 2, per #44 #7 改 code → rebuild) |
| 上传日期 | 2026-06-28 (CST) |
| Build UUID | 待 altool upload 后填 |
| processingState | 待 ASC API verify (必须 VALID) |

---

## 第十步：审核备注

| 字段 | 值 |
|------|-----|
| 测试账号 | 无需登录 |
| 演示账号 | 不需要 |
| 审核备注 | This app uses camera (mirror mode), microphone (mirror video audio), speech recognition (voice → reversed text), and photo library (save creations). All processing happens locally on device. No user accounts required. |

---

## 第十一步：出口合规

| 字段 | 值 |
|------|-----|
| 出口合规已预配置 | ✅ YES — ITSAppUsesNonExemptEncryption = false |
| UIDeviceFamily | [1, 2] (iPhone + iPad, per #44 #4 iPad native 支持) |

---

## 第十二步：设备方向 (新增, per Info.plist UISupportedInterfaceOrientations)

| 字段 | 值 |
|------|-----|
| iPhone 方向 | Portrait, PortraitUpsideDown, LandscapeLeft, LandscapeRight |
| iPad 方向 | 全部 (同上, App 自动响应) |
| LSRequiresIPhoneOS | true |

---

## 第十三步：权限用途说明 (新增, per Info.plist 权限完整列表)

| 权限 | 用途 (Apple 审核员必读) |
|------|---------|
| NSCameraUsageDescription | "ReverseWorldGo needs camera access for mirror mode and reverse video features." |
| NSPhotoLibraryAddUsageDescription | "ReverseWorldGo needs to save your reverse creations to your photo library." |
| NSPhotoLibraryUsageDescription | "ReverseWorldGo needs photo library access to apply reverse effects to your images." |
| NSMicrophoneUsageDescription | "ReverseWorldGo needs microphone access to record mirror videos with sound." (新增) |
| NSSpeechRecognitionUsageDescription | "ReverseWorldGo uses speech recognition to convert your voice into reversed text." (新增) |

---

*Generated: 2026-04-30 (initial)*
*Last Updated: 2026-06-28 07:50 CST (Katherine-E2wa1m audit + Info.plist UIDeviceFamily add + Listing.md real values per #6 铁律完整值)*