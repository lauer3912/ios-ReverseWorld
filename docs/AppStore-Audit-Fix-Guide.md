# ReverseWorldGo App Store 审核修复指南

> 生成日期: 2026-07-27
> 基于代码静态分析，修复后预计审核通过率 85%+

## 已验证的提审流程

涉及自动续期订阅时，请先执行 [App Store 订阅与 App 同批提审 SOP](./SOP-AppStore-Subscription-Review.md)。该 SOP 来自 Guideline 2.1(b) 的实际拒审与成功修复，优先级高于本文中基于静态分析作出的提交流程推测。

## 总体评估

| 风险等级 | 数量 | 必须修复 |
|---------|------|---------|
| 🔴 高风险 | 1 | ✅ 提交前必须 |
| 🟡 中风险 | 5 | ✅ 提交前必须 |
| 🔵 低风险 | 7 | ⚠️ 建议优化 |

**结论**: 当前状态不建议提交审核。修复所有高/中风险问题后再提交。

---

## 🔴 高风险问题（必须修复）

### 1. 视频录制功能未检查/请求相机和麦克风权限

**文件**: `ios/ReverseWorld/VideoInversionView.swift:205-244` (`startRecording()` 方法)

**问题描述**:
`VideoInversionRecorder.startRecording()` 直接创建 `AVCaptureSession` 并添加摄像头和麦克风输入，**没有在录制前检查权限状态或调用 `requestAccess`**。与其他功能（如 `CameraController` 和 `PermissionsManager`）不同，这里完全绕过了权限管理流程。苹果审核要求在访问相机/麦克风等敏感硬件前必须获取用户明确授权，否则会直接触发审核拒绝（Guideline 5.1.1）。

**修复方案**:

在 `startRecording()` 方法开头添加权限检查逻辑，统一使用 `PermissionsManager` 管理：

```swift
func startRecording() throws {
    // 先检查权限
    let videoStatus = AVCaptureDevice.authorizationStatus(for: .video)
    let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    
    if videoStatus == .denied || videoStatus == .restricted ||
       audioStatus == .denied || audioStatus == .restricted {
        throw NSError(domain: "VideoInversionRecorder", code: -1, userInfo: [
            NSLocalizedDescriptionKey: "Camera or microphone permission denied. Please enable in Settings."
        ])
    }
    
    let group = DispatchGroup()
    var videoGranted = videoStatus == .authorized
    var audioGranted = audioStatus == .authorized
    
    if videoStatus == .notDetermined {
        group.enter()
        AVCaptureDevice.requestAccess(for: .video) { granted in
            videoGranted = granted
            group.leave()
        }
    }
    
    if audioStatus == .notDetermined {
        group.enter()
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            audioGranted = granted
            group.leave()
        }
    }
    
    group.wait()
    
    guard videoGranted && audioGranted else {
        throw NSError(domain: "VideoInversionRecorder", code: -2, userInfo: [
            NSLocalizedDescriptionKey: "Camera and microphone permissions are required to record video."
        ])
    }
    
    // 原有录制逻辑...
    let captureSession = AVCaptureSession()
    // ...
}
```

或者在调用 `startRecording()` 前（View 层）先通过 `PermissionsManager` 请求权限：

```swift
// VideoInversionView.swift Button action 中
Button {
    if recorder.isRecording {
        recorder.stopRecording { url in
            recordedURL = url
            error = nil
        }
    } else {
        // 先请求权限
        let permManager = PermissionsManager()
        Task {
            let cameraGranted = await permManager.requestCamera()
            let micGranted = await permManager.requestMicrophone()
            if cameraGranted && micGranted {
                do {
                    try recorder.startRecording()
                    error = nil
                } catch {
                    self.error = "Cannot record: \(error.localizedDescription)"
                }
            } else {
                // 显示权限被拒绝的 alert
                self.error = "Camera and microphone permissions are required."
            }
        }
    }
}
```

---

## 🟡 中风险问题（建议修复）

### 2. Premium 付费功能未做门控，付费墙涉嫌误导用户

**文件**:
- `ios/ReverseWorld/VisualEffectsEngine.swift`
- `ios/ReverseWorld/TranslatorView.swift`
- `ios/ReverseWorld/ProfileView.swift:640-644`

**问题描述**:
付费墙列出的 Premium 特性包括：
- "All mirror filters unlocked"
- "All reverse translator modes"
- "Unlimited reverse journal entries"
- "Ad-free experience"

但代码中没有任何地方对这些功能进行 `isPremium` 检查门控：
- 所有滤镜（.mirror, .invert, .hueRotate, .posterize, .noir, .chrome, .sepia, .instant, .mono）均可自由使用
- 所有翻译模式（.reverse, .mirror, .upsideDown, .wordOrder）无任何 premium 限制
- 未发现"reverse journal entries"功能
- 未发现任何广告代码

这违反苹果 Guideline 3.1.1，付费墙功能没有实际锁定属于误导用户付费，会被拒审。

**修复方案（二选一）**:

**方案A（推荐）- 实际实现 Premium 门控**:

1. 在 `VisualEffectsEngine.swift` 中将高级滤镜设为 Premium 锁定：
```swift
enum VisualFilter: String, CaseIterable, Identifiable {
    case mirror, invert, hueRotate, posterize  // 免费
    case noir, chrome, sepia, instant, mono    // Premium
    
    var isPremium: Bool {
        switch self {
        case .mirror, .invert, .hueRotate, .posterize: return false
        case .noir, .chrome, .sepia, .instant, .mono: return true
        }
    }
}
```

2. 在滤镜选择UI中，为 Premium 滤镜显示锁图标，点击时检查 `PremiumManager.shared.isPremium`，未订阅则弹出付费墙。

3. 在 `TranslatorView.swift` 中将高级翻译模式设为 Premium：
```swift
enum TranslatorMode: String, CaseIterable, Identifiable {
    case reverse        // 免费
    case mirror         // 免费
    case upsideDown     // Premium
    case wordOrder      // Premium
    
    var isPremium: Bool {
        switch self {
        case .reverse, .mirror: return false
        case .upsideDown, .wordOrder: return true
        }
    }
}
```

4. 删除付费墙中不存在的功能："Unlimited reverse journal entries"（因为没有这个功能）

**方案B - 如果决定全免费**:
删除付费墙和整个 IAP 相关代码，改为纯免费应用（不推荐，因为已配置 IAP 产品）。

---

### 3. "7天免费试用"文案与实际产品配置不一致

**文件**:
- `ios/ReverseWorld/Strings.swift:70,86`
- `ios/ReverseWorld/ProfileView.swift:632-636`
- `AppStore/Listing.md`

**问题描述**:
UI 文案显示 "Get 7-day free trial"、"7-day free trial, then $X/month"，但根据 Listing.md 记录，**只有 PremiumYearly 配置了7天免费试用**，PremiumMonthly 没有配置 introductory offer。代码中 `PremiumManager` 也没有处理免费试用的逻辑。如果 UI 对月订阅也声称有试用但 ASC 中未配置，属于虚假/误导性描述，违反 Guideline 2.3 和 3.1.1。

**修复方案（二选一）**:

**方案A - 月订阅也加免费试用**:
在 App Store Connect 中为 PremiumMonthly 也添加7天免费试用（Introductory Offer → Free Trial → 7 Days）。

**方案B - 修改文案明确只有年订阅有试用**:
修改付费墙文案：

```swift
// Strings.swift - 修改前
"Get 7-day free trial"
"7-day free trial, then %@/month"

// Strings.swift - 修改后
"Start 7-day free trial with Yearly"
"%@/month after free trial (Yearly only)"
```

在付费墙UI中，明确标注免费试用仅适用于年订阅。

---

### 4. 声明了语音识别权限但功能未实际使用

**文件**:
- `ios/ReverseWorld/Info.plist:37-38`
- `ios/ReverseWorld/PermissionsManager.swift:120-130`
- `ios/ReverseWorld/PermissionsView.swift`
- `ios/ReverseWorld/VoiceInversionView.swift`

**问题描述**:
Info.plist 中声明了 `NSSpeechRecognitionUsageDescription`，描述为 "uses on-device speech recognition to convert your voice into reversed text"。`PermissionsManager` 和 `PermissionsView` 也包含了 Speech Recognition 权限请求 UI。但**整个代码库中没有任何地方实际使用 `SFSpeechRecognizer` 进行语音识别**。`VoiceInversionView` 实际上只是录制音频然后用 PCM 反转播放，没有语音转文字功能。这属于权限声明不准确/过度声明权限，违反 Guideline 5.1.1，会被苹果拒绝。

**修复方案（二选一）**:

**方案A（推荐）- 删除未使用的语音识别权限声明**:

1. 从 `Info.plist` 删除 `NSSpeechRecognitionUsageDescription` 键值对：
```xml
<!-- 删除这两行 -->
<key>NSSpeechRecognitionUsageDescription</key>
<string>ReverseWorldGo uses on-device speech recognition to convert your voice into reversed text in the Voice Inversion feature. Your audio never leaves your device.</string>
```

2. 从 `PermissionsManager.swift` 删除语音识别相关代码：
```swift
// 删除 requestSpeech() 方法和相关 @Published 属性
```

3. 从 `PermissionsView.swift` 删除语音识别权限行和相关UI。

4. 更新 `AppStore/Listing.md` 审核备注，移除语音识别相关描述。

**方案B - 实际实现语音识别功能**:
在 Voice Inversion 中加入 `SFSpeechRecognizer` 将语音转文字后反转显示文本，确保功能与权限描述一致。这需要较多开发工作量。

---

### 5. "Ad-free experience"作为付费特性但应用无广告

**文件**:
- `ios/ReverseWorld/ProfileView.swift:644`
- `ios/ReverseWorld/Strings.swift:71`
- `AppStore/Listing.md:78`

**问题描述**:
付费墙和 App Store 描述都将 "Ad-free experience"（无广告体验）列为 Premium 付费特性之一，但**整个代码库没有任何广告 SDK 集成（无 AdMob、AppLovin、iAd 等），也没有任何广告展示代码**。向用户销售"去广告"功能但应用本身就没有广告，属于虚假功能声明/误导消费者。

**修复方案**:

1. 从 `ProfileView.swift` 付费墙特性列表中移除 "Ad-free experience" 行：
```swift
// 删除或注释掉
// paywallFeatureNoAds = "Ad-free experience"
```

2. 从 `Strings.swift` 中移除相关文案。

3. 从 `AppStore/Listing.md` 的 Premium Features 中删除 "Ad-free experience"。

4. （可选）替换为一个实际存在的 Premium 特性，例如：
   - "HD video export" (高清视频导出)
   - "Custom filter creation" (自定义滤镜)
   - "Unlimited recording length" (无限录制时长)

---

### 6. 拍照保存到相册无权限检查和错误处理

**文件**: `ios/ReverseWorld/CameraPreview.swift:165`

**问题描述**:
拍照后直接调用 `UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)` 保存到相册，completion callback 设为 nil，**无法检测保存是否成功或用户是否拒绝了权限**。虽然 iOS 会触发系统级添加照片权限弹窗，但缺乏统一的权限管理和错误反馈，用户拒绝权限后会静默失败，体验差。

**修复方案**:

使用带 completion callback 的方式保存，并给用户反馈：

```swift
// CameraPreview.swift - 修改保存照片逻辑
func savePhoto(_ image: UIImage) {
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
}

@objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    DispatchQueue.main.async {
        if let error = error {
            // 保存失败，显示错误提示
            self.saveError = "Failed to save photo: \(error.localizedDescription)"
            self.showSaveError = true
        } else {
            // 保存成功，显示成功提示
            self.showSaveSuccess = true
        }
    }
}
```

或者改用 `PHPhotoLibrary` 配合 `PermissionsManager`：

```swift
func savePhoto(_ image: UIImage) {
    let permManager = PermissionsManager()
    Task {
        let granted = await permManager.requestPhotoAddOnly()
        guard granted else {
            await MainActor.run {
                self.saveError = "Photo library access is required to save photos."
                self.showSaveError = true
            }
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.showSaveSuccess = true
                } else {
                    self.saveError = error?.localizedDescription ?? "Failed to save photo."
                    self.showSaveError = true
                }
            }
        }
    }
}
```

---

## 🔵 低风险问题（建议优化）

### 7. WKWebView 加载外部页面无导航限制

**文件**: `ios/ReverseWorld/ProfileView.swift:446-460` (PrivacyPolicyWebView)

**问题描述**:
使用 `WKWebView()` 直接加载 GitHub Pages 上的隐私政策/服务条款页面，但没有设置 `WKNavigationDelegate` 限制导航范围。如果页面被篡改包含恶意链接，用户可能从应用内浏览器跳转到钓鱼网站。

**修复方案**:

设置 `WKNavigationDelegate` 限制只允许在指定域内导航，或改用 `SFSafariViewController`：

```swift
struct PrivacyPolicyWebView: UIViewRepresentable {
    let url: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let host = navigationAction.request.url?.host,
               host == "lauer3912.github.io" {
                decisionHandler(.allow)
            } else {
                // 外部链接用 Safari 打开
                if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
                    UIApplication.shared.open(url)
                }
                decisionHandler(.cancel)
            }
        }
    }
}
```

---

### 8. 麦克风权限请求使用两套独立 API

**文件**:
- `ios/ReverseWorld/AudioInversionService.swift:27-37`
- `ios/ReverseWorld/PermissionsManager.swift:97-102`

**问题描述**:
`AudioInversionService` 使用 `AVAudioApplication.requestRecordPermission()` / `AVAudioSession.requestRecordPermission`，而 `PermissionsManager` 使用 `AVCaptureDevice.requestAccess(for: .audio)`。两套独立的权限请求路径可能导致 PermissionsUI 显示的权限状态与实际不一致。

**修复方案**:
统一使用一套 API。建议在 `PermissionsManager` 中统一使用 `AVAudioSession.requestRecordPermission`，并让 `AudioInversionService` 也通过 `PermissionsManager` 来请求权限。

---

### 9. 麦克风权限描述与实际功能不完全匹配

**文件**: `ios/ReverseWorld/Info.plist:31-32`

**问题描述**:
`NSMicrophoneUsageDescription` 描述为 "Record voice memos to attach to your reverse-video projects... saved to the project file"，但 VideoInversionView 的视频录制到临时目录，view 消失时被清理，没有 "attach to reverse-video projects" 或 "save to project file" 的功能。

**修复方案**:
修改为更准确的描述：

```xml
<key>NSMicrophoneUsageDescription</key>
<string>ReverseWorldGo needs microphone access to record audio for your reversed videos. All processing happens locally on your device.</string>
```

---

### 10. PrivacyInfo.xcprivacy 存在重复键和潜在不匹配

**文件**: `ios/ReverseWorld/PrivacyInfo.xcprivacy`

**问题描述**:
1. `NSPrivacyCollectedDataTypes` 键在文件中出现了两次（第9行和第46行），XML 格式不规范。
2. 声明了 `FileTimestamp`(C617.1)、`DiskSpace`(E174.1)、`SystemBootTime`(35F9.1) 三个 API 访问理由，但代码中未发现直接调用这些 API。

**修复方案**:

1. 删除重复的 `NSPrivacyCollectedDataTypes` 键（保留一个空数组即可）。
2. 检查是否真的需要这些 API 理由声明：
   - 如果未直接使用，删除对应条目。
   - 如果是系统框架间接使用且需要声明，保留并确认理由码正确。

修正后的 PrivacyInfo.xcprivacy：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyTrackingDomains</key>
    <array/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array/>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
        <!-- 删除 FileTimestamp, DiskSpace, SystemBootTime 如果未使用 -->
    </array>
</dict>
</plist>
```

---

### 11. 命令行参数暴露调试/截图功能开关

**文件**:
- `ios/ReverseWorld/ProfileView.swift:504-522`
- `ios/ReverseWorld/ContentView.swift:8-22`
- `ios/ReverseWorld/ReverseWorldApp.swift:11-13`

**问题描述**:
代码中包含 `-autoPaywall`、`-highlightPlan`、`-forceDarkMode`、`-initialTab` 等命令行参数，用于 ASC 截图自动化。虽然生产环境用户无法通过正常方式触发，但苹果审核员检查代码时可能注意到这些隐藏开关。

**修复方案**:
在 Release 构建中通过 `#if DEBUG` 条件编译禁用：

```swift
// 例如
#if DEBUG
if CommandLine.arguments.contains("-autoPaywall") {
    showPaywall = true
}
#endif
```

---

### 12. 源码目录存在 Info.plist 备份文件

**文件**: `ios/ReverseWorld/Info.plist.bak.1784177318`

**问题描述**:
源码目录中存在备份文件，需要确认 Xcode Build Phase 不会将此备份文件打包进 IPA。

**修复方案**:
直接删除该备份文件，或添加到 `.gitignore`。

```bash
rm ios/ReverseWorld/Info.plist.bak.1784177318
```

---

### 13. 支持邮箱与品牌名不一致

**文件**: `ios/ReverseWorld/ProfileView.swift` (mailto 链接)

**问题描述**:
支持邮箱为 `support@techidaily.com`，与应用名 ReverseWorldGo / 开发者品牌不一致，可能引起审核员疑问。

**修复方案**:
建议使用与应用域名匹配的邮箱（如 `support@reverseworld.app`），或在 App Store Connect 中设置一致的技术支持邮箱。

---

## 📋 App Store Connect 配置待办（Web UI 手动操作）

根据 `AppStore/Listing.md` 记录，以下配置项必须在 ASC Web UI 手动完成（API 无法覆盖）：

- [ ] **Submit for Review** — 在 ASC → App Store → 3.0.0 → 右上角点击提交审核
- [ ] **设置 PremiumYearly 价格** — Pricing tier → 设置为 $29.99/年（或对应等级）
- [ ] **设置 App 价格层级** — 确认为 Free（免费+IAP模式）
- [ ] **设置 availableInNewTerritories** — App Information → Availability 中配置新地区可用性
- [ ] **填写 App Privacy 问卷** — ASC → App Privacy 页面逐项回答数据收集问题（必须手动填写）

---

## ✅ 合规亮点（无需修改）

| 检查项 | 状态 |
|--------|------|
| 无私有API调用 | ✅ 合规 |
| 无第三方支付/绕过IAP（使用 StoreKit 2） | ✅ 合规 |
| 未使用IDFA，无广告追踪 | ✅ 合规 |
| 无用户数据上传，所有处理本地完成 | ✅ 合规 |
| 出口合规配置（ITSAppUsesNonExemptEncryption = false） | ✅ 合规 |
| iPad 原生支持（UIDeviceFamily [1,2]） | ✅ 合规 |
| 隐私政策和服务条款页面已准备 | ✅ 合规 |

---

## 📌 修复优先级总结

| 优先级 | 任务 | 预计工作量 |
|--------|------|-----------|
| P0 立即 | 修复 VideoInversionRecorder 视频录制前权限检查 | ~1小时 |
| P0 立即 | 实现 Premium 功能门控（或移除未实现的付费特性） | ~3-4小时 |
| P1 提交前 | 删除未使用的 Speech Recognition 权限声明 | ~30分钟 |
| P1 提交前 | 修复"Ad-free"虚假特性声明 | ~15分钟 |
| P1 提交前 | 对齐免费试用文案与ASC配置 | ~30分钟 |
| P1 提交前 | 修复照片保存权限回调和错误处理 | ~1小时 |
| P2 建议 | ASC Web UI 完成所有配置项 | ~30分钟 |
| P2 建议 | 修复 PrivacyInfo.xcprivacy 重复键、WKWebView 导航限制等低风险项 | ~1-2小时 |

**总预计修复工作量**: 约 7-8 小时
