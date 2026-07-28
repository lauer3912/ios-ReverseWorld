# iOS App 本地开发 Agent SOP

> ⚠️ **【强制】本文档是针对本地 Mac 开发的 Agent 操作指南**
>
> - Agent 在执行任何步骤前，**必须先读取并理解最新版本的本文档**
> - 所有规则和要求一旦更新，Agent 必须立即遵循，**禁止用旧经验或记忆中的规则**

> 🚀 **【核心声明】iOS App 项目从创意到上架销售，全部由 Agent 主动推动**
>
> - **Agent 工作占比：99%**
> - Human 仅在**被动审核环节**介入（审核提案、审核图标、审核名称、审核 UI）
> - **Agent 是唯一的工作主体和决策者**，负责：提出创意、分析市场、设计功能、编写代码、配置环境、执行构建测试、生成文档、推送变更
> - **Human 的角色是审核者（Approver），不是决策者（Decider）**
> - **Agent 禁止向 Human 提问，Agent 必须自己分析、自己决策、自己执行**

> 🌎 **【目标市场强制】所有 App 必须面向欧美用户**
>
> - **目标市场：欧美（Europe & America）**
> - **语言：英文（English Only）** — 所有 App 文本、UI、权限描述、隐私政策、服务条款、App Store 元数据**必须使用英文**
> - **设计审美：西方审美** — 避免中式审美元素（红金配色、生肖、太极等亚洲特有元素）
> - **欧美市场是硬性要求**，不是可选项。任何面向非欧美市场的设计或内容都是违规

---

> 📖 **跨项目跳读速查卡**：[`iPad-Screenshot-Recipe.md`](../iPad-Screenshot-Recipe.md) — iPad 截图 / App Store 截图自动化 5 步可复制模板 + 5 症状诊断表 · §8.17 配套

---

> 📝 **SOP 版本**：v14（2026-06-04 更新）— v13 + 新增 **§0 OpenClaw 新 Mac 5 分钟上手 (Portable Onboarding)** 7 子节 (Skills 清单 / Apple Team / GitHub Pages / Bundle ID / 项目常量替换表 / 环境就绪自检 / 跨项目搬迁清单)。使 SOP 从 80% portable 提升到 90%+。USER.md 新增 Onboarding Template 7 块 (身份/风格/字段内规/节奏/阻塞阈值/沟通偏好/项目上下文)
>
> 📜 **版本历史**：
> - v10 (2026-06-03) — §8.16 本地通知 + §8.17 截图自动化 + §8.18 Mock 数据清理 + HR-56~62 + SC-42~48
> - v9 (2026-06-02) — §8.14 Multi-Provider AI Service + §8.15 HealthKit 集成 + HR-51/52/53/54/55 + SC-38/39/40/41
> - v8 (2026-06-02) — §8.13 Light/Dark 主题 + HR-48/49/50 + SC-34/35/36/37
> - v7 (2026-06-02 下午) — `privacy@techidaily.com` + `legal@techidaily.com` + `support@techidaily.com` 三邮箱职责分工，§8.4.0 + HR-47 + SC-33
> - v6 (2026-06-02 上午) — 添加 VitaPocket 2026-06-02 提交前修复经验：AppIcon 加载 + 隐私政策/服务条款内嵌显示（§4.5.1 + §8.4.2 + HR-45/HR-46 + SC-31/SC-32）
> - v5 (2026-05-30) — 多 AI 提供商支持、Settings Tab 重构、Widget App Groups 修复
> - 早期版本见 `git log` / `MEMORY.md`

---

## §0. OpenClaw 新 Mac 5 分钟上手 (Portable Onboarding) — 2026-06-04

> 🎯 **本节目标**: 任意 Mac + OpenClaw + 本 SOP, 5 分钟内达到 80% 工作能力。**这是让 SOP 真正 portable 的关键节**。
>
> 原理: 任何项目专属的常量 (Apple Team ID / GitHub Pages 域名 / Bundle ID 前缀) 都是**变量**，集中起来一次替换后整个 SOP 适用。

### §0.1 必装 Skills (clawhub install)

| Skill | 用途 | 必需性 | 安装命令 |
|-------|------|--------|---------|
| `ios` | iOS App 开发主框架 | 必需 | `clawhub install ios` |
| `minimax-ios-dev` | iOS Dev 模式 (Xcode/Swift) | 必需 | `clawhub install minimax-ios-dev` |
| `ah-mobile-app-developer` | Mobile App 模式 | 必需 | `clawhub install ah-mobile-app-developer` |
| `coding-agent` | 后台 Agent 调度 (跨任务) | 必需 | `clawhub install coding-agent` |
| `swift` | Swift 语言辅助 | 必需 | `clawhub install swift` |
| `xcode` | Xcode 工具链 | 必需 | `clawhub install xcode` |
| `xcode-build-analyzer` | Build 失败诊断 | 强烈推荐 | `clawhub install xcode-build-analyzer` |
| `appstore-deployment-guide` | App Store 部署流程 | 强烈推荐 | `clawhub install appstore-deployment-guide` |
| `ui-ux-design` | UI/UX 设计 | 推荐 | `clawhub install ui-ux-design` |
| `apple-design-skill` | Apple HIG 设计 | 推荐 | `clawhub install apple-design-skill` |
| `ios-app-icon` | App 图标生成 | 可选 | `clawhub install ios-app-icon` |
| `minimax-cli` | minimax 平台调用 | 可选 | `clawhub install minimax-cli` |

**快装命令 (必需 + 强烈推荐)**:
```bash
clawhub install ios minimax-ios-dev ah-mobile-app-developer coding-agent swift xcode xcode-build-analyzer appstore-deployment-guide
```

**验证安装**:
```bash
ls ~/.openclaw/skills/  # 应含上述目录
```

### §0.2 Apple Developer Account 配置

1. 打开 Xcode → Settings (⌘,) → Accounts → "+" Apple ID
2. 登录你的 Apple ID (例: zhi.feng.sun@gmail.com)
3. 选中账号 → "Manage Certificates" → "+" Apple Development
4. 记下 **Team ID** (Xcode → Signing & Capabilities → Team 下拉，格式: 10 字符)
5. **项目级替换**: 后续项目 `project.yml` 中填入此 Team ID

**验证**:
```bash
security find-identity -v -p codesigning | head -3
# 输出应含 "Apple Development: {你的名字} ({你的TeamID})"
```

### §0.3 GitHub Pages 域名配置

1. 记下你的 GitHub 用户名 (例: `lauer3912`)
2. 后续项目 `PrivacyPolicy.html` 等部署 URL 格式: `https://{你的用户名}.github.io/ios-{AppName}/`
3. 创建 GitHub repo `{你的用户名}/{你的用户名}.github.io` 启用 Pages (Settings → Pages → Source: `main`)

### §0.4 Bundle ID 前缀配置

1. 选择反向域名 (例: `com.yourname`)
2. 项目 Bundle ID 格式: `com.yourname.{AppName}` (例: `com.yourname.MyApp`)
3. **避免使用 `com.example.*` (Apple 会拒)**
4. **避免与已上架 App 重复** (查 App Store Connect → My Apps)

### §0.5 项目专属常量一次替换表

创建新项目时, 把本项目 (`lauer3912/ios-VitaMind`) 的专属常量**全量替换**为你自己的:

| 常量 | 本项目值 | 替换为 |
|------|----------|--------|
| `9L6N2ZF26B` | Apple Team ID | 你的 Team ID (§0.2) |
| `lauer3912` | GitHub 用户名 | 你的用户名 (§0.3) |
| `lauer3912.github.io` | Pages 域名 | 你的域名 (§0.3) |
| `com.ggsheng.` | Bundle ID 前缀 | 你的前缀 (§0.4) |
| `support@techidaily.com` | 联系邮箱 | 你的邮箱 (可不与 GitHub 同域, HR-35) |
| `techidaily.com` | 邮箱域名 (URL 不可用) | 你的邮箱域名 |

**一键查找所有项目专属常量** (新项目开始前跑):
```bash
grep -rEn "9L6N2ZF26B|lauer3912|com\.ggsheng\.|techidaily\.com" \
  ~/Desktop/ios-{AppName}/ --include="*.yml" --include="*.md" --include="*.swift" --include="*.html" \
  | head -30
```

### §0.6 环境就绪自检

跑以下命令, 全部 ✅ 表示新 Mac 已就绪:

```bash
# 1. SOP §8.22 21 项上架质量检查
~/.openclaw/workspace/scripts/sop-822-check.sh

# 2. workspace 根零图片 (HR-88)
ls ~/.openclaw/workspace/*.png 2>/dev/null | wc -l  # 期望 0

# 3. Skills 验证
ls ~/.openclaw/skills/ | grep -E "^(ios|swift|xcode|coding-agent)$"

# 4. Apple Developer Team 验证
security find-identity -v -p codesigning | head -1

# 5. GitHub 认证验证
gh auth status 2>&1 | head -3
```

全过 = 可开始 iOS App 开发。**首次运行可能需要修改 §0.5 的常量**, 不属于环境问题。

### §0.7 跨项目搬迁清单 (从本项目迁移到新项目)

| 步骤 | 文件 | 动作 |
|------|------|------|
| 1 | `docs/SOP-iOS-Local-Development.md` | 复制整个 `docs/` 目录 |
| 2 | `MEMORY.md` | 复制到 workspace 根 (含本项目历史) |
| 3 | `scripts/sop-822-check.sh` | 复制整个 `scripts/` 目录 |
| 4 | `AGENTS.md / SOUL.md / IDENTITY.md / USER.md` | 复制 (人设通用) |
| 5 | **不**复制 | `~/Desktop/ios-{AppName}/` (项目专属, 重新创建) |
| 6 | **不**复制 | `memory/2026-XX-XX.md` (本项目日报, 新项目重新生成) |

执行后跳到 §1 App 类型, 启动新项目。

---

## 👤 角色分工

| 角色 | 职责 | 权限边界 |
|------|------|---------|
| 🤖 **AI Agent** | **所有工作：决策、分析、编码、配置、构建、测试、部署** | Agent 可以做任何技术决策，不需要询问 Human |
| 👨 **Human** | **仅审核：看图说"通过"或"不通过"** | Human 只说 approve/reject，不能给出技术指令 |

> ⚠️ **Human 禁止向 Agent 发出技术指令**。Human 说"我要加个功能"是违规的，应该说"这个提案不通过，因为功能太少"。

---

## ⚠️ 关键流程说明

### Archive 上传流程（重要）

```
┌─────────────────────────────────────────────────────┐
│  1. 🤖 Agent 完成代码开发、测试、截图                │
│  2. 🤖 Agent 立即执行 `git add && git commit`        │
│  3. 🤖 Agent 立即执行 `git push` 推送代码            │
│  4. 👨 Human 通过本地 Xcode GUI 执行 Archive：      │
│     Product → Archive → Distribute App →           │
│     App Store Connect → Upload                      │
│  5. 👨 Human 告知 Agent 操作成功                    │
│  6. 🤖 Agent 继续后续工作（如配置 GitHub Pages）     │
└─────────────────────────────────────────────────────┘
```

> ⚠️ **【强制】代码必须及时提交推送**：本地开发代码虽然在本机，但**必须立即执行 `git commit` 和 `git push`**。这是为了：
> - **备份**：防止本地机器故障导致代码丢失
> - **协作**：Human 可以查看代码状态
> - **历史追溯**：保留完整的开发记录
>
> ⚠️ **关于签名**：本地 Mac 的 Xcode 使用**自动签名**（Automatically manage signing），不需要手动获取 Profile。Human 通过 Xcode GUI 上传后，Xcode 自动处理签名。
>
> ⚠️ **版本号**：新 App 必须从 `3.0.0` 开始。

### 定价策略（重要）

> ⚠️ **定价策略**：
> - **第一版发行**（首个上架版本）：**免费下载**（Free），无内购
> - **所有后续版本升级**：采用**自动续期订阅制**（Auto-Renewable Subscription）

**订阅方案推荐配置**：
| 方案 | 月付 | 年付 | 免费试用 |
|-----|------|------|---------|
| 基础方案 | $2.99/月 | $19.99/年（省 44%） | 7天 |
| 高级方案 | $4.99/月 | $39.99/年（省 33%） | 7天 |
| 家庭方案（可选） | $6.99/月 | $49.99/年（省 40%） | 7天 |

---

## 🔧 本地开发环境配置

### Claude Code 启动命令

```bash
# 直接运行 Claude Code（无需额外配置，使用本地默认模型）
claude

# 或使用 Bypass Permissions 模式（跳过权限确认）
claude --dangerously-disable-permission-prompts
```

### 本地 Xcode 命令

| 操作 | 命令 |
|------|------|
| **生成项目** | `~/tools/xcodegen/bin/xcodegen generate` |
| **构建项目** | `xcodebuild build -project {AppName}.xcodeproj -scheme {AppName} -configuration Debug -destination 'platform=iOS Simulator,name=iPhone XX'` |
| **运行测试** | `xcodebuild test -project {AppName}.xcodeproj -scheme {AppName} -destination 'platform=iOS Simulator,name=iPhone XX'` |
| **清理缓存** | `rm -rf ~/Library/Developer/Xcode/DerivedData/{ProjectName}-*` |
| **列出模拟器** | `xcrun simctl list devices available` |
| **启动模拟器** | `xcrun simctl boot "iPhone XX"` |
| **截图（模拟器）** | `xcrun simctl io booted screenshot /tmp/{filename}.png` |

### GitHub 连接配置

> Agent 需要能访问 GitHub 来推送代码。

| 配置项 | 说明 |
|--------|------|
| GitHub Token | `GH_TOKEN\=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` |
| 用途 | Agent 使用此 Token 推送代码 |

---

## 📋 开发流程总览

### Stage -1：项目提案（必须先完成，Human 审核）

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| -1.1 | **调研最新趋势** | 🤖 Agent | **必须先通过 WebSearch 调研最新 iOS App 趋势、科技方向、市场机会** |
| -1.2 | 提出项目提案 | 🤖 Agent | 基于调研结果输出 `AppStore/ProjectProposal.md` |
| -1.3 | 审核项目提案 | 👨 Human | **审核并决定是否要做** |

> ⚠️ **必须等 Human 审核通过后才能继续**

> 🚨 **【强制】Agent 必须调研最新趋势，禁止基于旧知识随意提案**

> ⚠️ **【强制】Agent 必须先重新读取 `2026-2028-iOS-App-Up.md` 参考文档**，获取最新 iOS App 趋势和技术方向，再进行提案。

**调研要求（必须执行）**：
1. 使用 `WebSearch` 搜索 **iOS App trends 2026**、**trending apps 2026**、**future technology predictions**
2. 搜索 **AI mobile apps trends**、**AR/VR apps future**、**wearable technology apps**
3. 搜索 **App Store market opportunities 2026**、**emerging tech business opportunities**
4. 分析搜索结果，识别 **未来 1-3 年的市场机会**
5. 提案必须基于调研发现的 **真实趋势和机会**，不是基于记忆中的旧知识
6. **必须引用 `2026-2028-iOS-App-Up.md` 中的趋势分析**，结合该文档进行提案

**ProjectProposal.md 格式（Agent 必须直接填入具体内容，不要留空）**：
```markdown
# 项目提案

## 调研来源
**必须列出 WebSearch 使用的搜索词和关键发现**

## 1. App 类型
**必须填写具体的 App 类型，并写明理由**

## 2. 核心功能（至少 10 个）
**必须列出具体的功能**

## 3. 为什么欧美客户会喜欢
**必须写出具体的市场分析和用户痛点**

## 4. 盈利评估
**必须填写具体数字**：
- 定价模式：免费+订阅
- 预期用户量：XX 万（首年）
- 预期收入：XX 美元/月（保守）
- 主要竞争对手：App A、App B

## 5. 为什么我们做这个
**必须写出差异化优势**

## 6. 风险评估
**必须写出具体风险和应对方案**
```

> ⚠️ **Agent 必须输出完整填写的 ProjectProposal.md，输出后等待 Human 审核（approve/reject），禁止输出任何问题**

### Stage 0：设计审核（Human 审核通过提案后）

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 0.1 | 生成图标方案 | 🤖 Agent | 使用 Skill → `ios-app-icon-generator` |
| 0.2 | 审核图标方案 | 👨 Human | **看图后**给出至少 1 个 approved 意见 |
| 0.3 | 生成 UI 方案 | 🤖 Agent | 输出设计稿图片 |
| 0.4 | 审核 UI 方案 | 👨 Human | **看图后**给出至少 1 个 approved 意见 |

> ⚠️ **必须等 Human 审核通过后才能开始开发**

### Stage 1：项目初始化

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 1.1 | 核查 App Store 名称是否被占用 | 🤖 Agent | 执行 curl 命令查询 |
| 1.2 | **选择名称** | 👨 Human | **Agent 提供至少 3 个候选名称，Human 只选其中一个** |
| 1.3 | 确定三层命名方案 | 🤖 Agent | 根据 Human 选择的名称确定 |
| 1.4 | 输出功能清单 | 🤖 Agent | 输出 `AppStore/Docs/FeatureList.md`，**≥60 个功能** |
| 1.5 | 确认功能数量 | 👨 Human | **Human 只确认数量是否 ≥60，不参与功能设计** |
| 1.6 | 输出界面设计规范 | 🤖 Agent | 输出界面设计规范 |
| 1.7 | 生成 App Store 元数据文件 | 🤖 Agent | 写入 `AppStore/Listing.md` |

### Stage 2：创建目录结构

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 2.1 | 创建目录结构 | 🤖 Agent | 执行 mkdir 命令 |
| 2.2 | 初始化 Git | 🤖 Agent | `git init && git branch -M main && git add && git commit` |

### Stage 3：配置 project.yml

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 3.1 | 编写 project.yml | 🤖 Agent | 配置 targets |
| 3.2 | 审查 project.yml | 🤖 Agent | Claude Code 审查 + 修复 |

### Stage 4：生成配置文件

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 4.1 | 编写 Info.plist、Entitlements | 🤖 Agent | 按模板生成 |
| 4.2 | 审查配置文件 | 🤖 Agent | Claude Code 审查 + 修复 |
| 4.3-4.5 | 编写 Widget 配置、AppIcon 规范 | 🤖 Agent | 按模板生成 |

### Stage 5：生成 Xcode 项目

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 5.1 | 执行 XcodeGen 生成项目 | 🤖 Agent | 本地执行 `~/tools/xcodegen/bin/xcodegen generate` |
| 5.2 | 验证生成结果 | 🤖 Agent | 检查文件是否完整 |
| 5.3 | Git 提交 | 🤖 Agent | `git add && git commit -m "Initial project"` |
| 5.5 | 验证构建（Debug） | 🤖 Agent | `xcodebuild build CODE_SIGNING_ALLOWED=NO` |

### Stage 6：截图与测试

> ⚠️ **【强制】代码变更后必须同步更新 App Store 材料**（**每次代码变更都必须执行，无例外**）：
> - **适用场景**：功能开发完成时、bug 修复时、功能变更时、UI 调整时、**任何代码改动**
> - 任何代码或功能变更后，**必须立即检查并更新**所有相关材料：
>   - 截图（尺寸、内容是否符合新功能/变更）
>   - App Store 元数据（描述、关键词、版本说明是否需要更新）
>   - 隐私政策（功能变更是否影响隐私政策条款）
>   - FeatureList（是否需要更新功能数量统计）
> - **禁止只更新代码而忽略 App Store 材料**
> - 违反此规则视为严重违规（HR-22）

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 6.1 | 截图尺寸要求 | 🤖 Agent | 见 §6.1 |
| 6.2 | 编写截图代码 | 🤖 Agent | 生成 `ScreenshotTests.swift` |
| 6.3 | 添加 Tab identifier | 🤖 Agent | 修改 App 源码 |
| 6.4-6.5 | 执行截图 | 🤖 Agent | 本地执行 xcodebuild test，截图保存到 `AppStore/Screenshots/` |
| 6.6 | 展示截图给 Human 审核 | 🤖 Agent | **直接发送图片文件** |
| 6.7 | 编写 + 审查 Unit Tests | 🤖 Agent | Claude Code 审查 + 修复 |
| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 7.1 | 配置 App Groups | 🤖 Agent | 修改 entitlements |
| 7.2 | Archive 上传 TestFlight | 👨 Human | **通过本地 Xcode GUI 执行 Archive → Upload** |
| 7.3 | 等待构建处理 | - | App Store Connect 自动处理 |
| 7.4 | 修复 Bug（如有）| 🤖 Agent | 根据反馈修改代码 |

### Stage 7.5：App Store Connect 预填写（Agent 执行）

> ⚠️ **【强制】Agent 必须在上架前准备好所有 App Store Connect 材料**
> 此阶段在 Archive 前执行，材料保存到 `AppStore/Listing.md`

Agent 必须生成并填写以下内容到 `AppStore/Listing.md`：

#### 7.5.1 App 基本信息

| 字段 | 要求 | 示例/说明 |
|------|------|---------|
| **Name** | ≤255 字符 | "VitaMindGo" |
| **Subtitle** | ≤255 字符 | "Your AI Health Companion" |
| **Description** | ≤4000 字符 | 详细介绍 App 功能和价值 |
| **Keywords** | ≤100 字符，逗号分隔 | "health,fitness,habits,AI,wellness" |
| **Promotional Text** | ≤170 字符 | 可随时更新的简短宣传语 |
| **Category** | 主类别 + 次类别 | Health & Fitness, Lifestyle |

#### 7.5.2 定价与分发

| 字段 | 选项 |
|------|------|
| **Price Tier** | 0 (Free) 或具体价格 |
| **Available in all territories** | 是/否 |
| **Content Rating** | 需要完成 Apple 问卷 (4.3+, 3+, 6+, 9+) |
| **Age Verification** | 是 (13+, 17+) |

#### 7.5.3 App Review Information

| 字段 | 填写值 |
|------|--------|
| **Contact Email** | `support@techidaily.com` |
| **Phone** | 审核问题联系电话（如有） |
| **Demo Account** | 如果需要登录，测试账号密码 |
| **Notes** | 给审核员的备注（如"此 App 使用 HealthKit 数据"） |

> ⚠️ **【强制】App Store Connect Contact Email 必须是 `support@techidaily.com`**，**不得**误用 `privacy@` 或 `legal@`。这三个邮箱各有明确职责（见 §8.4.0）：support = 审核员/App 问题、privacy = 隐私数据问题、legal = 法律条款问题。

#### 7.5.4 Screenshots 清单确认

| 设备 | 数量 | 尺寸 | 状态 |
|------|------|------|------|
| iPhone 6.7" (iPhone 17 Pro Max) | 4 张 | 1206×2622 | 待截取 |
| iPad Pro 13" (M4) | 4 张 | 2048×2732 | 待截取 |
| Apple Watch | 1 张 | 396×484 | 待截取 |

#### 7.5.5 IAP 内购配置（如有）

> ⚠️ **IAP 必须同时在 Xcode + App Store Connect 两处配置**

| 配置位置 | 内容 |
|----------|------|
| **Xcode** | IAP 产品 ID、类型（消耗型/非消耗型/订阅）|
| **App Store Connect** | IAP 定价、描述、审核截图 |

**IAP 产品 ID 命名规范**：`com.ggsheng.{AppName}.{ProductType}`
- 示例：`com.ggsheng.VitaMindGo.premium_monthly`

#### 7.5.6 完整检查清单

```markdown
## App Store 上架前检查清单

### 基础信息
- [ ] Name 已填写且 ≤255 字符
- [ ] Subtitle 已填写且 ≤255 字符
- [ ] Description 已填写且 ≤4000 字符
- [ ] Keywords 已填写且 ≤100 字符
- [ ] Category 已选择
- [ ] Content Rating 问卷已提交

### 截图
- [ ] iPhone 截图 4 张，尺寸 1206×2622
- [ ] iPad 截图 4 张，尺寸 2048×2732
- [ ] Watch 截图 1 张，尺寸 396×484
- [ ] 所有截图已 resize 到上传尺寸
- [ ] 所有截图 MD5 唯一

### IAP（如有）
- [ ] Xcode 内 IAP 产品 ID 已配置
- [ ] App Store Connect 内 IAP 已创建
- [ ] IAP 审核截图已准备
- [ ] IAP 定价已设置

### 隐私与法律
- [ ] Privacy Policy URL 已填写
- [ ] 隐私政策页面可访问
- [ ] App Tracking Transparency 说明已准备（如有跟踪）

### 构建与签名
- [ ] Bundle ID 正确 (`com.ggsheng.{AppName}`)
- [ ] Version ≥ 3.0.0
- [ ] Build 号已递增
- [ ] Signing Certificate 正确
- [ ] Capabilities 配置完整
```

### Stage 8：App Store 上架

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 8.1 | 生成 Listing.md | 🤖 Agent | 生成完整的 `AppStore/Listing.md` |
| 8.2 | Archive + Upload | 👨 Human | **通过本地 Xcode GUI 执行** |
| 8.3 | 填写 App Store Connect 信息 | 👨 Human | 按 `Listing.md` 填写 |
| 8.4 | 配置 IAP（如有）| 🤖 Agent | 在 App Store Connect 创建 IAP 产品 |
| 8.5 | 上传 IAP 审核截图 | 👨 Human | 每个 IAP 需要至少 1 张审核截图 |
| 8.6 | 提交审核 | 👨 Human | 点击提交审核 |
| 8.7 | 创建隐私政策 HTML | 🤖 Agent | 生成 `PrivacyPolicy.html` |
| 8.8 | 创建服务条款 HTML | 🤖 Agent | 生成 `TermsOfService.html` |
| 8.9 | 部署隐私政策和服务条款到 GitHub Pages | 🤖 Agent | 放入 `docs/` 目录 |
| 8.10 | 写隐私政策 AI 相关条款 | 🤖 Agent | 生成 AI 相关隐私政策条款 |

### Stage 8.5：审核被拒 (Rejection) 处理流程

> ⚠️ **【强制】审核被拒是正常流程，Agent 必须能够独立处理**
> Apple 审核通常需要 24-48 小时，首次提交被拒是常态

#### 审核被拒分类与应对

| 拒绝原因 (Rejection Reason) | 常见原因 | 修复步骤 |
|-----------------------------|---------|---------|
| **2.1.0 App Completeness** | 功能不完整、崩溃、占位符 | 完善功能 → 重新测试 → 重新 Archive |
| **3.1.1 In-App Purchase** | IAP 配置错误、未显示、沙盒问题 | 检查 IAP ID、价格、审核截图 |
| **4.1.0 Design: Spam** | App 与现有 App 过于相似 | 增加独特功能、差异化 UI |
| **4.2.0 Design: Minimum Functionality** | App 功能太少、无实际用途 | 增加功能至 ≥60 个 |
| **5.1.1 Data Collection** | 隐私政策缺失或不合规 | 更新隐私政策、添加隐私标签 |
| **Guideline 2.3.3** | 截图与实际 App 不符 | 更新截图 |
| **Guideline 3.1.1** | IAP 购买流程问题 | 检查 StoreKit 配置 |

#### 审核被拒处理流程

```
收到 Rejection 通知
    ↓
1. 仔细阅读 Rejection 原因 + 审核员备注
    ↓
2. 识别问题类型（Completeness / Metadata / Design / IAP / Privacy）
    ↓
3. Agent 修复代码/配置
    ↓
4. 重新执行 Unit Tests + UITests
    ↓
5. 确认截图、Listing.md 是否需要更新
    ↓
6. Human 重新 Archive + Upload
    ↓
7. 在 App Store Connect 回复审核员（说明已修复）
    ↓
8. 重新提交审核
```

#### 回复审核员模板

```markdown
Thank you for reviewing our app.

We have addressed the issue mentioned:
- [具体说明修复了什么]
- [如有代码变更，说明变更内容]
- [确认已验证修复有效]

Our app is ready for re-review.
```

#### 常见被拒场景详细修复

**场景 1：App 崩溃 (2.1.0 App Completeness)**
```bash
# 1. 查看崩溃日志
# App Store Connect → My Apps → Activity → Build 崩溃日志

# 2. 修复代码问题
# 3. 重新 Archive
xcodebuild archive -project <AppName>.xcodeproj -scheme <AppName>

# 4. Human 上传新构建
```

**场景 2：IAP 问题 (3.1.1)**
```bash
# 检查项：
# 1. IAP Product ID 是否匹配（Xcode 代码 vs App Store Connect）
# 2. IAP 价格是否设置（不能为 0 除非 App 免费）
# 3. IAP 审核截图是否上传
# 4. IAP Status 是否为 Ready to Submit 或 Approved

# 常见错误：
# - IAP 状态为 Missing Metadata → 需要填写 IAP 描述和审核截图
# - IAP 状态为 Developer Removed from Sale → 恢复 IAP
```

**场景 3：隐私政策问题 (5.1.1)**
```bash
# 1. 确认 Privacy Policy URL 可访问
# 2. 隐私政策必须包含：
#    - 数据收集类型（HealthKit、位置、广告 ID 等）
#    - 第三方 SDK 数据共享
#    - 家长控制（如果是 13+）
#    - AI/机器学习使用（如有）
```

### Stage 9：提交前最终检查

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 9.1 | 完整性最终复查 | 🤖 Agent | 输出检查清单 + Capabilities 确认 |
| 9.2 | 确认所有截图已就绪 | 🤖 Agent | 检查尺寸、命名、MD5 |
| 9.3 | IAP 最终检查（如有）| 🤖 Agent | 确认 IAP 配置完整 |
| 9.4 | 隐私政策确认 | 🤖 Agent | 确认 URL 可访问且内容合规 |
| 9.5 | 版本号确认 | 🤖 Agent | Version ≥ 3.0.0，Build 递增 |

#### 提交前最终检查清单 (Agent 输出)

```bash
#!/bin/bash
echo "=== App Store 上架前最终检查 ==="

# 1. 检查截图
for size in "iPhone17ProMax_1320x2868" "iPadPro13inchM4_2048x2732" "AppleWatchUltra3_396x484"; do
    dir="AppStore/Screenshots/$size"
    if [ -d "$dir" ]; then
        count=$(ls "$dir"/*.png 2>/dev/null | wc -l | tr -d ' ')
        echo "$size: $count 张截图"
    fi
done

# 2. 检查隐私政策
if curl -s -o /dev/null -w "%{http_code}" "https://{username}.github.io/{repo}/PrivacyPolicy.html" | grep -q "200"; then
    echo "✓ Privacy Policy 可访问"
else
    echo "✗ Privacy Policy 不可访问"
fi

# 3. 检查 Version 和 Build
grep -E "CFBundleShortVersionString|CFBundleVersion" Sources/Info.plist

# 4. 检查 IAP（如有）
echo "请确认 App Store Connect 内 IAP 状态为 Ready to Submit 或 Approved"
```

### Stage 10：上架后监控与维护

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 10.1 | 监控审核状态 | 👨 Human | App Store Connect 查看审核进度 |
| 10.2 | 审核通过后检查 | 🤖 Agent | 确认 App 已上线，状态为 Ready for Sale |
| 10.3 | 用户反馈处理 | 👨 Human | 如果有崩溃或问题，报告给 Agent |
| 10.4 | Bug 修复迭代 | 🤖 Agent | 修复问题 → 新版本号 → 重新 Archive → 重新提交 |

#### 版本迭代流程 (Hotfix)

```bash
# 1. Agent 修复 Bug

# 2. 递增 Build 号（不要改 Version，除非是大版本更新）
# Version: 3.0.0 → 3.0.1 (小版本更新)
# Build: 1 → 2

# 3. Agent 更新 Listing.md 中的版本说明

# 4. Human 重新 Archive + Upload

# 5. 在 App Store Connect 选择新 Build，提交审核

# 6. 审核通过后自动上线
```

---
| 9.1 | 提交前 Capabilities 最终复查 | 🤖 Agent | 输出检查清单 + Capabilities 指导意见 |
| 9.2 | 确认所有截图已就绪 | 🤖 Agent | 检查尺寸、命名 |

---

## 🚨 硬性禁止规则

| 规则ID | 规则内容 |
|--------|---------|
| HR-00 | **禁止跳过 Stage -1 项目提案** - 必须等 Human 审核提案后才能开始开发 |
| HR-01 | **禁止跳过 Stage 0 设计审核** - 必须等 Human 审核图标和 UI 后才能开始开发 |
| HR-02 | **禁止在非 main 分支开发** - 所有开发必须在 main 分支上进行 |
| HR-03 | **禁止使用中文 UI** - 所有 App 必须面向欧美用户，英语 UI |
| HR-04 | **禁止使用中式/亚洲审美元素** - 图标和 UI 必须符合西方审美 |
| HR-05 | **禁止伪造截图/测试报告/构建日志** - 所有产出物必须真实执行生成 |
| HR-06 | **禁止跳过验证步骤** - MD5/尺寸验证/测试必须真实执行 |
| HR-07 | **禁止伪造功能实现** - 所有功能必须真实可用 |
| HR-08 | **禁止向 Human 提问** - Agent 必须自己分析、自己决策、自己执行，**禁止发送任何问题给 Human** |
| HR-09 | **禁止 Human 发出技术指令** - Human 只说 approve/reject，**不能**告诉 Agent 怎么实现 |
| HR-10 | **禁止虚报功能数量** - FeatureList 必须 ≥60 个功能 |
| HR-11 | **禁止偷懒/省略工作** - 所有功能必须完整实现 |
| HR-12 | **禁止跳过边界情况处理** - 必须处理所有异常场景 |
| HR-13 | **禁止降低测试标准** - 测试必须覆盖正常流程 + 边界情况 |
| HR-14 | **禁止跳过代码审查** - 每次代码变更后必须执行 Claude Code 审查 |
| HR-15 | **禁止减少功能审查次数** - 功能完整性自检必须 ≥3 次 |
| HR-16 | **禁止跳过 UI 适配** - 必须支持 Light/Dark Mode、所有设备尺寸 |
| HR-17 | **禁止跳过无障碍功能** - 必须实现 accessibilityIdentifier、VoiceOver 支持 |
| HR-18 | **禁止跳过性能优化** - 启动时间 <5 秒、包体积 <150MB |
| HR-19 | **禁止使用模板隐私政策** - 隐私政策必须根据 App 实际功能定制 |
| HR-20 | **禁止延迟代码提交** - 代码必须立即 commit 和 push，**禁止在本地积累未提交代码** |
| HR-21 | **禁止项目放在 ~/Desktop 以外的目录** - 所有 iOS 项目**必须**放在 `~/Desktop/ios-{AppName}/` 目录下 |
| HR-31 | **禁止在未完成 App Store Connect 预填写前 Archive** - 必须先完成 `Listing.md` 才能进行 Archive 上传 |
| HR-32 | **禁止跳过审核被拒处理** - 被拒后必须分析原因、修复问题、回复审核员、重新提交，不得绕过或搁置 |
| HR-33 | **禁止在 IAP 配置不完整时提交审核** - IAP 必须 Xcode + App Store Connect 两处都正确配置，且状态为 Ready to Submit 或 Approved |
| HR-34 | **禁止 LaunchScreen 与 Display Name 不一致** - LaunchScreen.storyboard 中的 App 名称必须与 CFBundleDisplayName 一致，否则用户第一眼看到错误的名称 | §8.4 |
| HR-35 | **禁止对外 URL 使用非 GitHub Pages 域名** - 所有 App Store Connect 填入的 URL (Privacy Policy / Terms of Service / Developer Website / Support URL) **必须**用 `https://{username}.github.io/ios-{AppName}/docs/{Document}.html` 或 `https://{username}.github.io/ios-{AppName}/` 格式。**不要**用邮箱域名 (如 techidaily.com)，即使邮箱 @ 该域名 下。邮箱与 URL 域名解耦：邮箱 = 内部使用 (如 support@techidaily.com)，URL = 外部可达 (只能用 GitHub Pages) | §8.4 |
| HR-36 | **禁止在 UI 代码中使用中文** - 所有 `Text()`、`.navigationTitle()`、Label 等用户可见字符串必须是英文，违反者视为 HR-03 违规 | §8.11 |
| HR-37 | **禁止 Widget Info.plist 的 CFBundleDisplayName 与主 App 同名** - Widget 的 Display Name 应包含 "Widget" 后缀（如 "VitaMindGo Widget"），主 App 的 CFBundleDisplayName 不应包含 "Widget" 后缀 | §8.22 |
| HR-38 | **AI 默认模型必须是欧美市场最流行的先进模型（无预配置 Key 时）** - 默认模型必须是在欧美市场（美国/欧洲）目前最流行、最先进的模型。不得从 Agent 知识库获取，必须通过实时搜索确认截至 2026-06-01 欧美市场 AI 模型排名：① Anthropic `anthropic/claude-opus-4-6` > ② OpenAI `openai/gpt-5.5` > ③ Google `google/gemini-3.5-flash` > ④ Meta `llama-4-maverick` > ⑤ NVIDIA `nemotron-3-super-120b`。**iOS 健康类 App 欧美用户默认建议 `anthropic/claude-opus-4-6`**，次选 `openai/gpt-5.5`。如排名变化，须重新搜索确认并更新本 SOP。**例外**：如果 App 开发者预配置了特定厂商的 API Key（如 MiniMax 中国区 Key），默认使用预配置的厂商，无需手动输入 Key | §8.11 |
| HR-39 | **AI 提供商必须支持至少 10 家厂商供欧美客户自定义选择** - AI 服务设置界面必须列出至少 10 家 AI 厂商（Provider）供用户选择，涵盖欧美市场主流和中国出海热门厂商：MiniMax、OpenAI、Anthropic、Google、DeepSeek、xAI、Moonshot AI、Qwen、Z.AI、StepFun。用户可自选 Provider 和 Model，且设置需持久化保存 | §8.11 |
| HR-40 | **默认 AI 预配置模型对用户透明不可见** - 默认 AI 模型（如 MiniMax 预配置）不允许用户在 Settings 界面查看或编辑 Provider 名称、模型名称、API Key。用户只能看到 "AI Service: Ready" 状态。额外的 9 家 AI 厂商（OpenAI/Anthropic/Google/DeepSeek/xAI/Moonshot/Qwen/Z.AI/StepFun）可由用户自行配置 baseURL + API Key + model | §8.12.5 |
| HR-44 | **Custom AI Providers 必须提供 baseURL + API Key + Model 三项配置** - 用户选择自定义 AI Provider 时，配置页面必须包含 Base URL（必填）、API Key（必填）、Model（Picker）三个字段，且提供 Test Connection 验证功能 | §8.12.5 |
| HR-41 | **AI Provider/Model ID 必须使用 OpenClaw 官方格式** - Provider ID 必须使用小写 canonical 格式（如 `anthropic`、`openai`、`deepseek`），Model ID 必须使用 `provider/model` 格式（如 `anthropic/claude-opus-4-6`）。禁止自行编造模型 ID（如 `claude-opus-4.8`），必须参照 OpenClaw 官方文档 (docs.openclaw.ai/providers) 确认正确格式。所有模型 ID 需与 OpenClaw provider 兼容 | §8.11 |
| HR-42 | **AI 模型 ID 变更必须经过实时验证** - 当市场排名更新或 SOP 更新后，Agent 必须重新访问 docs.openclaw.ai/providers 获取最新的模型 ID 和 Provider ID，不能用上次记忆或自己推测的 ID。模型 ID 一旦变更，必须同步更新代码中的 `defaultModel`、`supportedModels` 和 `AIService.shared.selectedModel` | §8.11 |
| HR-43 | **所有 AI API 请求必须 strip provider/ 前缀** - 不只是 MiniMax，所有厂商的 API 请求都需要去除 provider/ 前缀。例如 `openai/gpt-5.5` → `gpt-5.5`，`anthropic/claude-opus-4-6` → `claude-opus-4-6`。每家厂商的 API 只接受其对应的裸模型名。发送带前缀的模型名会导致 400/404 错误。代码中推荐统一使用 `let modelName = selectedModel.contains("/") ? String(selectedModel.split(separator: "/", omittingEmptySubsequences: false).last ?? "") : selectedModel` | §8.12.1 |
| HR-44 | **MiniMax API 端点必须根据预配置 Key 的类型选择正确的地址** - MiniMax 有三个端点：① 全球：`https://api.minimax.io/v1`（国际版）② 中国：`https://api.minimaxi.com/v1`（中国区，供国内用户自定义）③ ~~`api.minimax.chat`~~（已废弃，禁止使用）。**如果预配置的 API Key 是中国区 Key（如 sk-cp-Jrs...），必须使用 `api.minimaxi.com/v1`，不能用全球端点**。欧美用户自定义可选择全球端点。 | §8.12.1 |
| HR-44 | **API 请求时必须 strip 掉 provider 前缀** - `provider/model` 格式仅用于代码存储和 UI 显示，发送给 API 的模型名必须去除 provider 前缀（如 `minimax/MiniMax-M2.7` → `MiniMax-M2.7`）。不同厂商 API 对模型名格式要求不同，MiniMax 等 OpenAI-Compatible 厂商只接受裸模型名。发送错误格式会导致 400/404 或 ATS 错误 | §8.12.1 |
| **HR-45** | **禁止 App 内 Privacy Policy / Terms of Service 只用外链显示** - 必须使用 WKWebView 加载本地 Bundle HTML 资源内嵌显示。`Link(destination: URL)` 外链方式在模拟器/飞行模式/弱网下会失败，违反 App Store 5.1.1 条款要求。**同时仍需保留 GitHub Pages 外链供 App Store Connect URL 字段使用**。参见 §8.4.2 | §8.4.2 |
| **HR-46** | **禁止 App UI 中显示的 AppIcon 使用占位符** - About / Settings / 分享卡片中的 AppIcon 必须加载真实发行图标（从 Info.plist CFBundleIconFiles 或 bundle 根的 AppIcon*.png 加载）。禁止用「蓝紫渐变 + 通用 SF Symbol」等占位图代替，违反者视为 HR-22 类违规。参见 §4.5.1 | §4.5.1 |
| **HR-47** | **禁止法律文档中混用联系邮箱** - Privacy Policy 必须用 `privacy@techidaily.com`、Terms of Service 必须用 `legal@techidaily.com`、App Store Connect Contact Email 和 App 内 Contact Support 必须用 `support@techidaily.com`。**三个邮箱职责独立、不可互换**。违反者视为 HR-22 类违规。参见 §8.4.0 | §8.4.0 |

| HR-23 | **禁止功能变更后不重新验证** - 代码变更后必须重新执行 Unit Tests、UITests、尺寸验证，确保无引入新问题 |

---

## ❓ 常见问题排查

### 本地构建相关

| 问题 | 原因 | 解决 |
|------|------|------|
| **xcodebuild: error: Unable to find destination** | 模拟器名称不对 | 使用 `xcrun simctl list devices available` 查看可用模拟器 |
| **Code Signing error** | Debug 构建不需要签名，但可能有残留配置 | 使用 `CODE_SIGNING_ALLOWED=NO` 参数 |
| **Build input file cannot be found** | Profile 问题 | 本地开发用 Xcode GUI 的自动签名，不需要手动 Profile |
| **xcodegen: error: Spec not found** | project.yml 路径问题 | 确认在项目根目录执行，且文件存在 |

### Archive 上传相关

| 问题 | 原因 | 解决 |
|------|------|------|
| **Archive 失败** | 代码有问题 | Agent 修复代码后，Human 重新 Archive |
| **Upload 失败** | 网络或账号问题 | Human 检查 App Store Connect 账号状态 |
| **构建一直卡在处理中** | App Store Connect 服务器问题 | 等待几分钟刷新页面 |


## 📁 项目结构参考

```
ios-{AppName}/
├── project.yml              # XcodeGen 配置
├── {AppName}.xcodeproj      # 生成的 Xcode 项目
├── App/
│   ├── App.swift
│   ├── Info.plist
│   ├── Assets.xcassets/
│   └── {AppName}.entitlements
├── Widget/
│   ├── Widget.swift
│   ├── Info.plist
│   └── {AppName}Widget.entitlements
├── AppStore/
│   ├── Screenshots/         # 截图目录
│   └── Listing.md           # App Store 元数据
├── Docs/
│   └── FeatureList.md       # 功能清单
└── Tests/
    ├── VitaMindUITests.swift
    ├── UnitTests.swift
```

---

## 🔗 相关文档

- **App Store Connect API**：参考 `skills/app-store-connect/SKILL.md`
- **Xcode 构建分析**：参考 `skills/xcode-build-analyzer/SKILL.md`
- **iOS 图标生成**：参考 `skills/ios-app-icon-generator/SKILL.md`

---

# 完整 SOP

---

## 📋 规则分类索引

> ⚠️ **【强制】本索引是 SOP 的规则总纲，Agent 执行前必须先检查本索引**

### 🚨 Hard Rules - 硬性禁止规则（违反即违规）

| 规则ID | 规则内容 | 依据锚点 |
|--------|---------|---------|
| HR-00 | **禁止跳过 Stage -1 项目提案** - 必须等 Human 审核提案后才能开始开发 | ⚠️ Stage -1 |
| HR-01 | **禁止跳过 Stage 0 设计审核** - 必须等 Human 审核图标和 UI 后才能开始开发 | ⚠️ Stage 0 |
| HR-02 | **禁止在非 main 分支开发** - 所有开发必须在 main 分支上进行 | §2.1 Git 初始化 |
| HR-03 | **禁止使用中文 UI** - 所有 App 必须面向欧美用户，英语 UI | ⚠️ 目标用户 |
| HR-04 | **禁止使用中式/亚洲审美元素** - 图标和 UI 必须符合西方审美 | ⚠️ 目标用户 |
| HR-05 | **禁止伪造截图/测试报告/构建日志** - 所有产出物必须真实执行生成 | §6.0 / §6.7 |
| HR-06 | **禁止跳过验证步骤** - MD5/SSIM/尺寸验证/测试必须真实执行，禁止伪造验证结果 | §6.0 Step 5 |
| HR-07 | **禁止使用旧经验** - SOP 更新后必须立即遵循，不许用记忆中的旧规则 | ⚠️ 开头 |
| HR-08 | **禁止歪曲 SOP** - Agent 说辞与 SOP 矛盾时，以 SOP 为准 | ⚠️ 开头 |
| HR-09 | **App 包含特殊功能（通知/相机/位置/健康等）必须完整实现** | §8.6 |
| HR-10 | **禁止伪造功能实现** - 所有功能必须真实可用，禁止用占位符/空壳冒充完整功能 | §8.6 |
| HR-11 | **禁止伪造配置完成** - project.yml/Info.plist/Entitlements/Capabilities 必须真实配置并验证 | §3 / §4 |
| HR-12 | **禁止跳过 Human 审核** - 设计/UI/隐私政策/图标/截图必须 Human 审核通过才能继续 | §Stage 0 / §6.6 / §8.4 |
| HR-13 | **禁止虚报功能数量** - FeatureList 必须真实统计，≥60 个功能为硬性要求 | §1.4 |
| HR-14 | **禁止偷懒/省略工作** - 所有功能必须完整实现，禁止用 TODO/占位符/空壳/简化版冒充 | §8.6 |
| HR-15 | **禁止跳过边界情况处理** - 必须处理所有异常场景（空数据、网络错误、权限拒绝等） | §8.6 |
| HR-16 | **禁止降低测试标准** - 测试必须覆盖正常流程 + 边界情况 + 异常场景 | §6.7 / §6.8 |
| HR-17 | **禁止跳过代码审查** - 每次代码变更后必须执行 Claude Code 审查 + 修复 | §6.11 |
| HR-18 | **禁止减少功能审查次数** - 功能完整性自检必须 ≥3 次，禁止只做 1 次 | §6.11 |
| HR-19 | **禁止跳过 UI 适配** - 必须支持 Light/Dark Mode、所有设备尺寸、横竖屏 | §8.14 |
| HR-20 | **禁止跳过无障碍功能** - 必须实现 accessibilityIdentifier、VoiceOver 支持 | §8.15 |
| HR-21 | **禁止跳过性能优化** - 启动时间 <5 秒、内存合理、包体积 <150MB | §8.13 |
| HR-22 | **禁止使用模板隐私政策** - 隐私政策必须根据 App 实际功能定制 | §8.4 |
| HR-23 | **禁止省略执行日志** - 必须完整记录所有关键步骤的执行情况 | ⚠️ 违规处罚机制 |
| HR-24 | **禁止将分内工作推给 Human** - Agent 必须独立完成所有标注为"🤖 Agent 直接执行"的任务 | ⚠️ 核心原则 |
| HR-25 | **禁止项目放在 ~/Desktop 以外的目录** - 所有 iOS 项目必须放在 `~/Desktop/ios-{AppName}/` 目录下 | §5.1 |
| HR-26 | **禁止向 Human 提问** - Agent 输出提案后等待 Human 审核，**禁止**发送任何问题（如"请告诉我..."、"你需要告诉我..."） | ⚠️ 核心原则 |
| HR-27 | **禁止输出未完成的提案** - 提案必须包含所有章节的具体内容，**禁止**写"待定"、"[填写...]"、"[Agent 决定]" 等占位符 | ⚠️ Stage -1 |
| HR-28 | **禁止不调研就提案** - **必须先 WebSearch 调研最新 iOS App 趋势、科技方向、市场机会**，基于调研结果提案，禁止基于旧知识随意提案。**必须引用 `2026-2028-iOS-App-Up.md` 参考文档** | ⚠️ Stage -1 |
| HR-29 | **禁止沉默执行** - 执行时间较长的任务（预计 5 分钟以上），**必须每隔 5-10 分钟主动向 Human 汇报进度和当前状态**，任务完成后也必须主动告知。禁止长时间静默，让 Human 不知道任务进展 | ⚠️ 核心原则 |
HR-30 | **禁止违反 Bundle Identifier 命名规范** - 所有 iOS 项目必须严格遵循逆域名惯例和组织标识符（`com.ggsheng.{AppName}` 或 `group.com.ggsheng.{AppName}`），**禁止使用其他前缀**（如 `com.vitamind.*`、`com.example.*`），**禁止跳过此规则检查**，违者视为严重违规 | §1.2.1 |
| HR-31 | **禁止 Display Name 修改后遗漏 UI 硬编码字符串** - Display Name 变更时必须全局搜索所有 `Text("OldName")`、`.navigationTitle("OldName")` 等用户可见字符串，确保 UI 显示正确的名称 | §1.2.2 |
| HR-32 | **禁止在 UI 中使用内部代码名称** - Swift struct/class 名称（如 `<AppInternalName>`）是内部名称，**禁止**出现在任何 `Text()`、`.navigationTitle()`、Label 等用户可见的位置 | §1.2.2 |
| HR-33 | **禁止代码变更后跳过 App Store 材料更新**（**每次代码变更都必须执行，无例外**）- 任何代码或功能变更后，**必须**同步更新所有提交所需的材料：截图、App Store 元数据（描述、关键词、版本说明）、隐私政策、FeatureList 等 | §7.5 |
| HR-56 | **禁止前台不实现 `willPresent` delegate** — 前台通知 banner 必须显式返回 `[.banner, .sound]`，否则用户感知不到 | §8.16.1 |
| HR-57 | **禁止 App.init() 同步请求通知权限** — 必须放在 `.task` 修饰符里异步调用，避免 @StateObject 竞态 | §8.16.3 |
| HR-58 | **禁止远程推送假装本地通知** — 如果用本地通知就别用 `aps-environment`，反之亦然 | §8.16 |
| HR-59 | **禁止用 Debug build 截 App Store 截图** — 必须用 `xcodebuild test -configuration Release` | §8.17.1 |
| HR-60 | **禁止 iPad screenshot test 用 swipe 切 tab** — iPad .tabViewStyle(.automatic) 是 page-style，必须用 launch env 注入初始 tab | §8.17.2 |
| HR-61 | **禁止首启用 mock 健康数据** — 步数/心率/睡眠等真实数据不能用 fake 数字凑首屏 | §8.18.1 |
| HR-62 | **禁止用 emoji 装的假 AI 回复** — AI 失败时必须返回明确的"unavailable"消息 | §8.18.3 |
| HR-63 | **禁止直接 ffmpeg 转 GIF 不调色板** — 必须用 `palettegen` + `paletteuse` 两步法，5-10x 压缩比 | §8.19.3 |
| HR-64 | **禁止用 SIGTERM/SIGKILL 停 recordVideo** — 必须 SIGINT 让 mp4 header 写完 | §8.19.4 |
| HR-65 | **禁止 `xcodebuild test` 整跑** — 调试期间必须 `-only-testing:` 限定到具体 test | §8.20.1 |
| HR-66 | **禁止 UI test 跑前不重置 simulator** — 必须 `simctl shutdown + erase + boot` 三步 | §8.20.2 |
| HR-67 | **禁止沉默不报** — 每天 0-15 分钟内必须主动推送昨日工作汇报 + 今日计划 | §8.21.1 |
| HR-68 | **禁止任务完成 5 分钟后仍不报** — 任务成功/失败都必须立即附证据汇报 | §8.21.2 |
| HR-69 | **禁止新坑当日不沉淀** — 跨项目通用 / 容易重复踩的新经验，必须在当日内写入 SOP + MEMORY.md | §8.21.3 |
| HR-70 | **禁止一个 commit 堆多类变更** — 每个逻辑独立变更一个 commit | §8.21.4 |
| HR-71 | **禁止 App 项目文件散落 workspace 根目录** — App 专属文件必须放在 `~/Desktop/ios-{AppName}/` 仓库内 | §8.21.5 |
| HR-72 | **禁止 SOP 与某个具体 App 绑死** — SOP 是通用 App 制作规范，举例引用具体 App (如 VitaPocket) 时应**适量** (≤3 处)，不写项目特有路径 / 私有 commit hash / 具体产品决策作规则 | §8.21.6 |
| HR-73 | **禁止跳过 Top-5 关键环节提交 App** — 5 环中任一未过，提交后被拒代价远大于提交前多走 1 天检查 | §9.0 |
| HR-74 | **禁止 5 环用项目专用命令绑死** — 检测命令必须用 `<AppName>` / `<BundleID>` 占位符，新项目接手能直接复用 | §9.0 |
| HR-75 | **禁止 SOP 引用项目时不附 git 仓库地址** — 任何项目名（VitaPocket 等）出现在 SOP 正文，必须在同一行 / 同一 blockquote / 同一 table 单元格内附 `<项目名> ([https://github.com/...](https://github.com/...))` 形式 | §9.0 / Appendix G |
| HR-76 | **禁止项目命名三层映射无明确定义** — 任何新项目 / 重命名项目必须在 `project.yml` 顶部补上三层映射表块 (Display / xcodeproj / repo / folder / Bundle ID / Swift class 6 项) | §1.2.3 |
| HR-77 | **禁止改 Bundle ID (已上架项目)** — App Store 已上架项目的 Bundle ID 是 "0 改 = 重新发布" 的不可变标识，改了 = 丢所有用户 / 排名 / 推送 token | §1.2.3 |
| HR-78 | **禁止 xcodeproj / scheme / target / class name 改名后未 grep 验证** — 改内部名后必须 `grep -r "<old_name>" Sources/` 输出空 | §1.2.3 |
| HR-79 | **禁止 App Store Connect URL 填入前不验证 200** — 4 个 URL (Privacy / Terms / Developer Website / Support) 必测 `curl -I` 返回 200，提交后审核员点击 404 会被拒 | §8.4.3 |
| HR-80 | **禁止 GitHub Pages URL 误用 source path 前缀** — "Project Pages" mode (source=main/docs) 将 docs/ 作为 repo URL 根，URL 中不要带 `/docs/` 前缀 | §8.4.3 坑 2 |
| HR-81 | **禁止 repo rename 后不检查 GitHub Pages 状态** — rename 不自动迁移 Pages 配置，必须 POST `/pages` 重新启用 | §8.4.3 坑 1 |

### ✅ Self-Check 清单 - Agent 执行前必须逐项确认

| 检查项 | 执行时机 | 依据锚点 |
|--------|---------|---------|
| SC-01 | **Capabilities 配置完整性** - 检查每个 Capability 是否已正确配置 | §8.21 |
| SC-02 | **隐私政策和服务条款 HTML 有效性** - 部署前检查 PrivacyPolicy.html 和 TermsOfService.html 文件存在且可访问 | §8.4 |
| SC-03 | **Tab identifier 已添加** - 每个 Tab 必须有唯一 accessibilityIdentifier | §6.3 |
| SC-04 | **图标 19 个尺寸已生成** - AppIcon 包含所有必需尺寸 | §4.5 |
| SC-05 | **ITSAppUsesNonExemptEncryption = NO** - Info.plist 必须预配置 | §8.4 |
| SC-06 | **功能完整性自检（≥3 次）** - 每次代码变更后必须自动执行功能完整性审查 | §6.11 |
| SC-07 | **截图尺寸合规性** - 上传前验证所有截图尺寸符合 Apple 规范 | §6.1 |
| SC-09 | **App 功能数量 ≥60 个** - FeatureList 必须达到最低功能数量要求 | §1.4 |
| SC-10 | **内购产品 ID 配置正确** - IAP 产品 ID 与 App Store Connect 一致 | §8.7 |
| SC-11 | **Sign in with Apple 完整实现**（如适用）- 必须包含完整实现 | §8.19 |
| SC-12 | **深色模式支持** - App 必须支持 Dark Mode | §8.14 |
| SC-13 | **截图真实性验证** - 确认所有截图来自真实模拟器且内容不同（MD5+Human确认） | §6.0 |
| SC-15 | **Human 审核确认** - 确认 Human 已审核通过设计/UI/隐私政策/图标 | §Stage 0 / §8.4 |
| SC-16 | **功能实现验证** - 确认所有功能真实可用，非占位符/空壳 | §8.6 |
| SC-17 | **配置完整性验证** - 确认 project.yml/Info.plist/Entitlements 已正确配置 | §3 / §4 |
| SC-18 | **构建产物验证** - 确认 Archive 构建真实成功（本地验证） | §8.1 | §8.1 |
| SC-19 | **功能数量验证** - 确认 FeatureList 功能数量 ≥60 个 | §1.4 |
| SC-20 | **执行日志完整性** - 确认关键步骤已记录执行日志 | ⚠️ 违规处罚机制 |
| SC-21 | **无 TODO/占位符** - 确认代码中无未完成的 TODO/FIXME/HACK 标记 | §8.6 |
| SC-22 | **边界情况处理** - 确认所有异常场景已处理（空数据、网络错误、权限拒绝） | §8.6 |
| SC-23 | **测试覆盖率** - 确认测试覆盖正常流程 + 边界情况 + 异常场景 | §6.7 / §6.8 |
| SC-24 | **代码审查执行** - 确认每次代码变更后已执行 Claude Code 审查 | §6.11 |
| SC-25 | **功能审查次数** - 确认功能完整性自检已执行 ≥3 次 | §6.11 |
| SC-26 | **UI 适配完整性** - 确认 Light/Dark Mode、设备尺寸、横竖屏已适配 | §8.14 |
| SC-27 | **无障碍功能** - 确认 accessibilityIdentifier、VoiceOver 已实现 | §8.15 |
| SC-28 | **性能指标达标** - 确认启动时间 <5 秒、内存合理、包体积 <150MB | §8.13 |
| SC-29 | **隐私政策定制** - 确认隐私政策根据 App 实际功能定制，非模板 | §8.4 |
| SC-30 | **无推诿行为** - 确认 Agent 未将分内工作（文件查找/执行确认/路径询问等）推给 Human | HR-24 |
| **SC-31** | **AppIcon UI 加载验证** - 启动 App → 进入 About 页面 → 截图 vision 确认显示的是真实发行图标，不是占位符。检查 bundle 根存在 `AppIcon60x60@2x.png` 等文件 | §4.5.1 / HR-46 |
| **SC-32** | **法律文档内嵌验证** - ① bundle 根含 `PrivacyPolicy.html` + `TermsOfService.html` ② 飞行模式/脱机下仍能打开 ③ 项目使用 `NavigationLink` 跳 `LegalDocumentView`（不是 `Link` 外链） | §8.4.2 / HR-45 |
| **SC-33** | **联系邮箱规范性验证** - ① `PrivacyPolicy.html` 中含 `privacy@techidaily.com` 且不含 `support@` ② `TermsOfService.html` 中含 `legal@techidaily.com` 且不含 `support@` ③ App Store Connect Contact Email 填 `support@techidaily.com` | §8.4.0 / HR-47 |
| **SC-60** | **URL 与邮箱域名解耦验证** - App Store Connect 所有填入的 URL (Privacy Policy / Terms of Service / Developer Website / Support) 100% 必是 `lauer3912.github.io/...` (GitHub Pages)，0 个是 `techidaily.com/...` 域名。邮箱跟 URL 用不同域名不算错，反而是正确分层 | §8.4 / HR-35 |
| **SC-42** | **本地通知端到端测试** — 启动 App → 允许通知 → 验证 Settings 状态从 "Permission not yet asked" 变为 "On — 3 daily reminders" | §8.16.1 |
| **SC-43** | **前台 banner 可见性** — 启动 App 到任何 tab，点"Send Test Notification"按钮，1 秒后**当前屏幕顶部必须出现 banner** | §8.16.1 |
| **SC-44** | **Trigger 调度验证** — 跑 `UNUserNotificationCenter.pendingNotificationRequests()` 确认 3 个 daily reminder 都已注册 | §8.16.5 |
| **SC-45** | **截图 Configuration 一致性** — 截 App Store 截图时验证 build Info.plist 与 archive 的 Info.plist 一致 (Bundle ID / Display Name / Version) | §8.17.1 |
| **SC-46** | **iPad 截屏独立性** — iPad screenshot test 跑 N 次 (N=tab 数) 独立 App 启动，每次通过 launch env 选 tab | §8.17.2 |
| **SC-47** | **Mock 数据全仓搜索** — App Store 提交前 grep 全工程 `Mock\|mock\|fake\|stub\|placeholder` 确认无遗漏 | §8.18.1 |
| **SC-48** | **首启真机验证** — 卸载 App → 重装 → 截首屏 → vision 确认无任何假数字 | §8.18.1 |
| **SC-49** | **cliclick Accessibility 权限预检** — 首次使用前确认 macOS 辅助功能已授权当前 Terminal/iTerm | §8.19.2 |
| **SC-50** | **GIF 文件大小检查** — 转出 GIF 必须 <3MB (18s 内)，超了说明没用 palettegen | §8.19.3 |
| **SC-51** | **Test 卡死诊断步骤** — 超过 5 分钟无输出立即 kill -9，simctl shutdown all 重启，再单独重跑失败的 test | §8.20.3 |
| **SC-52** | **每日汇报完整性** — 检查当日 `memory/YYYY-MM-DD.md` 或早 8 点消息是否含昨日完成 / 进行中 / 问题 / 今日计划 4 块 | §8.21.1 |
| **SC-53** | **新坑当日沉淀** — 踩到新坑后 24 小时内，SOP 必须新增对应 §X.Y 节 + HR + SC | §8.21.3 |
| **SC-54** | **workspace 整洁度** — `ls ~/.openclaw/workspace/` 不应含 App 项目专属文件 | §8.21.5 |
| **SC-55** | **App 引用适度性** — `grep -c "VitaPocket" docs/SOP-iOS-Local-Development.md` ≤ 20 且集中在：① F.8 历史 ② Appendix F 内部 ③ 实战举例 (≤3 处) | §8.21.6 |
| **SC-56** | **提交前 5 环验证** — 5 个检测命令必须全部 pass：① `grep -rn "Mock\|mock"` 输出空 ② Release 截图 Info.plist 与 archive 一致 ③ 通知 banner 视觉可见 ④ `curl -I` 隐私 URL 返回 200 ⑤ `xcodebuild test -only-testing` 完成且 0 失败 | §9.0 |
| **SC-57** | **项目引用 git URL 完整性** — `grep "VitaPocket\|ios-VitaMind" docs/SOP-iOS-Local-Development.md` 出现的每一处，100 米字符内必须出现 `github.com/...` 链接 | Appendix G |
| **SC-58** | **项目命名三层一致性自检** — 跑 `scripts/naming-check.sh` 5 项输出匹配项目记录的三层映射表 | §1.2.3 |
| **SC-59** | **Bundle ID 不可变验证** — 上架后项目 `git log --all -- project.yml` 不应出现 `PRODUCT_BUNDLE_IDENTIFIER` 变更 (除非同一个项目下在调为不同 app) | §1.2.3 |

---

### 8.19 模拟器自动化辅助工具（必读 — 2026-06-03 经验沉淀）

>
>
>
> **【强制】XCUITest 抓不到的东西（iOS 系统弹窗、system gesture、屏幕精确点击）必须用辅助工具，不要硬碰 XCUITest**

#### 8.19.1 工具箱总览

| 工具 | 用途 | 安装 |
|---|---|---|
| `cliclick` | macOS 屏幕坐标点击（高权限时能用） | `brew install cliclick` |
| `xcrun simctl io ... screenshot` | 截模拟器当前帧 | Xcode 自带 |
| `xcrun simctl io ... recordVideo` | 录模拟器屏幕 → mp4 | Xcode 自带 |
| `ffmpeg + palettegen + paletteuse` | mp4 → 高质量 GIF | `brew install ffmpeg` |
| `xcrun simctl push` | 推 mock APNS 通知 banner | Xcode 自带 |
| `osascript` | AppleScript 调起 Simulator 窗口焦点 | macOS 自带 |

#### 8.19.2 cliclick 坐标换算公式

**问题**：cliclick 用 macOS 屏幕物理坐标，模拟器里 iOS 屏幕是按比例缩放渲染在窗口里。

**公式**（以 iPhone 17 Pro Max @3x 1320×2868 为例）：

```python
# Simulator 窗口在 macOS 屏幕的位置
win_x, win_y = 39, 50      # 来自 osascript "position of window 1"
win_w, win_h = 451, 967     # 来自 osascript "size of window 1"
title_bar = 28              # macOS 窗口标题栏高度

# iOS 截图尺寸 (iPhone 17 Pro Max @3x)
ios_w, ios_h = 1320, 2868

# iOS 屏幕在窗口内可用区域
screen_w = win_w
screen_h = win_h - title_bar

# 缩放比例
sx = screen_w / ios_w
sy = screen_h / ios_h

# 转换函数: iOS logical points (iOS coordinate) → macOS click
def ios_to_mac(ios_x, ios_y):
    mac_x = int(win_x + ios_x * sx)
    mac_y = int(win_y + title_bar + ios_y * sy)
    return mac_x, mac_y
```

**使用示例**（点 iOS 通知弹窗的 Allow 按钮）：

```bash
# iOS Allow 按钮约在 iOS (950, 1295) 位置
cliclick c:354,478
```

> ⚠️ **【强制】cliclick 需要 macOS Accessibility 权限**。首次运行会跳系统设置；申请后必须重新打开 Terminal/iTerm 才能生效。

#### 8.19.3 ffmpeg GIF 制作（两步法，5-10x 压缩比）

**问题**：直接 `ffmpeg -i in.mp4 out.gif` 出来的 GIF 几十 MB。

**正确做法**：先生成调色板，再应用。

```bash
# Step 1: 从原视频生成 256 色调色板
ffmpeg -ss 12 -t 18 -i /tmp/demo.mp4 \
  -vf "fps=10,scale=420:-1:flags=lanczos,palettegen=stats_mode=full" \
  /tmp/palette.png

# Step 2: 应用调色板 + Bayer 抖动
ffmpeg -ss 12 -t 18 -i /tmp/demo.mp4 -i /tmp/palette.png \
  -filter_complex "fps=10,scale=420:-1:flags=lanczos,paletteuse=dither=bayer:bayer_scale=5" \
  -loop 0 out.gif
```

**参数速查**：
| 参数 | 含义 | 推荐值 |
|---|---|---|
| `-ss 12` | 起始时间（秒） | 跳过前 12s 模拟器启动 / 弹窗准备 |
| `-t 18` | 持续时间（秒） | 18-20s 适合演示 |
| `fps=10` | 输出帧率 | 10-15 fps 对眼睛足够 |
| `scale=420:-1` | 宽度 420px，高度按比例 | 400-500px 适合手机查看 |
| `bayer_scale=5` | 抖动强度 | 3-5（5 颜色最准） |
| `-loop 0` | 无限循环 | GIF 演示必备 |

**预期大小**：18s 演示 GIF 在 1.5-2.5 MB 之间（vs 直接转码 30+ MB）。

#### 8.19.4 simctl 录屏 + 时间轴裁剪

**录屏**（在后台跑，PID 可 kill）：

```bash
xcrun simctl io <device> recordVideo --codec h264 --force /tmp/demo.mp4 &
RECORD_PID=$!
# 跑 UI test / simctl push 触发流程
xcodebuild test -only-testing:...
# 停录屏（必须 SIGINT 让 mp4 完整写入）
kill -INT $RECORD_PID
sleep 2
```

> ⚠️ **【强制】必须 SIGINT 不能 SIGTERM/SIGKILL**——SIGINT 让 recordVideo 写完 mp4 header，否则 mp4 无法播放。

**时间轴扫描**（找 banner 出现位置）：

```bash
for t in 10 15 20 25 30; do
  ffmpeg -y -ss $t -i /tmp/demo.mp4 -frames:v 1 -loglevel error /tmp/scan-$t.png
done
# vision 看每张找 banner 出现的精确时间
```

#### 8.19.5 HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-63** | **禁止直接 ffmpeg 转 GIF 不调色板** — 必须用 `palettegen` + `paletteuse` 两步法，5-10x 压缩比 | §8.19.3 |
| **HR-64** | **禁止用 SIGTERM/SIGKILL 停 recordVideo** — 必须 SIGINT 让 mp4 header 写完 | §8.19.4 |
| **SC-49** | **cliclick Accessibility 权限预检** — 首次使用前确认 macOS 偏好设置 → 隐私与安全 → 辅助功能 已授权当前 Terminal/iTerm | §8.19.2 |
| **SC-50** | **GIF 文件大小检查** — 转出 GIF 必须 <3MB (18s 内)，超了说明没用 palettegen 或 fps/scale 没调好 | §8.19.3 |

---

### 8.20 XCUITest 性能与稳定性策略（必读 — 2026-06-03 经验沉淀）

> **【强制】`xcodebuild test` 整跑容易卡 5+ 分钟甚至 SIGKILL，必须用 `-only-testing` 单跑，并按 simulator 重置周期分批**

#### 8.20.1 整跑 vs 单跑

**错误**：

```bash
# 整跑所有 test target - 容易卡死，调试粒度粗
xcodebuild test -project ... -scheme ... 2>&1 | tail
```

**正确**：

```bash
# 单跑单元测试 (19 个 < 5 秒)
xcodebuild test -only-testing:<AppName>Tests

# 单跑某个 UI test class
xcodebuild test -only-testing:<AppName>UITests/<AppName>InteractionTests

# 单跑某个 test method
xcodebuild test -only-testing:<AppName>UITests/AppStoreScreenshotTests/testCaptureAllTabsDarkMode
```

#### 8.20.2 Simulator 状态污染与重置

**症状**：UI test 偶尔失败但单独跑又过，原因是前一次 UI test 留下了：
- 通知权限已确定
- HealthKit 已授权
- UserDefaults 持久化数据
- springboard alert 仍在显示

**修复**：跑 UI test 前先 `simctl erase`：

```bash
xcrun simctl shutdown <device>
xcrun simctl erase <device>
xcrun simctl boot <device>
sleep 3
# 再跑 test
```

#### 8.20.3 `xcodebuild test` 卡死的诊断

**症状**：test 跑了 5+ 分钟没输出，log 为空。

**诊断**：
```bash
# 看进程是否还在跑
ps aux | grep xcodebuild | grep -v grep

# 看 simulator 状态
xcrun simctl list devices booted
```

**修复**：
1. `kill -9 <xcodebuild pid>` 杀掉
2. `xcrun simctl shutdown all` 重启所有模拟器
3. 重跑（多数情况是 simulator 状态被搞坏）
4. 实在不行 `xcrun simctl erase <device>`

#### 8.20.4 HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-65** | **禁止 `xcodebuild test` 整跑** — 调试期间必须 `-only-testing:` 限定到具体 test target / class / method | §8.20.1 |
| **HR-66** | **禁止 UI test 跑前不重置 simulator** — 必须 `simctl shutdown + erase + boot` 三步 | §8.20.2 |
| **SC-51** | **Test 卡死诊断步骤** — 超过 5 分钟无输出立即 kill -9，simctl shutdown all 重启，再单独重跑失败的 test | §8.20.3 |

---

### 8.21 Agent 工作流与 SOP 自我进化（必读 — 2026-06-03 经验沉淀）

> **【强制】Agent 必须遵循"早汇报、立即汇报、当日沉淀"三原则**

#### 8.21.1 早 8 点工作汇报

**触发**：每天 0-15 分钟内，主动向 Human 输出：
- 昨日已完成事项
- 昨日进行中事项
- 昨日遇到的问题
- 今日计划

**禁止**：
- 沉默不报
- 等 Human 问"今天做什么"
- 报告里写"无进展"敷衍

**必跑自检 (在 4 块报告之前)**：

```bash
# SOP §8.22 字段完整性 (21 项) - 上架前最后一道关
./scripts/sop-822-check.sh

# workspace 零图片 (HR-88 + SC-70 生效中)
ls ~/.openclaw/workspace/*.png 2>/dev/null | wc -l  # 期望 0
```

若 `sop-822-check.sh` exit code ≠ 0 (有失败项)，**先报告失败详情 + 修复计划，再进入 4 块报告**。这是面向"每天上架质量连续不低头"的机制。

#### 8.21.2 任务完成立即汇报

**触发**：每个任务完成（含成功 / 失败），**必须**立即汇报：
- 任务名 + 状态
- 关键证据（build hash / commit hash / test pass count / screenshot path）
- 下一步建议

**禁止**：
- 任务完成后 5 分钟内仍不报
- 只说"做完了"不附证据

#### 8.21.3 当日沉淀到 SOP

**触发**：当天踩到任何 **新坑**（不是已知规则的重复），**必须**在当日内：
1. 写入 SOP（带日期标注 + HR / SC 编号）
2. 写入 MEMORY.md（如果跨项目通用）
3. push 到 workspace 仓库（如适用）

**判断标准**：
- ✅ 应该写：跨项目通用 / 容易重复踩 / 有具体代码或命令解决方案
- ❌ 不必写：一次性的偶发错误 / 与项目代码紧绑的局部修复

**模板**（每个新 §X.Y 节末尾 HR + SC 表）：

```markdown
#### 8.X.Y HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-NN** | **禁止...** — 简明负面陈述 | §8.X.Y |
| **SC-NN** | **...验证** — 自动化检查方法 | §8.X.Y |
```

#### 8.21.4 一次性 Git 提交习惯

**禁止**：
- 一堆无关变更堆在一个 commit
- commit message 写 "update" / "fix" / "WIP"

**强制**：
- 每个逻辑独立的变更一个 commit
- commit message 模板：
  ```
  <type>: <summary>
  
  <body explaining what + why>
  ```
- type: `feat` / `fix` / `chore` / `docs` / `test` / `refactor`
- 用 `git commit -F - <<EOF ... EOF` 避免 zsh 多行引号陷阱

#### 8.21.5 workspace 文件组织

**问题**：项目 demo / 调试文件曾散落在 `~/.openclaw/workspace/` 根目录，与 App 项目混杂。

**原则**：
- **App 项目专属文件**（截图、demo 素材、build artifacts）→ 放进 `~/Desktop/ios-{AppName}/` 仓库内
- **Agent 通用 workspace**（MEMORY.md、SOUL.md、跨项目 SOP）→ `~/.openclaw/workspace/`
- **临时文件**（中间过程产物）→ `/tmp/`

#### 8.21.6 HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-67** | **禁止沉默不报** — 每天 0-15 分钟内必须主动推送昨日工作汇报 + 今日计划 | §8.21.1 |
| **HR-68** | **禁止任务完成 5 分钟后仍不报** — 任务成功/失败都必须立即附证据汇报 | §8.21.2 |
| **HR-69** | **禁止新坑当日不沉淀** — 跨项目通用 / 容易重复踩的新经验，必须在当日内写入 SOP + MEMORY.md | §8.21.3 |
| **HR-70** | **禁止一个 commit 堆多类变更** — 每个逻辑独立变更一个 commit | §8.21.4 |
| **HR-71** | **禁止 App 项目文件散落 workspace 根目录** — App 专属文件必须放在 `~/Desktop/ios-{AppName}/` 仓库内 | §8.21.5 |
| **SC-52** | **每日汇报完整性** — 检查当日 `memory/YYYY-MM-DD.md` 或早 8 点消息是否含昨日完成 / 进行中 / 问题 / 今日计划 4 块 | §8.21.1 |
| **SC-53** | **新坑当日沉淀** — 踩到新坑后 24 小时内，SOP 必须新增对应 §X.Y 节 + HR + SC | §8.21.3 |
| **SC-54** | **workspace 整洁度** — `ls ~/.openclaw/workspace/` 不应含 App 项目专属文件 | §8.21.5 |
| **SC-55** | **App 引用适度性** — `grep -c "VitaPocket" docs/SOP-iOS-Local-Development.md` ≤ 20 且集中在：① F.8 历史 ② Appendix F 内部 ③ 实战举例 (≤3 处) | §8.21.6 |
| **SC-56** | **提交前 5 环验证** — 5 个检测命令必须全部 pass：① `grep -rn "Mock\|mock"` 输出空 ② Release 截图 Info.plist 与 archive 一致 ③ 通知 banner 视觉可见 ④ `curl -I` 隐私 URL 返回 200 ⑤ `xcodebuild test -only-testing` 完成且 0 失败 | §9.0 |
| **SC-57** | **项目引用 git URL 完整性** — `grep "VitaPocket\|ios-VitaMind" docs/SOP-iOS-Local-Development.md` 出现的每一处，100 米字符内必须出现 `github.com/...` 链接 | Appendix G |
| **SC-58** | **项目命名三层一致性自检** — 跑 `scripts/naming-check.sh` 5 项输出匹配项目记录的三层映射表 | §1.2.3 |
| **SC-59** | **Bundle ID 不可变验证** — 上架后项目 `git log --all -- project.yml` 不应出现 `PRODUCT_BUNDLE_IDENTIFIER` 变更 (除非同一个项目下在调为不同 app) | §1.2.3 |



---

### 8.22 App Store 元数据完整化（必读 — 2026-06-04 经验沉淀）

> 🎯 **本节场景**: 当 Agent 需要在 `AppStore/Listing.md` 提供 App Store Connect 提交所需的全部字段时，**不是只有描述类字段** (Name/Description/Keywords)，还有 6 个必填的"技术性"字段经常被遗漏，导致提交被驳回。

#### 8.22.1 完整字段清单（6 个易遗漏字段）

| # | 字段 | Apple 位置 | 误填后果 | 本项目答案 |
|---|------|------------|----------|------------|
| 1 | **Support URL** | App Information | 审核驳回 | `https://{user}.github.io/ios-{AppName}/` |
| 2 | **Copyright** | App Information | 显示为 "© 2026" 无 Owner | `YYYY {AppName}` 格式 (Apple 自动加 ©) |
| 3 | **App Review Notes** | App Review Information | 审核不清楚使用场景 | 4000 bytes 说明 HealthKit / API Key / 订阅 / 医疗定位 |
| 4 | **Regulated Medical Device** | App Review Information | 被分类为医疗器械 | HealthKit Lifestyle App 选 **No** + 补充 "wellness" 定位说明 |
| 5 | **App Store Server Notifications** | App Information (IAP) | IAP 事件丢失 | **N/A** (无 IAP 时)；加 IAP 后需配 Production + Sandbox 两个 URL |
| 6 | **App Encryption** | App Review Information | 需 CCATS 走 BIS 审批 | HTTPS-only 选 **Yes + Yes** (BIS Cat 5 Pt 2 Note 4 豁免) |

#### 8.22.2 Regulated Medical Device 决策树

```
App 是否在读取 HealthKit / HealthKit-related 数据?
  ├─ No → 选 No，不需补充
  └─ Yes → 是否提供医学诊断 / 治疗 / 预防 / 处方?
            ├─ Yes → 需 FDA / 各国医疗监管审批 → 选 Yes
            └─ No  → 是否仅 lifestyle / wellness 数据?
                      ├─ Yes → 选 No，Notes 中明说 "lifestyle and general wellness use only"
                      └─ No  → 选 No 但需补充详细说明
```

VitaMindGo 路径: **HealthKit + No medical claim → 选 No**，Notes 写明 "informational/lifestyle data, NOT medical advice"。

#### 8.22.3 App Encryption 决策树

```
App 使用 URLSession / HTTPS / Apple 标准框架 (HealthKit, CoreML, CloudKit)?
  ├─ Yes → 选 "Yes, uses cryptography" + "Yes, exempt" (BIS Cat 5 Pt 2 Note 4)
  │        需: Info.plist 加 `ITSAppUsesNonExemptEncryption = false`
  │        需: 每年 2/1 前向 BIS 提交 self-classification report
  └─ No  → 选 "No"
```

**重要**: 绝大多数 App 都是 HTTPS-only，**不要默认选 No**！选错会被 Apple 要求补交 CCATS。

#### 8.22.4 App Store Server Notifications 决策树

```
App 有 IAP / Auto-Renewable Subscription?
  ├─ No  → 字段留空 (N/A)
  └─ Yes → 需配置 2 个 URL:
           - Production URL: 实际生产环境 (HTTPS only)
           - Sandbox URL: 测试环境 (Apple 审核用)
           - 需实现 JWT 验签 (从 App Store 拉公钥)
           - 需实现事件路由 (INITIAL_BUY / DID_RENEW / EXPIRED / REFUND ...)
```

#### 8.22.5 Listing.md 标准结构模板

```
## 1. App Name & Tagline
## 2. Promotional Text (≤170 chars)
## 3. Description (≤4000 chars, plain text)
## 4. Keywords (≤100 bytes)
## 5. Support URL          ← 必填
## 5A. Copyright            ← 必填
## 6. Privacy Policy URL
## 7. Category
## 8. Content Rating
## 9. Screenshots
## 10. App Review Information
##   10.1 Contact Info
##   10.2 Sign-in Required
##   10.3 Notes for Reviewer
##   10.4 Regulated Medical Device
##   10.5 App Encryption
##   10.6 App Store Server Notifications
##   10.7 字段填写汇总表
## 11. App Store Connect Metadata
## 12. 上架前检查清单
```

#### 8.22.6 HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-82** | **禁止遗漏 App Review 字段** — App Store Connect 提交前，Listing.md 必含 §10.1-10.6 全 6 个子节 (Contact/Sign-in/Notes/Medical Device/Encryption/Server Notifications) | §8.22.1 |
| **HR-83** | **禁止 Copyright 重复 © 符号** — 字段内容是 `YYYY Owner`，**不**加 `©` 或 `(c)`，Apple 会自动加 | §8.22.1 |
| **HR-84** | **禁止 Regulated Medical Device 默认 Yes** — HealthKit Lifestyle App 默认选 No，但 Notes 中必含 "lifestyle and general wellness use only" 措辞 | §8.22.2 |
| **HR-85** | **禁止 App Encryption 默认 No** — HTTPS/TLS 加密的 App 必选 Yes+Yes (exempt)，选错会被要求补交 CCATS (BIS 审批，8-12 周) | §8.22.3 |
| **HR-86** | **禁止 App Store Server Notifications 留 URL 但不实现** — 若填入 URL，必须实现 JWT 验签 + 事件路由；否则留空 | §8.22.4 |
| **SC-65** | **Listing.md 6 字段完整性** — `grep -E "^## (5\|10\.)" AppStore/Listing.md` 输出含: §5 Support, §5A Copyright, §10.1-10.6 全 6 个 App Review 子节 | §8.22.5 |
| **SC-66** | **Copyright 格式检查** — `grep -E "^## 5A\." -A 4 AppStore/Listing.md` 显示 `YYYY OwnerName` 格式，无 `©` / `(c)` 字符 | §8.22.1 |
| **SC-67** | **Regulated Medical Device 措辞检查** — Listing.md §10.4 必含 "lifestyle" 或 "wellness" 关键词，且声明 "NOT a medical device" | §8.22.2 |
| **SC-68** | **App Encryption 措辞检查** — Listing.md §10.5 必含 "HTTPS" / "TLS" / "Category 5" 关键词，且 "Yes, exempt" 两项齐全 | §8.22.3 |
| **SC-69** | **App Store Server Notifications 状态检查** — 若无 IAP，§10.6 必含 "N/A" 或 "v3.0.0 无 IAP" 说明，不留空 URL | §8.22.4 |
| **HR-87** | **禁止新增 HR/SC 规则不复查编号** — 添加新规则前必跑 `grep -oE '\*\*HR-[0-9]+\*\*\|\\*\\*SC-[0-9]+\\*\\*' docs/SOP-iOS-Local-Development.md | sort -t- -k2 -n -u | tail -2` 查现有最大编号，新规则从 +1 起。防止 §8.22 首次添加 HR-72~76 与 §8.21.6 冲突的二次重编号错误 | §8.22 |
| **HR-88** | **禁止截图/临时图片文件污染 workspace 根** — `simctl io screenshot` / `xcodebuild test` / 调试截图保存时必须指定绝对路径到项目仓库内 `~/Desktop/ios-{AppName}/` 或 `~/tmp/`，**不**保存到 workspace cwd。`xcrun simctl io booted screenshot foo.png` 这种 "隐含 cwd" 命令在 workspace 目录里跑会污染根 | §8.22.7 |
| **SC-70** | **workspace 根目录零图片文件** — `ls ~/.openclaw/workspace/*.png 2>/dev/null \| wc -l` 输出必须为 0。违例 1 个即触发。例外: `screenshots/` 与 `docs/` 子目录内合法 | §8.22.7 |
| **SC-71** | **早 8 点汇报前必跑 sop-822-check.sh** — 早 8 点汇报发送前必先 `./scripts/sop-822-check.sh` 跑过且 exit 0。exit 0 才进入 4 块报告。exit 1 先报告失败详情 + 修复计划。**可定制**: 脚本路径可通过 `WORKSPACE=/path PROJECT=/path ./scripts/sop-822-check.sh` 传参 | §8.21.1 |

#### 8.22.7 workspace 根目录图片污染防护 (2026-06-04 经验沉淀)

> 🐛 **本节场景**: Agent 用 `simctl io screenshot` / `xcodebuild test-without-building` / 调试截图保存到 cwd 时，若 cwd 是 `~/.openclaw/workspace`，文件会落入 workspace 根目录。某次 v3.0.0 上架前 QA 流程后堆积 90 个 PNG / 40.89 MB。

**正确命令模板**:

```bash
# ✅ 错 — 隐含 cwd，会污染 workspace 根
cd ~/.openclaw/workspace && xcrun simctl io booted screenshot pocket.png

# ✅ 对 — 显式绝对路径到项目仓库
xcrun simctl io booted screenshot ~/Desktop/ios-VitaMind/AppStore/Screenshots/_tmp/pocket.png

# ✅ 对 — 写到 /tmp (会话级临时)
xcrun simctl io booted screenshot /tmp/pocket.png

# ✅ 对 — 写入 ~/Downloads/ 便于人工下载
xcrun simctl io booted screenshot ~/Downloads/pocket.png
```

**防护层级** (从外到内):
1. **预防层**: 写截图命令前先 `pwd` 确认 cwd，若在 workspace 立即 `cd` 到项目或 /tmp
2. **检测层**: `.gitignore` 屏蔽 workspace 根的 `/*.png` `/*.jpg` 等
3. **清理层**: 每日 `ls ~/.openclaw/workspace/*.png | wc -l` 应输出 0 (SC-70)
4. **兜底层**: 误生成时 `trash` 删除 (macOS Finder 回收站，可恢复)

**.gitignore 模板** (本项目实测, 已写入 `~/.openclaw/workspace/.gitignore`):
```
/*.png
/*.jpg
/*.jpeg
/*.gif
/*.webp
```

**例外说明**:
- `screenshots/` 子目录: 保留与 daily memory 关联的引用 (例: `memory/2026-06-03.md` 提到的 A1-A3 通知截图)
- `docs/` 子目录: 项目文档插图，不在屏蔽范围



---

## 🚨 违规处罚机制

> ⚠️ **【强制】以下处罚机制适用于所有 AI Agent 执行行为**

### 违规等级定义

| 等级 | 严重程度 | 违规行为示例 | 处罚措施 |
|------|---------|-------------|----------|
| **一级违规** | 轻微 | 章节编号错误、格式问题、拼写错误 | 警告并要求立即修正 |
| **二级违规** | 中等 | 跳过验证步骤（MD5/测试）、未执行完整功能审查、虚报配置完成、功能审查次数不足（<3次）、跳过代码审查、隐私政策用模板 | 要求重新执行该环节，记录违规日志，Human 审查 |
| **三级违规** | 严重 | 伪造截图/测试报告/构建日志、绕过 Human 审核、伪造功能实现（占位符冒充）、用 TODO/简化版冒充完整功能、跳过边界情况处理、跳过 UI 适配（Dark Mode）、跳过无障碍功能、跳过性能优化、**将分内工作推给 Human（HR-24 首次违规）** | **立即停止任务**，Human 全面介入审查，重新执行所有可疑环节 |
| **四级违规** | 极严重 | 故意欺骗、多次重复违规（≥3次）、伪造 Archive 成功、虚报功能数量、系统性偷懒（多个环节同时省略工作） | **终止 Agent 执行权限**，Human 接管项目，记录严重违规档案 |

### 违规判定标准

| 环节 | 判定方法 | 违规标志 |
|------|---------|---------|
| **截图** | MD5 + Human 肉眼确认 | MD5 相同、Human 发现重复/伪造 |
| **测试** | 测试日志 + 测试报告 + 随机抽查 | 无测试日志、测试通过率 100% 但功能异常 |
| **构建** | 构建日志 + 产物验证 | 无构建日志、产物不存在或损坏 |
| **功能实现** | 功能审查 + Human 测试 | 功能为空壳/占位符、按钮无响应 |
| **配置** | 配置文件检查 + 验证命令 | 配置文件为空/错误、验证命令失败 |
| **Human 审核** | 审核记录检查 | 无 Human 审核记录、审核状态为 pending 但继续执行 |
| **代码质量** | TODO/FIXME 扫描 + 代码审查 | 存在未完成的 TODO/FIXME/HACK 标记 |
| **测试覆盖** | 测试用例检查 + 边界情况验证 | 测试只覆盖正常流程，无边界/异常场景测试 |
| **UI 适配** | Dark Mode 测试 + 多设备测试 | 只支持 Light Mode、部分设备尺寸未适配 |
| **性能指标** | 启动时间测试 + 内存监控 + 包体积检查 | 启动时间 >5 秒、包体积 >150MB |
| **推诿行为** | Agent 对话记录审查 + 任务执行跟踪 | Agent 询问"文件在哪里/可以开始吗/确认要执行吗"等 SOP 已明确标注为 Agent 执行的任务 |

### 执行日志要求

> ⚠️ **【强制】Agent 必须维护执行日志，记录所有关键步骤**

Agent 必须在项目 `AppStore/Docs/ExecutionLog.md` 中维护以下日志：

```markdown
# 执行日志

## Stage 0: 设计审核
| 步骤 | 执行时间 | 执行结果 | 验证方式 | Human 审核状态 |
|------|---------|---------|---------|---------------|
| 图标方案生成 | 2026-05-21 10:00 | ✅ 完成 | 1024×1024 PNG | ⏳ 待审核 |
| UI 设计稿生成 | 2026-05-21 10:30 | ✅ 完成 | 设计稿图片 | ⏳ 待审核 |

## Stage 6: 截图
| 步骤 | 执行时间 | 执行结果 | 验证方式 | 备注 |
|------|---------|---------|---------|------|
| iPhone 截图生成 | 2026-05-21 14:00 | ✅ 5 张 | MD5 | MD5 均不同 |
| iPad 截图生成 | 2026-05-21 14:30 | ✅ 5 张 | MD5 | MD5 均不同 |
| Human 确认 | 2026-05-21 15:00 | ✅ 通过 | 肉眼确认 | 所有截图不同页面 |

## Stage 8: 功能实现
| 功能 | 实现状态 | 验证方式 | 备注 |
|------|---------|---------|------|
| 通知功能 | ✅ 完成 | 功能测试 | 推送正常 |
| 相机功能 | ✅ 完成 | 功能测试 | 拍照/相册正常 |
```

> ⚠️ **日志必须真实记录，禁止伪造执行时间或结果**

---

## 🤖 Claude Code 配置（Agent 运行凭证）

> ⚠️ **本文档中的 🤖 AI Agent（Claude Code）需要配置 MiniMax API 才能正常运行**。由于项目未配置 Claude Code 官方授权，因此提供通过 MiniMax API 兼容 Claude Code 的配置方式。

---

## 📑 快速导航 / 目录索引

> ⚠️ **本文档是完整的 SOP，Agent 可使用本目录快速定位到相关章节**

### 🗺️ 阶段总览

| 阶段 | 名称 | 锚点 | 说明 |
|------|------|------|------|
| **Stage 0** | 设计审核 | `#stage-0设计审核必须先完成` | 图标和 UI 方案审核（必须先完成） |
| **Stage 1** | 概念与命名 | `#stage-1概念与命名` | App 名称核查、功能清单、元数据生成 |
| **Stage 2** | 创建项目目录 | `#stage-2创建项目目录文件结构` | 目录/文件结构规范 |
| **Stage 3** | project.yml 配置 | `#stage-3projectyml-完整配置` | XcodeGen 项目配置完整模板 |
| **Stage 4** | 必需文件配置 | `#stage-4必需的文件--infoplist-预配置` | Info.plist、Entitlements、AppIcon |
| **Stage 5** | XcodeGen 生成 | `#stage-5xcodegen-生成项目` | 生成项目、验证 |
| **Stage 6** | 截图制作 | `#stage-6app-store-截图制作` | App Store 截图完整流程 |
| **Stage 6 附加** | 测试与录屏（可选）| `#stage-6-附加测试与录屏可选` | 测试代码、录屏规格 |
| **Stage 7** | Widget/Beta | `#stage-7widget-数据共享--beta-测试` | App Groups 配置、TestFlight |
| **Stage 8** | App Store 上传 | `#stage-8app-store-connect-上传` | Archive、隐私政策、各项功能实现 |
| **Stage 9** | 提交审核 | `#stage-9app-store-connect-填写与提交审核` | App Store Connect 填写与提交 |
| **Stage 10** | 审核被拒处理 | `#stage-10审核被拒处理流程` | 常见被拒原因及应对流程 |

### 🔍 常用功能快速查找

| 功能/主题 | 章节 | 锚点 |
|----------|------|------|
| **Agent 必备 Skills** | 角色分工总览 | `#agent-skills调用方式skill--skill-name` |
| **Skills 使用时机** | 角色分工总览 | `#强制openclaw-agent-skills-使用时机对照表` |
| **Agent/Human 任务分工** | 角色分工总览 | `#-agent-可独立执行的任务汇总` |
| **Archive 操作** | §8.1 | `#81-archive-操作` |
| **故障排查与错误处理** | §5.7 | `#57-故障排查与错误处理指南必读` |
| **GDPR/CCPA 合规** | §8.4.1 | `#84-隐私政策要求` |
| **隐私政策要求** | §8.4 | `#84-隐私政策要求` |
| **AI 技术应用要求** | §8.5 | `#85-ai-技术应用要求` |
| **内购 (IAP) 实现** | §8.7 | `#87-内购-in-app-purchase-实现要求如适用` |
| **推送通知实现** | §8.8 | `#88-推送通知-push-notifications-实现要求` |
| **Sign in with Apple** | §8.19 | `#819-sign-in-with-apple-完整实现要求` |
| **英文本地化指南** | §8.11 | `#811-英文本地化指南english-only` |
| **性能优化要求** | §8.13 | `#813-性能优化要求必读` |
| **Capabilities 配置** | §8.21 | `#821-capabilities-配置详解agent-执行指南` |
| **Widget 开发指南** | §8.22 | `#822-widget-开发指南2026-最新技术` |
| **深色模式实现** | §8.14 | `#814-深色模式-dark-mode-实现要求` |
| **无障碍功能** | §8.15 | `#815-无障碍功能-accessibility-实现要求` |
| **Apple Watch 实现** | §8.16 | `#816-apple-watch-app-实现要求如适用` |
| **Universal Links** | §8.20 | `#820-universal-links-与-url-scheme-配置要求` |
| **数据持久化策略** | §8.12 | `#812-数据持久化策略要求` |
| **Keychain 安全存储** | §8.10 | `#810-keychain-安全存储要求` |
| **后台模式实现** | §8.9 | `#89-后台模式-background-modes-实现要求` |
| **XcodeGen 失败处理** | §5.3 | `#53-xcodegen-生成失败处理` |
| **版本号管理规则** | §5.4 | `#54-版本号管理规则` |
| **截图尺寸要求** | §6.1 | `#61-app-store-截图尺寸要求必须符合最新-apple-规范` |
| **XCUITest 截图流程** | §6.2 | `#62-xcuitest-截图完整流程` |
| **App Groups 配置** | §7.1 | `#71-app-groups-配置` |
| **Beta 测试 (TestFlight)** | §7.2 | `#72-beta-测试testflight` |
| **审核被拒处理流程** | Stage 10 | `#stage-10审核被拒处理流程` |

---

## 👤 角色分工总览

> ⚠️ **重要**：本 SOP 由 AI Agent 和人类配合完成。以下明确标注每个步骤的执行主体，**严格遵守**。

### 角色定义

| 角色 | 说明 |
|------|------|
| 🤖 **AI Agent（Claude Code）** | **负责所有编程、配置、构建、测试等工作**，在本地 Mac 执行。包括但不限于：创建项目、编写代码、配置 project.yml/Info.plist/Entitlements、XcodeGen 生成、截图测试、功能测试、录屏制作、Git 操作、本地 Archive、生成隐私政策 HTML、生成 App Store 提交的元数据文件等 |
| 👨 **Human（人类）** | **不编程，不会写代码。仅能处理以下事务：**<br>1 **图标审核**：看图后给出 approved/rejected 意见<br>2 **UI 方案审核**：看设计稿后给出 approved/rejected 意见<br>3 **App 提交事宜**：在 App Store Connect 网页填写信息、点击提交审核<br>4 **Archive 上传**：通过本地 Xcode GUI 执行 `Product → Archive` → `Distribute App → App Store Connect → Upload`，**操作成功后告知 Agent** |

> ⚠️ **核心原则**：👨 **Human（人类）** 不参与任何编程工作。所有代码编写、配置文件修改、命令行操作、测试执行，均由 🤖 **AI Agent（Claude Code）** 独立完成。👨 **Human（人类）** 的任务仅限于「看 + 点」--看图审核、在网页填写信息、点击提交。


> **Agent Skills（调用方式：Skill → skill-name）**：

> ⚠️ **【强制】以下是 Agent 开发 iOS App 必备技能列表，Agent 必须熟练掌握并适时调用**

> **🎨 设计与图标类**
> - `ios-app-icon-generator`：生成 19 个尺寸图标，调用 Skill → `[ios-app-icon-generator]`，参数：1024×1024 源图路径
> - `ggsheng-app-icon-design`：AppIcon 设计规范
> - `ios-app-icon`：iOS App 图标生成与优化
> - `apple-design-skill`：Apple 设计指南与 Human Interface Guidelines
> - `ui-ux-design`：UI/UX 设计方案与交互设计
> - `sfsymbol-generator`：SF Symbol 图标查找与使用
> - `ios-animation-implementation`：iOS 动画实现（SwiftUI/UIKit 动画效果）

> **🛠️ 开发与编码类**
> - `swift`：Swift 编程语言核心技能
> - `xcode`：Xcode 项目配置与调试
> - `xcode-build-analyzer`：Xcode 构建分析与问题诊断
> - `coding-agent`：通用编码助手
> - `ios-self-improve`：iOS 代码自我审查与优化

> **📦 部署与上架类**
> - `app-store-connect`：App Store Connect 操作指南
> - `appstore-deployment-guide`：App Store 部署完整指南
> - `app-store-changelog`：App Store 版本更新日志生成

> **🔧 工具与辅助类**
> - `skill-creator`：创建新 Skill 的必备工具
> - `taskflow`：任务流程管理
> - `taskflow-inbox-triage`：任务分类与优先级管理
> - `healthcheck`：项目健康检查

---

### 核心原则

| 原则 | 说明 |
|------|------|
| **🤖 Agent 直接执行，不需要询问人类（强制）** | 标注为 🤖 AI Agent 的任务，**直接执行，严禁向 Human 询问"可以开始吗""文件在哪里""确认要执行吗"等确认性提问**。Agent 拥有 Read/Glob/Grep/LS/SearchCodebase 等全部文件访问工具，必须自己完成查找、确认和执行。只有遇到以下情况才能询问 Human：1 需要 Human 审核（设计/UI/隐私政策）2 需要 Human 操作（Archive）3 遇到技术性阻碍且自行尝试解决失败。**以任何形式将分内工作推给 Human 均视为违反 HR-24** |
| **👨 人类不编程** | Human **不会写代码、不会使用命令行**。所有编程、配置、构建、测试工作均由 Agent 独立完成。Human 仅限：看图审核、App Store Connect 网页填写、Xcode GUI Archive 操作 |
| **Claude Code 审查 + 修复** | **每次代码变更后执行**。所有 commit 前可先通过 Claude Code 审查，发现问题立即修复 |
| **必须人类审核的** | AI 输出 → 人类审核 → 通过后继续 |
| **人类肉眼审核时** | Agent 必须发送**真实图片/视频文件**，**禁止发送链接或口述内容** |
| **必须人类操作的** | AI 无法完成（如 Xcode GUI 操作、App Store Connect 审核点击）。**Archive 操作目的**：Human 通过本地 Xcode GUI 执行 `Product → Archive` → `Distribute App → App Store Connect → Upload`，**操作成功后告知 Agent** |
| **App 功能完整性** | Agent 必须验证：1 Privacy Policy/Terms of Service 界面有相关内容 2 **三个联系邮箱全部正确**：`support@techidaily.com`（App 内 Contact Support + App Store Connect Contact Email）、`privacy@techidaily.com`（Privacy Policy HTML 中）、`legal@techidaily.com`（Terms of Service HTML 中） 3 所有按钮功能正常 4 声音播放正常 5 Connect Mac 功能（如适用）6 App 界面显示名称与 App 名称一致 |
| **功能完整性审查** | **每次代码变更后 Agent 必须自动执行全面审查至少 3 次**，发现问题立即修复，**确保整个 App 功能完备正常**，**主动执行，不需要询问人类** |
| **出口合规预先配置** | **必须预先在 Info.plist 配置 `ITSAppUsesNonExemptEncryption = NO`**，避免每次提交被问到加密问题 |
| **Git 默认分支必须为 main** | **所有项目必须以 `main` 作为默认分支**。如果项目中存在 `master` 或 `github-actions` 等非 main 分支，必须由 **👨 Human 审核迁移方案** 后，Agent 才能执行合并。**禁止在非 main 分支上进行开发或提交** |
| **App 项目目录必须以 `ios-` 开头** | 所有 iOS 项目文件夹名称**必须以 `ios-` 为前缀**（如 `ios-FocusTimer`、`ios-HabitGo`），禁止使用其他前缀或无前缀 |

---

### 🗺️ 阶段总览

| 阶段 | 主要输出产物 | 关键负责人 |
|------|------------|-----------|
| **Stage 0: 设计审核** | 图标方案 + UI 设计稿 | 👨 Human 审核 |
| **Stage 1: 概念与命名** | 功能清单 `AppStore/Docs/FeatureList.md` | 🤖 Agent |
| **Stage 2: 创建目录结构** | Git 仓库 + 目录骨架 | 🤖 Agent |
| **Stage 3: project.yml** | `project.yml` 配置 | 🤖 Agent |
| **Stage 4: 必需文件** | Info.plist / Entitlements / AppIcon | 🤖 Agent |
| **Stage 5: XcodeGen** | `.xcodeproj` 生成 | 🤖 Agent |
| **Stage 6: 截图与测试** | 截图 / Unit Tests | 🤖 Agent |
| **Stage 7: Widget / Beta** | App Groups / TestFlight | 🤖 Agent |
| **Stage 8: 上传** | App Store Connect 上传 | 👨 Human（通过本地 Xcode GUI） |
| **Stage 10: 提交审核** | App Store 提交 | 👨 Human |

### 🤖 Agent 可独立执行的任务汇总

> ⚠️ **以下任务由 AI Agent 直接执行，不需要询问人类，自己搞定**

> 🚨 **【强制】Agent 禁止行为 - 以下问题严禁问 Human（违者 HR-24 处罚）**

> | "这个 YAML 语法对吗？" | 自己验证 |

> **Agent 可用工具**：`Read`、`Glob`、`Grep`、`LS`、`SearchCodebase`
> **有工具却不用，反而去问 Human = HR-24 违规**

| 阶段 | 任务 | 说明 |
|------|------|------|
| **Stage 0** | 0.1.1 生成图标方案 | 使用 §4.5 prompt 模板生成 1024×1024 PNG |
| | 0.1.3 提交 Git 等待审核 | commit 到 `AppStore/Assets/Icon/` |
| | 0.1.5 生成 19 个尺寸图标 | 审核通过后使用 `ios-app-icon-generator` skill |
| | 0.2.1 展示 UI 设计稿 | 直接发送设计稿图片文件给 Human 审核 |
| | 0.2.2 提交 Git 等待审核 | commit 到 `AppStore/Assets/UI/` |
| **Stage 1** | 1.1 核查 App Store 名称 | 执行 curl 命令查询是否被占用 |
| | 1.2 提供名称候选供 Human 审核 | **Agent 提供至少 3 个候选名称，Human 审核选择** |
| | 1.3 确定三层命名方案 | 根据 Human 选择的名称确定 |
| | 1.4 输出功能清单 + Capabilities 推荐 | 输出 `AppStore/Docs/FeatureList.md`（包含 Identifier Capabilities 推荐）|
| | 1.5 App 基础功能数量要求 | 确保功能数量 ≥60 个 |
| | 1.6 App 审核准备 | 准备测试账号和 Demo 数据 |
| | 1.7 生成 App Store 提交的元数据文件 | 将所有字段（含内购产品配置）以**具体值（非占位符）**写入 `AppStore/Listing.md` |
| **Stage 2** | 2.1 创建目录结构 | 执行 mkdir 命令 |
| | 2.2 初始化 Git，提交初始结构 | `git init && git branch -M main && git add && git commit` |
| **Stage 3** | 3.1 编写 project.yml | 配置 targets |
| | 3.2 审查 project.yml | 可再使用 Claude Code 审查 + 修复 |
| **Stage 4** | 4.1 编写 Info.plist、Entitlements | 按模板生成 |
| | 4.2 审查配置文件 | 可再使用 Claude Code 审查 + 修复 |
| | 4.3 编写 Widget Info.plist | 按模板生成 |
| | 4.4 编写 Widget Entitlements | 按模板生成 |
| | 4.5 编写 AppIcon 图标设计规范 | 从 ggsheng-app-icon-design-SKILL.md 同步 |
| **Stage 5** | 5.1 执行 XcodeGen 生成项目 | 本地执行 `~/tools/xcodegen/bin/xcodegen generate` |
| | 5.2 验证生成结果 | 检查文件是否完整 |
| | 5.3 Git 提交 | `git add && git commit -m "Initial project" && git push` |
| **Stage 6** | 6.2 编写 + 审查截图代码 | 生成 `ScreenshotTests.swift`，可再使用 Claude Code 审查 + 修复 |
| | 6.1.1 截取内购审核截图 | **Apple 要求**：每款内购产品必须上传至少 1 张审核截图，显示购买界面 |
| | 6.3 添加 Tab identifier + 审查 | 修改 App 源码添加 identifier，可再使用 Claude Code 审查 + 修复 |
| | 6.4 执行截图测试 | 本地执行 xcodebuild test，截图保存到 `/tmp/` |
| | 6.5 复制截图到 AppStore/Screenshots/ | 本地复制 |
| | 6.6 验证截图尺寸 + 肉眼检查 | MD5 + sips 命令，Human 确认每张截图不同页面 |
| | 6.7 编写 + 审查 Unit Tests | 编写功能测试代码，可再使用 Claude Code 审查 + 修复 |
| | 6.10 执行测试 | 本地执行 xcodebuild test |
| | 6.11 功能完整性审查及修复 | **每次代码变更后 Agent 必须自动执行至少 3 次** |
| **Stage 7** | 7.1 配置 App Groups | 修改 entitlements |
| | 7.4 修复 Bug | 根据反馈修改代码 |
| **Stage 8** | 8.4 创建隐私政策 HTML | 生成 `PrivacyPolicy.html` |
| **Stage 8** | 8.5 创建服务条款 HTML | 生成 `TermsOfService.html` |
| **Stage 8** | 8.6 部署隐私政策和服务条款到 GitHub Pages | 放入 `docs/` 目录，GitHub Pages 自动提供服务 |
| **Stage 8** | 8.7 写隐私政策 AI 相关条款 | 生成 AI 相关隐私政策条款 |
| **Stage 8** | 8.8 审核隐私政策和服务条款 | 人类审核 AI 写的法律文档条款 |
| **Stage 9** | 9.1 提交前最终检查 + Capabilities 复查 | 输出检查清单 + Capabilities 最终复查 |

### 👨 Human 必须操作的任务

> ⚠️ **以下任务 AI Agent 无法完成，必须由人类执行**

| 阶段 | 任务 | 说明 |
|------|------|------|
| **Stage 0** | 0.1.2 展示图标方案图片给 Human | **看图后**给出 approved 意见 |
| | 0.1.4 审核图标方案 | **看图后**给出至少 1 个 approved 意见 |
| | 0.2.3 审核 UI 方案 | **看图后**给出至少 1 个 approved 意见 |
| **Stage 1** | 1.4 审核功能清单 + Capabilities | 确认功能数量达标 **同时确认 Capabilities 推荐方案** |
| **Stage 8** | 8.1 Archive + Upload | **通过本地 Xcode GUI 执行** `Product → Archive → Distribute App → App Store Connect → Upload`，操作成功后告知 Agent |
| **Stage 8** | 8.2 填写 App Store Connect 信息 | 人类在网页上填写 |
| **Stage 8** | 8.3 配置 App 隐私 | 根据 App 实际功能选择"是"或"否" |
| **Stage 8** | 8.7 审核隐私政策 | 人类审核 AI 写的隐私政策条款 |
| **Stage 9** | 9.2 填写清单核查 | 人类逐项确认 |
| | 9.3 在 App Store Connect 新建 App | 点击"新建 App"，从下拉列表中选择 Bundle ID |
| | 9.4 点击提交审核 | 在 App Store Connect 点击 |
| | 9.5 关注审核状态 | 提交后状态变为"等待审核" |

---

### 📋 任务分工表

#### Stage 0：设计审核

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 0.1.1 | 生成图标方案（1024×1024 PNG） | 🤖 AI Agent | 使用 §4.5 prompt 模板生成 |
| 0.1.2 | **展示图标方案图片给 Human** | 🤖 AI Agent | **直接发送 PNG 图片文件**（不是描述或链接），让 Human 肉眼审核 |
| 0.1.3 | 提交 Git 等待审核 | 🤖 AI Agent | commit 到 `AppStore/Assets/Icon/` |
| 0.1.4 | 审核图标方案 | 👨 Human | **看图后**给出至少 1 个 approved 意见 |
| 0.1.5 | 生成 19 个尺寸 | 🤖 AI Agent | 审核通过后使用 `ios-app-icon-generator` skill |
| 0.2.1 | **展示 UI 设计稿图片给 Human** | 🤖 AI Agent | **直接发送设计稿图片文件**（不是描述或链接），让 Human 肉眼审核 |
| 0.2.2 | 提交 Git 等待审核 | 🤖 AI Agent | commit 到 `AppStore/Assets/UI/` |
| 0.2.3 | 审核 UI 方案 | 👨 Human | **看图后**给出至少 1 个 approved 意见 |

> ⚠️ **【强制】AI Agent 必须直接展示图片给 Human 审核**：
> - 图标方案：直接展示 PNG 图片文件
> - UI 设计稿：直接展示设计稿截图（不是文件链接或文字描述）
> - 禁止只发送描述性文字或文件路径而不展示实际图片
> - Human 必须用肉眼审核图片后才能给出 approved 意见

#### Stage 1：概念与命名

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 1.1 | 核查 App Store 名称是否被占用 | 🤖 AI Agent | 执行 curl 命令查询 |
| 1.2 | **审核名称候选** | 👨 Human | **Agent 提供至少 3 个候选名称，Human 审核并选择** |
| 1.3 | 确定三层命名方案 | 🤖 AI Agent | 根据 Human 选择的名称确定 |
| 1.4 | 确认功能清单（≥60 个）| 🤖 AI Agent | 输出 `AppStore/Docs/FeatureList.md`（包含 **Identifier Capabilities 推荐**）|
| | 审核功能清单 + Capabilities | 👨 Human | 确认功能数量达标 **同时确认 Capabilities 推荐方案** |
| 1.6 | App 审核准备（需要登录的 App）| 🤖 AI Agent | 准备测试账号和 Demo 数据 |
| 1.7 | 生成 App Store 提交的元数据文件 | 🤖 AI Agent | 将所有字段（含内购产品配置）以**具体值（非占位符）**写入 `AppStore/Listing.md` |
| **Stage 2** | 2.1 创建目录结构 | 🤖 AI Agent | 执行 mkdir 命令 |
| 2.2 | 初始化 Git，提交初始结构 | 🤖 AI Agent | `git init && git branch -M main && git add && git commit -m "Initial structure"` |

#### Stage 3：project.yml 配置

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 3.1 | 编写 project.yml | 🤖 AI Agent | 配置 targets |
| 3.2 | 审查 project.yml | 🤖 AI Agent | **可再使用 Claude Code 审查 + 修复** |

#### Stage 4：必需的文件

> ✅ **SC-04: 图标 19 个尺寸生成检查**
| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 4.1 | 编写 Info.plist、Entitlements | 🤖 AI Agent | 按模板生成 |
| 4.2 | 审查配置文件 | 🤖 AI Agent | **可再使用 Claude Code 审查 + 修复** |
| 4.3 | 编写 Widget Info.plist | 🤖 AI Agent | 按模板生成 |
| 4.4 | 编写 Widget Entitlements | 🤖 AI Agent | 按模板生成 |
| 4.5 | 编写 AppIcon 图标设计规范 | 🤖 AI Agent | 从 ggsheng-app-icon-design-SKILL.md 同步 |

#### Stage 5：XcodeGen 生成项目

> ⚠️ **【强制】每次代码变更后首次 build 前必须执行以下流程**：
> 1 `rm -rf ~/Library/Developer/Xcode/DerivedData/{ProjectName}-*`（清理缓存）
> 2 `~/tools/xcodegen/bin/xcodegen generate`（重新生成项目）
> 3 `xcodebuild clean`（清理旧构建产物）
> 4 `xcodebuild build`（重新编译）
> **这是 Agent 的标准操作，不是出了问题才执行**。

> ⚠️ **【重要】关于签名**：
> - 本地 Mac 使用 **Xcode 自动签名**（Automatically manage signing）
> - **不需要手动获取 Profile**
> - Human 通过本地 Xcode GUI 执行 Archive 时，Xcode 自动处理签名

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 5.1 | 执行 XcodeGen 生成项目 | 🤖 AI Agent | 本地执行 |
| 5.2 | 验证生成结果 | 🤖 AI Agent | 检查文件是否完整 |
| 5.3 | Git 提交 + 推送 | 🤖 AI Agent | `git add && git commit && git push` |

> ⚠️ **【强制】截图 + 视频必须在 Archive + Upload 之前完成**

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 6.1 | 截图尺寸要求 | 🤖 AI Agent | 见 §6.1 App Store 截图尺寸要求 |
| 6.1.1 | **截取内购审核截图** | 🤖 AI Agent | **Apple 强制要求**：每款内购产品必须上传至少 1 张审核截图，显示购买界面 |
| 6.2 | 编写截图代码 | 🤖 AI Agent | 生成 `ScreenshotTests.swift` |
| 6.3 | 添加 Tab identifier | 🤖 AI Agent | 修改 App 源码添加 identifier |
| 6.4 | 文件名规范 | 🤖 AI Agent | 格式：`序号_页面名称.png` |
| 6.5 | 复制截图到 AppStore/Screenshots/ | 🤖 AI Agent | 本地复制到对应目录 |
| 6.5.1 | MD5 验证每张截图不同 | 🤖 AI Agent | 使用 MD5 哈希验证 |
| 6.5.2 | XCUITest 截图代码模板 | 🤖 AI Agent | 生成 `ScreenshotTests.swift` 模板 |
| 6.6 | **展示截图图片给 Human 审核** | 🤖 AI Agent | **直接展示 3 张不同 Tab 页面的真实截图文件** |

#### Stage 6 附加：测试

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 6.7 | 编写 + 审查 Unit Tests | 🤖 AI Agent | 编写功能测试代码 |
| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 7.1 | 配置 App Groups | 🤖 AI Agent | 修改 entitlements |
| 7.2 | **TestFlight 上传** | 👨 Human | 通过本地 Xcode GUI 执行 Archive → Upload |
| 7.3 | Beta 测试 | 👨 Human | 人类测试员执行（**可选操作**）|
| 7.4 | 修复 Bug | 🤖 AI Agent | 根据反馈修改代码 |

#### Stage 8：App Store Connect 上传

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 8.1 | **App Store 上架提交** | 👨 Human | 通过本地 Xcode GUI 执行 Archive → Upload |
| 8.2 | 填写 App Store Connect 信息 | 👨 Human | 人类在网页上填写 |
| 8.3 | 配置 App 隐私 | 👨 Human | 根据 App 实际功能选择"是"或"否" |
| 8.4 | 创建隐私政策 HTML | 🤖 AI Agent | 生成 `PrivacyPolicy.html` |
| 8.5 | 创建服务条款 HTML | 🤖 AI Agent | 生成 `TermsOfService.html` |
| 8.6 | 部署隐私政策和服务条款到 GitHub Pages | 🤖 AI Agent | 放入 `docs/` 目录 |
| 8.7 | 写隐私政策 AI 相关条款 | 🤖 AI Agent | 生成 AI 相关隐私政策条款 |
| 8.8 | 审核隐私政策和服务条款 | 👨 Human | 人类审核 AI 写的法律文档条款 |

#### Stage 9：提交审核

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 9.1 | 提交前最终检查 + Capabilities 复查 | 🤖 AI Agent | 输出检查清单 **+ Capabilities 最终复查** |
| 9.2 | 填写清单核查 | 👨 Human | 人类逐项确认 |
| 9.3 | **在 App Store Connect 新建 App** | 👨 Human | 点击"新建 App"，从下拉列表中选择由 Xcode 自动创建的 Bundle ID |
| 9.4 | **点击提交审核** | 👨 Human | 人类在 App Store Connect 点击 |
| 9.5 | 关注审核状态 | 👨 Human | 提交后状态变为"等待审核"，首次审核通常7-14个工作日 |

---

### 🚫 AI 禁止单独执行的操作

| 禁止操作 | 原因 | 正确做法 |
|---------|------|---------|
| 要求 Human 在 VNC 上执行 Archive | 本地开发不需要 VNC | 使用本地 Xcode GUI 执行 Archive |
| 跳过设计审核直接开发 | 会导致返工 | 图标+UI 审核通过后才能开发 |
| 跳过截图图片审核 | 可能所有截图都是首页 | **必须发送真实截图文件给 Human 肉眼确认** |
| 声称 Human 才能操作的步骤是 AI 完成 | AI 无法操作 Xcode GUI | 如实说明是 Human 操作 |
| 生成 .ipa 文件放到桌面或子文件夹 | .ipa 不应出现在桌面，必须通过 Xcode 直接上传 | Archive 后直接在 Xcode Organizer 上传 |
| Tab 切换失败时不思考直接问 Human | Agent 必须自己想办法解决 | **必须修改优化截图代码直到成功**，不能询问 Human |
| 截图成功后不展示图片给 Human 审核 | 违反 Stage 6 流程，Human 无法确认截图质量 | **必须发送真实截图文件给 Human 肉眼确认** |
| 跳过功能完整性审查 | App 可能存在隐藏 bug 或功能缺陷 | **Agent 必须对所有功能做代码级别审核，多测试几遍确保功能完备正常** |

---

### ✅ Claude Code 审查 + 修复（每次必须执行）

| 步骤 | 说明 |
|------|------|
| 1. **审查** | 分析代码发现问题（bug、风格、安全、无障碍等） |
| 2. **修复** | 根据审查结果修复所有发现的问题 |
| 3. **再次审查** | 确认修复完成，确保没有问题后才能 commit |
| 4. **权限控制** | Claude Code 的执行权限由 Agent 自身控制，**完全可以使用 Bypass Permissions 模式**（跳过权限提示，直接执行所有操作） |

| 审查项 | 说明 |
|------|------|
| 所有源码变更 | `git diff` 后，🤖 Agent 最好也使用 Claude Code 审查 + 修复 |
| project.yml 配置 | 确认 signing、entitlements 配置正确 |
| XCUITest 代码 | 确认 Tab 切换、截图逻辑正确 |
| 功能测试代码 | 确认测试覆盖核心功能 |
| 配置文件 | Info.plist、Entitlements 完整正确 |

---

### 📍 Claude Code 权限模式说明

> ⚠️ **Claude Code 执行权限由 Agent 控制**，Agent 可以选择使用 Bypass Permissions 模式来跳过权限确认提示，直接执行所有操作。

| 模式 | 说明 |
|------|------|
| **Bypass Permissions（推荐）** | Agent 直接执行所有操作，无需权限确认。适用于自动化流程，提高执行效率。 |
| **Normal Mode** | 每次操作前需要用户确认权限。适用于需要人工监督的场景。 |

**配置方式**：通过 Claude Code 的 `--dangerously-disable-permission-prompts` 参数或设置环境变量来启用 Bypass 模式。

---

## Stage 0：设计审核（必须先完成）

> 🚨 **HR-01: 禁止跳过 Stage 0 设计审核**
> ⚠️ **必须先完成设计审核，才能进入开发阶段**。未审核的设计直接开发会导致返工。

### 0.1 图标方案审核

1. **生成图标方案**：使用 §4.5 的 prompt 模板生成 1024×1024 PNG 源图
2. **直接展示图片给 Human 审核**：将 PNG 图片**直接展示**（不是文件路径或描述），让 Human 肉眼审核
3. **审核内容**：
   - 设计风格是否符合目标用户（欧美）审美
   - 是否符合 Apple Design Awards 质量标准
   - 是否符合 §4.5 趋势要求
   - 是否符合配色规范
4. **审核通过标准**：至少获得 1 个明确 approved 意见
5. **通过后**：提交 Git + 使用 `ios-app-icon-generator` skill 生成全部 19 个尺寸

### 0.2 App UI 设计方案审核

1. **输出设计方案**：使用 Sketch/Figma/PDF 输出主要页面设计稿（至少包含：首页、详情页、设置页）
2. **直接展示设计稿图片给 Human 审核**：**直接展示截图**（不是文件链接或描述），让 Human 肉眼审核
3. **审核内容**：
   - 界面设计风格是否与图标风格统一
   - 是否符合 Apple Design Awards 级别要求
   - 交互流程是否符合 iOS 原生设计模式
   - 是否符合西方用户习惯
4. **审核通过标准**：至少获得 1 个明确 approved 意见
5. **通过后**：才能进入 Stage 1（开发阶段）开始编写代码

### 0.3 审核流程

> 🚨 **HR-05: 禁止跳过 Human review**
```
┌─────────────────────────────────────────────────────┐
│  阶段 1:图标设计 → 提交 Git → 等待审核              │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  ✅ 图标审核通过 → 阶段 2                            │
│  ❌ 图标审核拒绝 → 修改后重新提交                    │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  阶段 2:UI 设计 → 提交 Git → 等待审核              │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  ✅ UI 审核通过 → 进入 Stage 1（开发阶段）              │
│  ❌ UI 审核拒绝 → 修改后重新提交                    │
└─────────────────────────────────────────────────────┘
```

---

## Stage 1：概念与命名

### 1.1 提前核查 App Store 名称

```bash
curl -s "https://itunes.apple.com/search?term=你的名字&entity=software&limit=5" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); [print(r['trackName'], r['artistName']) for r in d['results']]"
```

### 1.2 三层命名

| 层级 | 示例占位符 | 位置 | 能否改 |
|------|-----------|------|--------|
| App Store 名称 | `{DesiredAppStoreName}` | App Store Connect | ✅ |
| Bundle ID | `com.ggsheng.{AppName}` | 打包进二进制 | ❌ |
| Display Name | `{AppName}` 或 `{DesiredAppStoreName}` | Info.plist | ✅ |

**规则：Bundle ID 一旦上传不能改，App Store 名称随时可换。**

#### 1.2.1 Bundle Identifier 命名规范

> ⚠️ **【强制】Bundle ID 和 App Group ID 是两个不同的概念，必须严格区分**

| 概念 | 用途 | 格式 |
|------|------|------|
| **Bundle ID** | 打包进 App 二进制，唯一标识 App | `com.ggsheng.{AppName}` |
| **App Group ID** | App Groups 数据共享用 | `group.com.ggsheng.{AppName}` |

**重要规则：**
1. **Bundle ID 禁止使用 `group.` 前缀** — `group.com.xxx` 是 App Group ID，不是 Bundle ID
2. **有 App Groups 时**：Bundle ID 仍然是 `com.ggsheng.{AppName}`，App Group ID 才是 `group.com.ggsheng.{AppName}`
3. **无 App Groups 时**：只使用 `com.ggsheng.{AppName}`，不需要 `group.` 前缀
4. **Bundle ID 一旦上传 App Store 就不能修改**，App Group ID 可以随时更改

**正确示例：**
```
# 有 App Groups 的 App
Bundle ID:     com.ggsheng.VitaMind
App Group ID:  group.com.ggsheng.VitaMind

# 无 App Groups 的 App
Bundle ID:     com.ggsheng.HabitTracker
```

**错误示例（禁止）：**
```
group.com.ggsheng.VitaMind  ❌ 这是 App Group ID，不是 Bundle ID！
com.vitamind.app           ❌ 违反逆域名惯例
com.example.appname        ❌ 未使用组织标识符
```

**命名依据：**
- 逆域名惯例（com = 商业实体），符合 Apple 官方推荐
- `ggsheng` 为在 Apple Developer Portal 注册的组织标识符
- 所有 App 统一使用此前缀，便于组织管理

> ⚠️ **【强制】Agent 每次创建项目或修改 Bundle ID 时，必须先确认使用的是 `com.ggsheng.{AppName}` 格式，禁止使用 `group.` 前缀作为 Bundle ID**

> ⚠️ **【强制】Agent 必须提供名称候选供 Human 审核**：
> 1. Agent 执行 curl 命令查询名称是否被占用
> 2. Agent 根据查询结果**提供至少 3 个候选名称**（按优先级排序）
> 3. **Human 审核并选择**或提出修改意见
> 4. Human 确认后 Agent 才能使用该名称
>
> **Agent 输出示例**：
> ```
> 名称候选（按优先级排序）：
> 1. FocusFlow - 专注力/效率工具，简洁有力

#### 1.2.2 修改 Display Name（App 显示名称）

> ⚠️ **【强制】Display Name 变更必须全局检查，禁止遗漏任何用户可见文本**

**核心概念区分**：

| 概念 | 示例 | 可见性 | 说明 |
|------|------|--------|------|
| **Bundle ID** | `<BundleID>` | ❌ 用户看不到 | 打包进二进制，唯一标识 App |
| **内部代码名** | `<AppInternalName>` | ❌ 用户看不到 | Swift struct/class 名称，App 代码内部使用 |
| **Display Name** | `VitaMindGo` | ✅ 用户看到 | Info.plist 中的 `CFBundleDisplayName`，用户看到的 App 名称 |

> 💡 **规则**：Bundle ID 可以保持不变（`<BundleID>`），即使 Display Name 改为 `<DisplayName>`。内部代码名（如 `<AppInternalName>`）不会出现在 UI 中。

**Display Name 修改必须同步修改以下位置**：

| 文件位置 | 修改内容 | 说明 |
|----------|---------|------|
| `Sources/Info.plist` | `CFBundleDisplayName` → `{NewName}` | 主 App 显示名称 |
| `Widget/Info.plist` | `CFBundleDisplayName` → `{NewName} Widget` | Widget 显示名称 |
| `App Store Connect` | App Store 名称（如需同步） | App Store 页面显示的名称 |

**⚠️ 还必须检查用户可见的硬编码字符串**：

Display Name 不仅在 Info.plist 中设置，**还可能硬编码在 UI 代码中**。修改 Display Name 后，**必须全局搜索检查**：

```bash
# 搜索所有包含旧 Display Name 的用户可见字符串
grep -rn '"{OldName}"\|"{OldName} "' Sources/ --include="*.swift" | grep -v "//.*" | grep -v "struct\|enum\|class\|import\|import \|\.scheme"

# 常见需要检查的 UI 位置：
# - Text("AppName") - 卡片背面、启动画面
# - .navigationTitle("AppName") - 导航栏标题
# - Label("AppName", ...) - Tab bar 项目
# - Widget 显示名称
```

**必须修改的典型场景**：

```swift
// ❌ 错误：硬编码了 Display Name
Text("VitaMindGo")  // 卡片背面显示
.navigationTitle("VitaMindGo")  // 导航栏

// ✅ 正确：使用 Bundle ID 或常量引用
Text("VitaMindGo")  // 如果是 Display Name，已正确
Text("VitaMindGo")  // 如果是 Display Name，已正确
```

**Display Name 修改完整操作步骤**：

```bash
# 1. 修改主 App Info.plist
sed -i '' 's/<string>{OldName}<\/string>/<string>{NewName}<\/string>/' Sources/Info.plist

# 2. 修改 Widget Info.plist
sed -i '' 's/<string>{OldName} Widget<\/string>/<string>{NewName} Widget<\/string>/' Widget/Info.plist

# 3. 全局搜索旧 Display Name 是否硬编码在 UI 中
grep -rn '"{OldName}"' Sources/ --include="*.swift" | grep -v "//" | grep -v "struct\|enum\|class"

# 4. 如果有硬编码，修改所有用户可见的字符串
# 例如：Text("VitaMind") → Text("VitaMindGo")

# 5. 验证修改
grep -A1 "CFBundleDisplayName" Sources/Info.plist Widget/Info.plist

grep -rn '"{NewName}"' Sources/ --include="*.swift" | grep -v "//" | grep "Text\|navigationTitle\|Label" | head -10

# 6. 重新 Build 验证
xcodebuild build -project <AppName>.xcodeproj -scheme <AppName> ...
```

**验证检查清单**：

- [ ] `Sources/Info.plist` 的 `CFBundleDisplayName` 已更新
- [ ] `Widget/Info.plist` 的 `CFBundleDisplayName` 已更新且含 "Widget" 后缀
- [ ] 代码中没有用户可见的旧 Display Name 字符串
- [ ] 新 Display Name 没有出现在不应该出现的地方（如 Tab bar 项目名称）
- [ ] Bundle ID 保持不变（`com.ggsheng.{AppName}`）
- [ ] 内部代码名（如 `<AppInternalName>`）没有出现在 UI 中

**注意事项**：
- Display Name 只影响显示，不影响 Bundle ID
- Widget 的 Display Name **必须**包含 "Widget" 后缀以区分主 App
- 如果 Display Name 与 App Store 名称不同，两者都可以独立修改
- **内部代码名（struct/class 名称）不应出现在任何用户可见文本中**

#### 1.2.3 项目命名三层映射规范（必读 — 2026-06-03 经验沉淀）

> **【强制】iOS 项目启动时必须明确并文档化 3 层命名映射，避免项目内 Display Name / xcodeproj name / GitHub repo name / Bundle ID 互相不匹配导致混乱**

iOS 项目天然存在 4-5 层命名（Display Name / xcodeproj name / target name / scheme name / Bundle ID / GitHub repo / local folder / Swift class），同个项目不同位置出现不同名字会导致：
- Agent 接手项目时不知道哪个是"权威名字"
- archive 路径 / IDE 显示 / git remote / 文档 全部不一
- 重命名时不清楚哪些需要改、哪些是“已上架不能动”

**三层映射模板**（每个项目启动时填入 `project.yml` 顶部）：

```yaml
# === VitaMindGo 项目命名三层映射 ===
# 权威主名 (唯一对外品牌): VitaMindGo
# Display Name (App Store): VitaMindGo
# xcodeproj name (Xcode GUI 展示): VitaMindGo
# GitHub repo: ios-VitaMindGo  (https://github.com/<owner>/ios-VitaMindGo)
# 本地 folder: ios-VitaMindGo  (~/Desktop/ios-VitaMindGo/)
#
# 历史包袱 (不能改):
# Bundle ID: com.ggsheng.VitaMind  (已注册 App Store，改了 = 重新发布)
# Swift class: VitaPocketApp  (HR-32 保护，不进 UI)
# target/scheme name: VitaPocket  (xcodebuild 内部名，不影响用户)
```

**3 层关系图**：

```
  ┌────────────────────────────────────────────┐
  │ Display Name (App Store) = VitaMindGo      │  ← 唯一对外品牌
  ├────────────────────────────────────────────┤
  │ xcodeproj name  = VitaMindGo               │  ← Agent / 人类在 Xcode 看到
  │ GitHub repo     = ios-VitaMindGo           │  ← clone / push URL
  │ local folder    = ios-VitaMindGo           │  ← ~/Desktop/ 下路径
  ├────────────────────────────────────────────┤
  │ Bundle ID       = com.ggsheng.VitaMind      │  ← 历史包袱 (已上架不能改)
  ├────────────────────────────────────────────┤
  │ Swift class     = VitaPocketApp            │  ← 内部代码 (HR-32 保护)
  │ target name     = VitaPocket               │  ← xcodebuild -target / -scheme
  │ scheme name     = VitaPocket               │  ← xcodebuild -scheme
  └────────────────────────────────────────────┘
```

**5 名字一致自检脚本**（SC-58 套件，加入到 `scripts/naming-check.sh`）：

```bash
#!/bin/bash
# SC-58: Project naming three-layer consistency check
# Run from project root after any rename

set -e

PROJ_DIR="${1:-.}"
cd "$PROJ_DIR" || exit 1

echo "=== Display Name (Info.plist) ==="
/usr/libexec/PlistBuddy -c "Print :CFBundleDisplayName" Sources/Info.plist

echo "=== Bundle ID (project.yml) ==="
grep "PRODUCT_BUNDLE_IDENTIFIER:" project.yml | head -1

echo "=== xcodeproj name (Xcode) ==="
ls -d *.xcodeproj 2>/dev/null

echo "=== Folder name ==="
basename "$(pwd)"

echo "=== GitHub remote ==="
git remote get-url origin

# 期望输出示例（VitaMindGo）:
# Display Name: VitaMindGo
# Bundle ID:    com.ggsheng.VitaMind
# xcodeproj:    VitaMindGo.xcodeproj
# folder:       ios-VitaMindGo
# remote:       https://github.com/lauer3912/ios-VitaMindGo.git
```

**重命名决策树**（新项目 / 改名时按此表判断）：

| 项 | 能改? | 代价 | 原因 |
|---|-------|------|------|
| **Display Name** | ✅ 自由改 | 低 (SOP §1.2.2 checklist) | App Store 品牌名 |
| **xcodeproj name** | ✅ 自由改 | 低 (xcodegen 重生成) | Xcode GUI 展示 |
| **GitHub repo name** | ✅ 自由改 | 中 (需重 git push) | URL 对外，301 重定向 |
| **local folder name** | ⚠️ 谨慎改 | 中 (git 检测) | 改完需 `git remote set-url` |
| **target/scheme name** | ⚠️ 不推荐改 | 中高 (xcodebuild 命令全部要改) | 内部名，改完生态变动 |
| **Swift class name** | ⚠️ 不推荐改 | 高 (全工程 grep 替换 + HR-32 防) | 内部名，HR-32 巳护 |
| **Bundle ID** | ❌ **改动 = 重新发布** | 极高 | 已上架 = 零收益高风险 |

**使用流程**：

1. **新项目启动**：填三层映射模板到 `project.yml` 顶部
2. **运行 SC-58 脚本**：初始化后跑 1 次，确认 5 个名字明确定义
3. **CI 集成**（可选）：每次 PR 跑 `scripts/naming-check.sh`，发现名字不一致即 fail
4. **重命名决策**：查上表判断能不能改 / 代价多大 / 需不需要先发公告

#### HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-76** | **禁止项目命名三层映射无明确定义** — 任何新项目 / 重命名项目必须在 `project.yml` 顶部补上三层映射表块 (Display / xcodeproj / repo / folder / Bundle ID / Swift class 6 项) | §1.2.3 |
| **HR-77** | **禁止改 Bundle ID (已上架项目)** — App Store 已上架项目的 Bundle ID 是 "0 改 = 重新发布" 的不可变标识，改了 = 丢所有用户 / 排名 / 推送 token | §1.2.3 |
| **HR-78** | **禁止 xcodeproj / scheme / target / class name 改名后未 grep 验证** — 改内部名后必须 `grep -r "<old_name>" Sources/` 输出空 | §1.2.3 |
| **SC-58** | **项目命名三层一致性自检** — 跑 `scripts/naming-check.sh` 5 项输出匹配项目记录的三层映射表 | §1.2.3 |
| **SC-59** | **Bundle ID 不可变验证** — 上架后项目 `git log --all -- project.yml` 不应出现 `PRODUCT_BUNDLE_IDENTIFIER` 变更 (除非同一个项目下在调为不同 app) | §1.2.3 |

> 2. DeepWork Timer - 深度工作计时器，描述性强
> 3. FocusPro - 专业专注，通用性强
> 
> 请 Human 审核并选择。
> ```

### 1.3 App 界面设计规范（必读）

**App 界面设计风格必须与图标设计规范一致**，详见 §4.5。设计质量标准参照 **Apple Design Awards** 级别。

> ⚠️ **目标用户明确**：所有 App 主要面向欧美客户。图标和 UI 设计必须符合西方审美，避免中式审美元素（红金配色、生肖、太极等亚洲特有元素）。

#### 设计质量标准参照体系

| 标准/奖项 | 适用场景 | 说明 |
|---------|---------|------|
| **Apple Design Awards** | 所有 iOS App | Apple 官方顶级设计奖项，金标准 |
| **Apple HIG** | 所有 iOS App | Human Interface Guidelines，审核必查 |
| **Dribbble** | 视觉灵感 | 全球设计师作品集，搜索 iOS/App 设计趋势 |
| **Mobbin** | iOS 原生界面模式 | 收录大量知名 App 的真实界面截图 |
| **WWDC Design Sessions** | 设计理念与实践 | Apple 开发者大会设计相关演讲 |
| **Red Dot Design Award** | 交互/产品设计 | 国际权威工业设计奖，含 App 品类 |
| **iF Design Award** | 数字产品设计 | 另一国际权威设计奖，数字产品类别 |

#### 设计质量标准（Apple Design Awards 级别）

| 维度 | 要求 | 说明 |
|------|------|------|
| **视觉精致度** | 像素级完美，无锯齿、无模糊 | 所有图标、插图、装饰元素必须是矢量或高清 raster |
| **动效设计** | 流畅、自然、有意义 | 过渡动画 300-500ms，使用 spring/ ease-out 曲线 |
| **颜色系统** | 统一配色板，≤5 个核心色 | 深色背景 + 渐变辅助色，详见 §4.5 配色方案 |
| **typography** | SF Pro Display/Text 系统字体 | 标题 20-34pt，正文 15-17pt，标注 11-13pt |
| **层次与间距** | 8pt 网格系统 | 边距/间距为 8 的倍数（8/16/24/32/40）|
| **一致性** | 全 App 统一设计语言 | 图标风格 → 按钮 → 卡片 → 页面层级保持一致 |

#### iOS 原生设计模式（必须遵循）

| 场景 | 正确写法 | 错误写法 |
|------|---------|---------|
| 导航 | TabView（底部标签栏）| 自定义侧面抽屉 |
| 列表 | List + ForEach | ScrollView + VStack（性能差）|
| 设置页 | Form + Section | 散落的无分组设置项 |
| 弹窗 | sheet/alert/confirmationDialog | 非原生的自定义弹窗 |
| 加载 | ProgressView/sheet | 自定义 GIF 或粗糙的 loading 动画 |
| 空状态 | ContentView 条件渲染 + 插图 | 空白屏幕或占位图 |
| Tab 切换 | `.tabItem {}` +  SF Symbol | 文字 label 或自定义图标按钮 |

#### 无障碍功能要求（欧美市场强制）

> ⚠️ 欧美用户高度重视无障碍功能，Apple 审核也会检查。**所有功能必须支持无障碍**。

| 要求 | 实现方式 |
|------|---------|
| VoiceOver 标签 | 所有可交互元素必须设置 `accessibilityLabel` |
| Dynamic Type | 使用 `.font(.body)` 等相对字号，禁止固定 pt 值 |
| 颜色对比度 | 文字与背景对比度 ≥ 7:1（WCAG AA）|
| 点击区域 | 所有可点击元素 ≥ 44×44pt |
| 图像描述 | 图片需设置 `accessibilityLabel("描述文字")` |
| 无障碍测试 | VoiceOver 下所有功能必须可访问 |

### 1.4 App 基础功能数量要求

> ✅ **SC-09: App 功能数量 ≥60 个检查**
**App 起步功能数量不能低于 60 个。**

| App 类型 | 功能数量要求 | 说明 |
|---------|-------------|------|
| 效率/生产力类 | ≥60 个 | 番茄钟、待办、日程、数据统计等 |
| 健康/健身类 | ≥60 个 | 追踪、记录、提醒、报告等 |
| 金融/财务类 | ≥60 个 | 记账、预算、报表、分析等 |
| 社交/创意类 | ≥60 个 | 互动、内容、分享、反馈等 |

> ⚠️ **功能数量不足会被 App Store 审核拒绝**。Apple 要求 App 必须提供足够的实用价值，"只是一个简单计时器"或"只是一个待办列表"会因为功能单薄被拒。

**必须输出功能清单文档**：`AppStore/Docs/FeatureList.md`，格式：

```markdown
# {AppName} 功能清单

## 核心功能（≥60）
| # | 功能名称 | 描述 | 优先级 |
|---|---------|------|--------|
| 1 | Focus Timer | 番茄工作法计时器 | P0 |
| 2 | Session History | 历史记录查看 | P0 |
| ... | ... | ... | ... |

## 辅助功能
| # | 功能名称 | 描述 | 优先级 |
|---|---------|------|--------|
| 51 | Settings | 设置页面 | P1 |
...

## Identifier Capabilities 推荐

| 功能 | 推荐 Enable 的 Capability | 说明 |
|------|-------------------------|------|
| 有 Widget | ✅ App Groups | 必须和主 App 一致，用于数据共享 |
| 有推送通知 | ✅ Push Notifications | 需要配置 APNs，需要 Certificates |
| 有内购 | ✅ In-App Purchase | 需要配置 Agreements（Paid Apps）|
| 有 Apple Sign In | ✅ Sign in with Apple | 必须配合隐私政策说明 |
| 有 AI/ML 功能 | ⚠️ 隐私政策说明 | 无需额外 Capability |
| **健康类 App** | ✅ HealthKit | 需要配置 Info.plist + entitlements |
| 后台刷新 | ✅ Background Modes | `background-fetch`、`remote-notification` |
| 位置服务 | ✅ Location Services | 需要 NSLocation* Usage Description |
| 相机/相册 | ✅ Privacy Descriptions | 需要 NSCamera/NSPhotoLibrary Usage Description |
| Data Protection | ✅ Data Protection | `NSFileProtectionComplete` |
| ... | ... | ... |

> ⚠️ **【强制】每个 Capability 都需要在 Info.plist 中添加对应的 Usage Description**，否则 App Store 审核会被拒绝。

---

### 1.5 App 审核准备

> ⚠️ **这是审核测试账号，不是内购沙盒账号（两个不同东西）**

**仅当 App 需要登录才需要准备**：
- App 打开就能用 → **不需要**，跳过此节
- 需要登录才能用核心功能 → **必须准备**

| 准备项 | 说明 |
|--------|------|
| 测试账号 | App 里的普通用户账号，格式：`test@example.com` |
| 密码 | 简单密码，不含特殊字符：`Test123456` |
| Demo 数据 | 账号里预置真实数据，方便审核人员快速验证 |

### 1.6 生成 App Store 提交的元数据文件

> ⚠️ **【强制】Agent 必须在 Stage 1 确定名称和功能清单后，立即生成 `AppStore/Listing.md`**，包含**所有** App Store Connect 填写内容（含内购产品配置），以**具体值（非占位符）写入**。

---

## Stage 2：创建项目目录/文件结构

> 🚨 **HR-02: 禁止在非 main 分支开发**
```bash
mkdir -p ios-{AppName}/{AppName,AppNameWidget,AppNameTests,AppNameUITests,AppStore}
mkdir -p ios-{AppName}/AppName/{App,Models,Views,ViewModels}
mkdir -p ios-{AppName}/AppName/Assets.xcassets/{AppIcon.appiconset,AccentColor.colorset}
mkdir -p ios-{AppName}/AppNameWidget/Assets.xcassets
mkdir -p ios-{AppName}/AppStore/{Screenshots,AppPreview}
touch ios-{AppName}/AppStore/Listing.md
mkdir -p ios-{AppName}/AppStore/Assets/{Icon,UI}
mkdir -p ios-{AppName}/AppStore/Docs
mkdir -p ios-{AppName}/AppStore/Screenshots/{iPhone17ProMax_1320x2868,iPadPro13inchM4_2048x2732,AppleWatchUltra3_396x484,InAppPurchase}

```

### AppStore 目录结构规范

```
ios-{AppName}/AppStore/
├── Assets/
│   ├── Icon/
│   │   └── Icon-1024@1x.png
│   └── UI/
│       ├── README.md
│       └── UI-Mockup-v1.png
├── Docs/
│   └── FeatureList.md
├── Screenshots/
│   ├── README.md
│   ├── iPhone17ProMax_1320x2868/
│   ├── iPadPro13inchM4_2048x2732/
│   └── InAppPurchase/
├── Listing.md
├── Description.txt
├── PrivacyPolicy.html
├── HOW-TO.md
└── HOW-TO-AppStoreConnect.md
```

---

## Stage 3：project.yml 完整配置

### 3.1 完整模板

```yaml
# ══════════════════════════════════════════════════════════════
# 项目级别配置
# ══════════════════════════════════════════════════════════════

name: {AppName}
options:
  bundleIdPrefix: com.ggsheng
  deploymentTarget:
    iOS: "17.0"
  xcodeVersion: "16.0"
  generateEmptyDirectories: true

# ══════════════════════════════════════════════════════════════
# 全局构建设置（所有 target 继承）
# ══════════════════════════════════════════════════════════════

settings:
  base:
    SWIFT_VERSION: "5.10"
    MARKETING_VERSION: "3.0.0"
    CURRENT_PROJECT_VERSION: "1"
    CODE_SIGN_STYLE: Automatic
    DEVELOPMENT_TEAM: 9L6N2ZF26B
    ENABLE_USER_SCRIPT_SANDBOXING: NO

# ══════════════════════════════════════════════════════════════
# Target 1: 主 App
# ══════════════════════════════════════════════════════════════

targets:
  {AppName}:
    type: application
    platform: iOS
    sources:
      - path: {AppName}
        excludes:
          - "**/.DS_Store"
    settings:
      base:
        INFOPLIST_FILE: {AppName}/Info.plist
        PRODUCT_BUNDLE_IDENTIFIER: com.ggsheng.{AppName}
        PRODUCT_NAME: {AppName}
        ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
        ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME: AccentColor
        GENERATE_INFOPLIST_FILE: NO
        SWIFT_EMIT_LOC_STRINGS: YES
        CODE_SIGN_ENTITLEMENTS: {AppName}/{AppName}.entitlements
        CODE_SIGN_STYLE: Automatic
        CODE_SIGNING_ALLOWED: NO
        DEVELOPMENT_TEAM: 9L6N2ZF26B
      configs:
        Debug:
          CODE_SIGNING_ALLOWED: NO
        Release:
          CODE_SIGNING_ALLOWED: YES
    entitlements:
      path: {AppName}/{AppName}.entitlements
    dependencies:
      - target: {AppName}Widget
        embed: true

  {AppName}Widget:
    type: app-extension
    platform: iOS
    sources:
      - path: {AppName}Widget
        excludes:
          - "**/.DS_Store"
    settings:
      base:
        INFOPLIST_FILE: {AppName}Widget/Info.plist
        PRODUCT_BUNDLE_IDENTIFIER: com.ggsheng.{AppName}.widget
        PRODUCT_NAME: {AppName}Widget
        GENERATE_INFOPLIST_FILE: NO
        SWIFT_EMIT_LOC_STRINGS: YES
        CODE_SIGN_ENTITLEMENTS: {AppName}Widget/{AppName}Widget.entitlements
        CODE_SIGNING_ALLOWED: NO
        DEVELOPMENT_TEAM: 9L6N2ZF26B
        SKIP_INSTALL: YES
        LD_RUNPATH_SEARCH_PATHS:
          - "$(inherited)"
          - "@executable_path/Frameworks"
          - "@executable_path/../../Frameworks"
      configs:
        Debug:
          CODE_SIGNING_ALLOWED: NO
        Release:
          CODE_SIGNING_ALLOWED: YES
    entitlements:
      path: {AppName}Widget/{AppName}Widget.entitlements

  {AppName}Tests:
    type: bundle.unit-test
    platform: iOS
    sources:
      - path: {AppName}Tests
        excludes:
          - "**/.DS_Store"
    dependencies:
      - target: {AppName}
    settings:
      base:
        INFOPLIST_FILE: {AppName}Tests/Info.plist
        PRODUCT_BUNDLE_IDENTIFIER: com.ggsheng.{AppName}Tests
        PRODUCT_NAME: {AppName}Tests
        GENERATE_INFOPLIST_FILE: NO
        TEST_HOST: "$(BUILT_PRODUCTS_DIR)/$(TARGET_NAME).app/$(TARGET_NAME)"
        BUNDLE_LOADER: "$(TEST_HOST)"
        CODE_SIGN_STYLE: Automatic
        DEVELOPMENT_TEAM: 9L6N2ZF26B

  {AppName}UITests:
    type: bundle.ui-testing
    platform: iOS
    sources:
      - path: {AppName}UITests
        excludes:
          - "**/.DS_Store"
    dependencies:
      - target: {AppName}
    settings:
      base:
        INFOPLIST_FILE: {AppName}UITests/Info.plist
        PRODUCT_BUNDLE_IDENTIFIER: com.ggsheng.{AppName}UITests
        PRODUCT_NAME: {AppName}UITests
        GENERATE_INFOPLIST_FILE: NO
        TEST_TARGET: "$(BUILT_PRODUCTS_DIR)/$(TARGET_NAME).app/$(TARGET_NAME)"
        CODE_SIGN_ENTITLEMENTS: ""
        CODE_SIGN_STYLE: Automatic
        DEVELOPMENT_TEAM: 9L6N2ZF26B

schemes:
  {AppName}:
    build:
      targets:
        {AppName}: all
        {AppName}Widget: all
        {AppName}UITests: [test]
    run:
      config: Debug
    test:
      config: Debug
      targets:
        - {AppName}UITests
    archive:
      config: Release
```

---

## Stage 4：必需的文件 + Info.plist 预配置

### 4.1 主 App Info.plist（含预配置）

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>ITSAppUsesNonExemptEncryption</key>
    <false/>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>{AppStoreName}</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>$(MARKETING_VERSION)</string>
    <key>CFBundleVersion</key>
    <string>$(CURRENT_PROJECT_VERSION)</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
    </dict>
    <key>UILaunchScreen</key>
    <dict/>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>arm64</string>
    </array>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>{AppNameLower}</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

### 4.2 主 App Entitlements

> ⚠️ **根据 App 实际功能配置**：以下为完整模板，HealthKit 为健康类 App 必需。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.healthkit</key>
    <true/>
    <key>com.apple.developer.healthkit.access</key>
    <array/>
    <key>com.apple.developer.healthkit.background-delivery</key>
    <true/>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.ggsheng.{AppName}</string>
    </array>
</dict>
</plist>
```

> ⚠️ **Entitlements 组成说明**：
> - `com.apple.developer.healthkit` + `com.apple.developer.healthkit.access` + `com.apple.developer.healthkit.background-delivery`：**健康类 App 必须**
> - `com.apple.security.application-groups`：有 Widget 或 Extension 的 App 必须

### 4.3 Widget Info.plist

> ⚠️ **iOS 17+ Widget 模板更新**：使用 `NSExtensionAttributes` + `UnlockedParentApplicationIdentifiers` 替代旧的 `MinimumWidgetKitVersionInInfoPlist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>{AppName} Widget</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>XPC!</string>
    <key>CFBundleShortVersionString</key>
    <string>$(MARKETING_VERSION)</string>
    <key>CFBundleVersion</key>
    <string>$(CURRENT_PROJECT_VERSION)</string>
    <key>NSExtension</key>
    <dict>
        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.widgetkit-extension</string>
        <key>NSExtensionAttributes</key>
        <dict>
            <key>UnlockedParentApplicationIdentifiers</key>
            <array>
                <string>$(CFBundleIdentifier)</string>
            </array>
        </dict>
    </dict>
</dict>
</plist>
```

> ⚠️ **注意**：`UnlockedParentApplicationIdentifiers` 使用 `$(CFBundleIdentifier)` 引用主 App 的 Bundle ID，必须与主 App 的 `com.ggsheng.{AppName}` 匹配。

### 4.4 Widget Entitlements

> ⚠️ **Widget 不需要 HealthKit entitlements**，只需要 App Groups。Widget 和主 App 通过 App Group 共享数据，不能直接访问主 App 的 HealthKit 数据。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.ggsheng.{AppName}</string>
    </array>
</dict>
</plist>
```

### 4.5 AppIcon 图标设计规范（必读）

> 🚨 **【强制】iOS App UI 界面中使用的 App 图标，必须是 iOS App 发行及提交使用的 App 图标**
>
> - **App UI 中显示的图标 = App Store 提交的图标**，不允许使用不同的图标
> - 图标必须经过 Human 审核通过后才能用于 UI 开发
> - 禁止在 App UI 中临时使用占位符图标或与提交版本不一致的图标

#### 🚀 当前最惊艳图标设计趋势（2024-2026）

| 趋势 | 描述 | 适用场景 |
|------|------|---------|
| Glassmorphism | 毛玻璃 + 半透明 + 高斯模糊 | 专注/创意类App |
| Rich Gradients | 多色渐变、渐变网格、径向渐变 | 大多数App |
| Depth & Layers | 多层叠放 + 柔和阴影创造3D深度 | 生产力/工具类 |
| Neumorphism | 柔和内外阴影，元素"挤出"表面 | 金融/商务类 |
| Organic Shapes | 圆润blob形状、流动曲线 | 健康/社交类 |
| 3D Realism | 微妙的3D效果 + 光源统一 | 游戏/创意类 |
| Minimal Geometric | 极简几何、精确对齐、负空间 | 工具类App |
| Dark Mode First | 深色优先优化，深色背景突出 | 所有App |

**推荐组合**：Rich Gradients + Depth & Layers 或 Minimal Geometric + Neumorphism

#### 设计质量标准参照

| 标准/奖项 | 说明 |
|---------|------|
| **Apple Design Awards** | Apple 官方顶级设计奖项，质量金标准 |
| **Apple HIG - App Icons** | Human Interface Guidelines 图标章节，审核必查 |
| **Red Dot Design Award** | 国际权威工业设计奖 |
| **iF Design Award** | 国际权威设计奖 |

#### 图标生成 prompt 模板

```
Create a SINGLE, stunning Apple App Store icon for "[AppName]" - [App Description].

Design: [描述具体设计]
- 1024x1024 PNG
- Dark background (#0F0F14)
- Colors: violet (#9B8FE8), mint (#6EE7B7), amber (#FCD34D)
- Apple Design Awards quality
- No text
- Single unified design (NOT grid/composite)
- [具体设计描述]
```

### 4.5.1 AppIcon 在 App UI 中的引用与加载（必读 — 2026-06-02 经验沉淀）

> 🚨 **【强制】App UI 内部显示的 App 图标（About / Settings / 分享卡片等），必须加载真正的 App 发行图标，不允许使用占位符**
>
> - 禁止用「蓝紫渐变 + 通用 SF Symbol」或任何占位图作为 About 页的 App 图标
> - 禁止假设 `UIImage(named: "AppIcon")` 能工作 —— **iOS 11+ AppIcon 是特殊资产，不能用 `UIImage(named:)` 访问**
> - 验证方法：启动 App → 进入 About 页面 → 截图肉眼检查显示的是真实发行图标

#### ⚠️ 关键陷阱：构建后的 Bundle 不保留 `Assets.xcassets/` 目录

iOS 构建系统会把 `Assets.xcassets/` 编译成 `Assets.car`（二进制），**原始 xcassets 目录不会出现在 bundle 中**。这导致以下写法全部失效：

| 错误写法 | 失败原因 |
|---------|---------|
| `Bundle.main.url(forResource: "AppIcon", withExtension: "png")` | AppIcon 不是单一文件，路径不存在 |
| `Bundle.main.bundlePath + "/Assets.xcassets/AppIcon.appiconset/Icon-1024@1x.png"` | 该路径在 bundle 中不存在 |
| `UIImage(named: "AppIcon")` | iOS 11+ AppIcon 是特殊资产，不走普通 Image Set 查找 |

#### ✅ 正确做法：先读 `CFBundleIconFiles`，再扫 bundle 根 PNG

iOS 构建系统会从 Info.plist 读 `CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles`，并把对应 PNG **直接复制到 bundle 根目录**（如 `AppIcon60x60@2x.png`、`AppIcon76x76@2x~ipad.png`）。

**可靠的加载器模板**（适用于任何项目）：

```swift
import UIKit

final class AppIconLoader {
    static let shared = AppIconLoader()
    private(set) var iconImage: UIImage?

    private init() { iconImage = loadIcon() }

    private func loadIcon() -> UIImage? {
        if let img = loadFromInfoPlist() { return img }
        if let img = loadFromBundleRoot() { return img }
        return nil
    }

    private func loadFromInfoPlist() -> UIImage? {
        for key in ["CFBundleIcons", "CFBundleIcons~ipad"] {
            guard let icons = Bundle.main.object(forInfoDictionaryKey: key) as? [String: Any],
                  let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
                  let files = primary["CFBundleIconFiles"] as? [String] else { continue }
            // 按 @3x > @2x > 1x 优先级尝试
            let sorted = files.sorted { scaleRank($0) > scaleRank($1) }
            for name in sorted {
                if let img = UIImage(named: name) { return img }
            }
        }
        return nil
    }

    private func scaleRank(_ name: String) -> Int {
        if name.contains("@3x") { return 3 }
        if name.contains("@2x") { return 2 }
        return 1
    }

    private func loadFromBundleRoot() -> UIImage? {
        let candidates = [
            "AppIcon60x60@3x", "AppIcon60x60@2x",
            "AppIcon76x76@2x~ipad", "AppIcon76x76@1x~ipad", "AppIcon"
        ]
        let bundlePath = Bundle.main.bundlePath
        for name in candidates {
            for ext in ["png", "jpg"] {
                let path = "\(bundlePath)/\(name).\(ext)"
                if let img = UIImage(contentsOfFile: path) { return img }
            }
            if let img = UIImage(named: name) { return img }
        }
        return nil
    }
}
```

#### 验证 Bundle 内容（必查项）

```bash
# 构建后查看 bundle 根目录的 AppIcon PNG
APP_PATH=~/Library/Developer/Xcode/DerivedData/.../<AppName>.app
ls "$APP_PATH" | grep -i appicon
# 期望：AppIcon60x60@2x.png  AppIcon76x76@2x~ipad.png  Assets.car

# 同时验证 Info.plist 中的 CFBundleIconFiles
plutil -p "$APP_PATH/Info.plist" | grep -A 1 CFBundleIconFiles
# 期望：0 => "AppIcon60x60"
```

#### 截图验证（必查项）

1. 启动 App → 导航到 Settings → About 页面
2. 截图后用 vision 确认显示的是真实发行图标（带具体设计内容）
3. 如果看到「蓝紫渐变 + 心脏」这种通用占位符，**说明加载失败，必须修复**（属于 HR-22 类违规）

---

### 4.6 AppIcon Contents.json（标准 19 项格式）

```json
{
  "images" : [
    { "filename" : "Icon-20@1x.png", "idiom" : "universal", "platform" : "ios", "scale" : "1x", "size" : "20x20" },
    { "filename" : "Icon-20@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "20x20" },
    { "filename" : "Icon-20@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "20x20" },
    { "filename" : "Icon-29@1x.png", "idiom" : "universal", "platform" : "ios", "scale" : "1x", "size" : "29x29" },
    { "filename" : "Icon-29@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "29x29" },
    { "filename" : "Icon-29@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "29x29" },
    { "filename" : "Icon-40@1x.png", "idiom" : "universal", "platform" : "ios", "scale" : "1x", "size" : "40x40" },
    { "filename" : "Icon-40@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "40x40" },
    { "filename" : "Icon-40@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "40x40" },
    { "filename" : "Icon-58@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "29x29" },
    { "filename" : "Icon-58@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "29x29" },
    { "filename" : "Icon-76@1x.png", "idiom" : "universal", "platform" : "ios", "scale" : "1x", "size" : "76x76" },
    { "filename" : "Icon-76@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "76x76" },
    { "filename" : "Icon-80@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "40x40" },
    { "filename" : "Icon-80@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "40x40" },
    { "filename" : "Icon-83.5@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "83.5x83.5" },
    { "filename" : "Icon-120@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "60x60" },
    { "filename" : "Icon-120@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "60x60" },
    { "filename" : "Icon-1024@1x.png", "idiom" : "universal", "platform" : "ios", "size" : "1024x1024" },
    { "idiom" : "ipad", "scale" : "1x", "size" : "167x167" },
    { "idiom" : "ipad", "scale" : "2x", "size" : "167x167" }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
```

> ⚠️ **iPad Pro 167x167 图标**：iOS 17+ iPad Pro 必须包含。

### 4.7 AccentColor Contents.json

```json
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.345",
          "green" : "0.780",
          "red" : "0.204"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
```

---

## Stage 5：XcodeGen 生成项目

### 5.1 生成命令

```bash
cd ~/Desktop/ios-{AppName}
~/tools/xcodegen/bin/xcodegen generate
```

**成功输出：**
```
⚙️  Writing project...
Created project at /Users/.../ios-{AppName}/{AppName}.xcodeproj
```

### 5.2 验证生成结果

```bash
# 确认 target 名称
grep -E 'name = [A-Z][A-Za-z]+;' {AppName}.xcodeproj/project.pbxproj \
  | grep -v 'PRODUCT_BUNDLE\|PRODUCT_NAME\|CODE_SIGN' \
  | head -10

# 确认 signing 配置
grep -B2 -A5 'buildConfiguration.*Release' {AppName}.xcodeproj/project.pbxproj \
  | grep CODE_SIGNING_ALLOWED

# 确认 Bundle ID
grep 'PRODUCT_BUNDLE_IDENTIFIER' {AppName}.xcodeproj/project.pbxproj
```

### 5.3 XcodeGen 生成失败处理

| 错误症状 | 排查步骤 |
|---------|---------|
| **YAML 格式错误** | 在本地执行 `python3 -c "import yaml; yaml.safe_load(open('project.yml'))"` 检查 YAML 语法 |
| **路径引用错误** | 检查 project.yml 中的 `path:` 字段是否与实际文件夹名完全一致（区分大小写）|
| **xcodegen 版本不匹配** | 执行 `~/tools/xcodegen/bin/xcodegen --version`，确认版本 ≥ 2.25 |
| **pbxproj 损坏** | 删除旧 `.xcodeproj` 后重新生成：`rm -rf {AppName}.xcodeproj && ~/tools/xcodegen/bin/xcodegen generate` |

### 5.4 版本号管理规则

> ⚠️ **【强制】Apple 要求每次 Archive 时 CURRENT_PROJECT_VERSION 必须 +1**

| 场景 | MARKETING_VERSION | CURRENT_PROJECT_VERSION |
|------|:--|:--|
| **新 App 首次创建/提交** | **3.0.0** | **1** |
| **每次 Archive（无论有无功能变更）** | 不变 | **必须 +1** |
| 功能/内容变更 | 递增（Minor/Major） | **必须 +1** |

**规则**：
- `CURRENT_PROJECT_VERSION`：**每次 Archive 时必须 +1**，这是 Apple 的强制要求，与功能变更是两个独立维度
- `MARKETING_VERSION`：仅在功能/内容变更时递增
- **新 App 必须从 `3.0.0` + `1` 开始**
- 递增顺序：`1` → `2` → `3` → ...（每次 Archive 递增）

### 5.5 完整变更流程（必须遵守）

```
┌─────────────────────────────────────────────────────┐
│  本地修改 project.yml / 源码 / 资源文件              │
│  同步更新 AppStore/ 目录（截图、设计文档等）         │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  Claude Code **审查 + 修复**：分析源码，修复所有问题  │
│  必须重复执行直到无问题为止                        │
│  检查项：语法错误、逻辑问题、API 误用、内存泄漏   │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  git add -A → git commit → git push origin main    │
│  ⚠️ 必须包含所有变更：源码、设计文件、文档、图标   │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  rm -rf ~/Library/Developer/Xcode/DerivedData/*    │
│  ~/tools/xcodegen/bin/xcodegen generate             │
│  xcodebuild clean                                   │
│  xcodebuild build -project {AppName}.xcodeproj     │
│    -scheme {AppName} -configuration Debug          │
│    -destination 'platform=iOS Simulator,name=...'  │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  Claude Code **再次审查** 构建输出                   │
│  如有错误：修复后重新 push → build                  │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  ✅ BUILD SUCCEEDED                                 │
└─────────────────────────────────────────────────────┘
```

---

## Stage 6：App Store 截图制作

### 6.0 截图工作流概述

> ⚠️ **【强制】截图数量 = App页面数 × 3个设备**
> - **最少数量**：每个上传区域 3 张（3个区域共9张）
> - **建议数量**：每个 App 页面 × 3 个设备（如 App 有 4 个 Tab，则 4×3=12 张）

**截图设备清单（3个）：**

| 设备 | 模拟器 | 模拟器实际尺寸 | Apple 上传尺寸 | 上传区域 |
|------|--------|--------------|---------------|----------|
| iPhone 17 Pro Max | iPhone 17 Pro Max | 1206×2622 | 1320×2868 | 6.7" |
| iPad Pro 13" (M4) | iPad Pro 13-inch (M4) | 2064×2752 | 2048×2732 | 13" |
| Apple Watch Ultra 3 | Apple Watch Ultra 3 (49mm) | 430×484 | 396×484 | Watch |

🤖 **AI Agent 操作**：

**工作流：**
1. **创建专用 XCUITest 文件**（`<AppName>UITests.swift`），包含 3 个设备的测试类
2. **启动 iPhone 和 iPad 模拟器**（分别 boot）
3. **运行 XCUITest 并截图**（使用 `xcrun simctl io booted screenshot` 保存到 `/tmp/`）
4. **调整截图尺寸**（使用 `sips -z` 命令调整到 Apple 上传尺寸）
5. **调整截图尺寸**（使用 `sips -z` 命令调整到 Apple 上传尺寸）
6. **iPad 截图由 Human 手动截取**，命名无要求，只需尺寸正确（2048×2732）
7. **复制到 AppStore/Screenshots 目录**（按分辨率子目录分类）
8. **提交到 GitHub**

> ⚠️ **【强制】禁止截图作弊行为**：
> - **禁止使用同一张截图复制多份**
> - **禁止使用非模拟器截图**
> - **所有截图必须来自真实模拟器运行**，且每张截图内容必须明显不同

### 6.1 App Store 截图尺寸要求（必须符合最新 Apple 规范）

#### 截图设备规则（强制）

> ⚠️ **【强制】仅限以下 3 种设备截图**：
> 1. **iPhone 17 Pro Max** - 模拟器
> 2. **iPad Pro 13-inch (M4)** - 模拟器
> 3. **Apple Watch Ultra 3 (49mm)** - 模拟器
>
> **禁止使用其他设备截图！**

> ⚠️ **【强制】所有设备必须使用 Point Accurate 模式**：
> ```bash
> # 启用 Point Accurate 模式
> xcrun simctl statusbar <device_id> --pointingAccuracy=precise
> ```
> 或在 Xcode UI 中：**Window → Show Device Bezels → 点击模拟器 → Features → Pointing Accuracy → Precise**

> ⚠️ **【强制】截图目录命名规则**（必须与设备名称一致）：
> ```
> AppStore/Screenshots/
> ├── iPhone17ProMax_1320x2868/      # iPhone 17 Pro Max 截图（UITest 自动截取）
> ├── iPadPro13inchM4_2048x2732/     # iPad Pro 13-inch (M4) 截图（**人类手动截取**）
> ├── AppleWatchUltra3_396x484/      # Apple Watch Ultra 3 截图（UITest 自动截取）
> └── InAppPurchase/                # 内购截图
> ```

| 设备 | 模拟器实际尺寸 | Apple 上传尺寸 | 尺寸调整命令 | 上传目录 | 截图方式 |
|------|---------------|---------------|-------------|----------|----------|
| **iPhone 17 Pro Max** | 1206×2622 | 1320×2868 | `sips -z 2868 1320` | `iPhone17ProMax_1320x2868/` | UITest 自动 |
| **iPad Pro 13-inch (M4)** | 2064×2752 | 2048×2732 | `sips -z 2732 2048` | `iPadPro13inchM4_2048x2732/` | **人类手动截取** |
| **Apple Watch Ultra 3** | 430×484 | 396×484 | `sips -z 484 396` | `AppleWatchUltra3/` | UITest 自动 |

> ⚠️ **【重要】截图尺寸调整**：
> - iPhone 17 Pro Max：1206×2622 → 1320×2868（宽高互换）
> - iPad Pro 13" (M4)：2064×2752 → 2048×2732（等比例缩小）
> - Apple Watch Ultra 3：430×484 → 396×484（等比例缩小）

> ⚠️ **【强制】MD5 验证**：每张截图必须有唯一 MD5 值，证明内容不同。验证命令：
> ```bash
> md5 /tmp/*.png  # 所有 MD5 必须不同
> ```

> ⚠️ **【强制】禁止截图作弊行为**：
> - **禁止使用同一张截图复制多份**
> - **禁止使用非模拟器截图**
> - **所有截图必须来自真实模拟器运行**，且每张截图内容必须明显不同

### 6.1.1 内购审核截图要求（Apple 强制要求）

> ⚠️ **【强制】Apple 要求内购审核截图必须通过真实的 XCUITest 从模拟器截取**

**规则**：
- 每款内购产品必须上传至少 **1 张审核截图**
- 截图必须是**真实的模拟器截图**，**禁止使用设计稿、Mockup 或人工制作的假截图**
- 截图必须**显示真实的购买界面**

### 6.2 XCUITest 截图完整流程

#### Step 3: 启用 Point Accurate 模式

```bash
# iPhone 17 Pro Max
xcrun simctl boot 'iPhone 17 Pro Max'

# iPad Pro 13-inch (M4)
xcrun simctl boot 'iPad Pro 13-inch (M4)'

# Apple Watch Ultra 3 (49mm)
xcrun simctl boot 'Apple Watch Ultra 3 (49mm)'
```

> ⚠️ **【强制】Point Accurate 模式**：在 Xcode UI 中确保模拟器设置为 Point Accurate 模式，以保证截图尺寸精确。
> 设置方式：**Window → Point Accurate** 或使用命令行 `xcrun simctl statusbar <device_id> --pointingAccuracy=precise`

#### Step 2: 创建专用截图测试文件

```swift
import XCTest

final class ScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        Thread.sleep(forTimeInterval: 2.0)
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func capture(_ name: String) {
        let path = "/tmp/\(name).png"
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: path))
    }

    func tapTab(identifier: String) {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        let button = app.buttons.matching(predicate).firstMatch
        if button.exists {
            button.tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
    }

    // MARK: - <AppName> iPhone 截图 (1206×2622 模拟器 → 放大到 1320×2868)
    func testCapture_iPhone_01_Pocket() {
        // Tab 1: Pocket (首页) - XP进度条 + 今日任务 + 健康卡组
        capture("<AppName>_iPhone_01_Pocket")
    }

    func testCapture_iPhone_02_Habits() {
        // Tab 2: Habits - 习惯打卡列表
        tapTab(identifier: "tab_habits")
        capture("<AppName>_iPhone_02_Habits")
    }

    func testCapture_iPhone_03_Coach() {
        // Tab 3: Coach - AI教练对话
        tapTab(identifier: "tab_coach")
        capture("<AppName>_iPhone_03_Coach")
    }

    func testCapture_iPhone_04_Collection() {
        // Tab 4: Collection - 图鉴
        tapTab(identifier: "tab_collection")
        capture("<AppName>_iPhone_04_Collection")
    }

    func testiPhone_69_02_History() {
        tapTab(identifier: "tab_history")
        capture("iPhone_69_portrait_02_History")
    }

    // MARK: - iPad 截图 (13" - 2048×2732)
    func testiPad_13_01_Home() {
        capture("iPad_13_portrait_01_Home")
    }

    func testiPad_13_02_History() {
        tapTab(identifier: "tab_history")
        capture("iPad_13_portrait_02_History")
    }
}
```

#### Step 3: 启动模拟器并运行测试

```bash
# iPhone 17 Pro Max 截图 (实际 1206×2622 → 需要放大到 1320×2868)
xcrun simctl boot 'iPhone 17 Pro Max' 2>/dev/null || true
sleep 3

xcodebuild test -project {AppName}.xcodeproj -scheme {AppName} \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
  -only-testing:{AppName}UITests/ScreenshotTests

# iPad 13" 截图
xcrun simctl boot 'iPad Pro 13-inch (M4)' 2>/dev/null || true
sleep 3

xcodebuild test -project {AppName}.xcodeproj -scheme {AppName} \
  -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M4)' \
  -only-testing:{AppName}UITests/ScreenshotTests
```

#### Step 4: 验证截图内容不同（MD5 验证）

```bash
# 模拟器截图路径 (实际尺寸)
# iPhone 17 Pro Max: 1206×2622
ls /tmp/<AppName>_iPhone_*.png

# 调整尺寸后上传路径 (1320×2868)
mkdir -p AppStore/Screenshots/iPhone17Pro/
for f in /tmp/<AppName>_iPhone_*.png; do
  # 放大并裁剪到 1320×2868
  sips -z 2868 1320 "$f" --out "AppStore/Screenshots/iPhone17Pro/$(basename $f)"
done

# iPad 13" 截图 (2048×2732)
ls /tmp/<AppName>_iPad_*.png
mkdir -p AppStore/Screenshots/iPadPro13/
cp /tmp/<AppName>_iPad_*.png AppStore/Screenshots/iPadPro13/
```

### 6.3 Tab 切换失败问题排查

> ✅ **SC-03: Tab identifier 添加检查**
**问题症状：** 所有截图都是首页，Tab 切换完全无效。

**根本原因：**

| 错误原因 | 说明 | 解决 |
|---------|------|------|
| `app.tabBar` 单数 | SwiftUI 用 `app.tabBars`（复数）不是 `app.tabBar`（单数）| 用 `app.tabBars` |
| iPad floating tab bar | iPad 上每个 Tab 创建多个重叠元素 | 用 `accessibilityIdentifier` + `NSPredicate` + `firstMatch` |
| App 未完全加载 | App 启动后 viewController 尚未完全加载 | `Thread.sleep(2.0)` 等待 App 稳定 |
| accessibilityIdentifier 缺失 | 没有明确的 identifier，定位不稳定 | **App 源码必须给 TabBarItem 添加 `accessibilityIdentifier`** |

**第一步：App 源码必须给每个 TabBarItem 添加 `accessibilityIdentifier`**

```swift
TabView {
    HomeView()
        .tabItem { Label("Home", systemImage: "house") }
        .accessibilityIdentifier("tab_home")

    HistoryView()
        .tabItem { Label("History", systemImage: "clock") }
        .accessibilityIdentifier("tab_history")
}
```

**第二步：XCUITest 使用 NSPredicate + firstMatch 精确匹配**

```swift
func tapTab(identifier: String) {
    let predicate = NSPredicate(format: "identifier == %@", identifier)
    let button = app.buttons.matching(predicate).firstMatch

    if button.exists {
        button.tap()
        Thread.sleep(forTimeInterval: 2.0)
        return
    }
    print("WARNING: Could not find tab button: \(identifier)")
}
```

#### iPad 截图：人类手动截取

> ⚠️ **iPad 截图由人类手动截取，Agent 不处理**
>
> **操作步骤**：
> 1. 启动 iPad Pro 13-inch (M4) 模拟器
> 2. 手动切换到不同 Tab（4 个 Tab：Pocket / Habits / Coach / Collection）
> 3. 使用 `Cmd+S` 或 `xcrun simctl io booted screenshot /tmp/ipad.png` 截图
> 4. 放入目录：`~/Desktop/<AppRepoDir>/AppStore/Screenshots/iPadPro13inchM4_2048x2732/`
> 5. 尺寸要求：**2048×2732**，无命名强制要求
> 6. 建议截取 4 张不同 Tab 的截图

### 6.4 截图文件名规范

```
AppStore/Screenshots/
├── iPhone17ProMax_1320x2868/
│   ├── 01_Home.png
│   ├── 02_History.png
│   ├── 03_Stats.png
│   └── ...
├── iPadPro13inchM4_2048x2732/
│   ├── 01_Home.png
│   ├── 02_History.png
│   └── ...
```

---

## Stage 6 附加：测试与录屏（可选）

> ⚠️ **录屏是可选的，不是必选项**。如果 App 功能无法通过截图展示清楚，再考虑录屏。

### 测试代码要求

- **Unit Tests**：覆盖所有 Model 的初始化、编解码、业务计算
- **执行方式**：`xcodebuild test -project {AppName}.xcodeproj -scheme {AppName}`

### 录屏（可选）

如果需要 App Preview 视频，可通过 XCUITest 截图 + ffmpeg 合成。规格：
- MP4/MOV，最大 30 秒，最大 100MB，H.264，分辨率与截图一致
- **不需要音频**

---

## Stage 7：Widget 数据共享 / Beta 测试

### 7.1 App Groups 配置

**主 App 写入：**
```swift
let sharedDefaults = UserDefaults(suiteName: "group.com.ggsheng.AppName")
sharedDefaults?.set(encodedData, forKey: "habits")
sharedDefaults?.synchronize()
```

**Widget 读取：**
```swift
let sharedDefaults = UserDefaults(suiteName: "group.com.ggsheng.AppName")
let data = sharedDefaults?.data(forKey: "habits")
```

**entitlements 必须包含 App Group：**
```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.ggsheng.AppName</string>
</array>
```

---

### 7.2 Beta 测试（TestFlight）

👨 **Human 操作**：
1. Archive 打包后，通过本地 Xcode Organizer 上传 TestFlight
2. 邀请内部测试员（至少 1 名）进行功能验证

🤖 **AI Agent 操作**：
3. 修复 Beta 测试发现的 Bug

👨 **Human 操作**：
4. Beta 测试通过后才能提交 App Store 审核

---

## Stage 8：App Store Connect 上传

### 8.1 App Store 上架提交（Human 通过本地 Xcode GUI 操作）

> ⚠️ **App Store 上架提交必须由 Human 通过本地 Xcode GUI 完成**

👨 **Human 操作步骤**：
1. 打开本地 Xcode，打开 `{AppName}.xcodeproj`
2. 顶部 scheme 选择 `{AppName}`
3. **Product → Archive**
4. Archive 完成 → **Window → Organizer** 打开
5. 选中 archive → **Distribute → App Store Connect → Sign and Upload**
6. Team 选择 **ZhiFeng Sun (9L6N2ZF26B)**
7. 等待上传完成 → **Validate App** 验证

### 8.2 App Store Connect 填写

| 字段 | 填写内容 |
|------|---------|
| App Name | `{AppStoreName}` |
| Bundle ID | `com.ggsheng.{AppName}` |
| Category | **见下方类别选择指南** |
| Price | {Free / $金额} |
| Privacy Policy URL | `https://lauer3912.github.io/ios-{AppName}/docs/PrivacyPolicy.html` |
| Terms of Service URL | `https://lauer3912.github.io/ios-{AppName}/docs/TermsOfService.html` |

#### App Store 主类别选择指南

| App 类型 | 推荐主类别 | 说明 |
|---------|-----------|------|
| 番茄钟/专注计时 | **Productivity** | 效率工具 |
| 习惯追踪/待办事项 | **Productivity** | 效率工具 |
| 睡眠追踪/健康管理 | **Health & Fitness** | 健康与健身 |
| 财务记账/预算 | **Finance** | 财务 |
| 音乐播放/白噪音 | **Productivity** 或 **Music** | 效率/音乐 |
| 噪音检测/报警 | **Utilities** | 工具类 |
| 饮水追踪 | **Health & Fitness** | 健康与健身 |
| 抉择器/随机选择 | **Utilities** | 工具类 |

### 8.3 App 隐私配置

| App 类型 | 健康/健身 | 位置 | 联系信息 | 标识用户 | 购买行为 |
|---------|---------|------|---------|---------|---------|
| **番茄钟/专注计时** | ❌ | ❌ | ❌ | ❌ | ❌ |
| **习惯追踪** | ❌ | ❌ | ❌ | ❌ | ❌ |
| **睡眠追踪** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **财务记账（内购）** | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## Stage 8 续：完整功能要求

### 8.4 隐私政策和服务条款要求

> ✅ **SC-05: ITSAppUsesNonExemptEncryption 预配置检查**
> ✅ **SC-02: 隐私政策 HTML 有效性检查**
> ✅ **SC-02: 服务条款 HTML 有效性检查**
> ✅ **SC-33: 联系邮箱规范性检查**（v7 新增）

**隐私政策必须包含**：
1. 数据收集：App 收集哪些数据
2. 数据使用：数据如何被使用
3. 数据存储：数据存储在哪里，是否加密
4. 用户权利：用户如何删除数据
5. 联系方式：**必须使用 `privacy@techidaily.com` 作为隐私问题专用邮箱**（不可用 support 代替）
6. 儿童隐私：是否面向 13 岁以下儿童
7. 第三方服务：如果有广告或分析，说明

**服务条款必须包含**：
1. 服务说明：App 提供哪些功能和服务
2. 使用条件：用户必须遵守的使用条款
3. 知识产权：App 内容的所有权说明
4. 免责声明：服务按"现状"提供，不提供任何保证
5. 联系方式：**必须使用 `legal@techidaily.com` 作为法律问题专用邮箱**（不可用 support 代替）
6. AI 服务使用条款：如果 App 使用 AI 功能，必须明确说明
7. 订阅条款：如果 App 有内购，必须说明订阅条款和取消方式

#### 8.4.0 联系邮箱规范（必读 — 2026-06-02 确认）

> 🚨 **【强制】所有法律文档中的联系邮箱必须使用以下专用邮箱，不可用通用 support 邮箱代替**

| 文档 | 必须使用的邮箱 | 用途 | 错误示例 |
|------|---------------|------|---------|
| **Privacy Policy** | `privacy@techidaily.com` | 隐私数据问题 / GDPR 请求 / CCPA 请求 | ❌ `support@techidaily.com` |
| **Terms of Service** | `legal@techidaily.com` | 法律条款问题 / 服务争议 / 知识产权 | ❌ `support@techidaily.com` |
| **App Store Connect Contact Email** | `support@techidaily.com` | Apple 审核员联系 | — |
| **App 内 Settings 「Contact Support」** | `support@techidaily.com` | App 功能问题 / Bug 反馈 | — |

**验证方法**：

```bash
# 检查 Privacy Policy HTML 中是否使用正确邮箱
grep -i "privacy@" Sources/Resources/Docs/PrivacyPolicy.html
# 期望输出: privacy@techidaily.com

# 检查 Terms of Service HTML 中是否使用正确邮箱
grep -i "legal@" Sources/Resources/Docs/TermsOfService.html
# 期望输出: legal@techidaily.com

# 检查代码中是否使用错邮箱（例：privacy 文档里出现 support@techidaily.com）
grep -i "support@techidaily.com" Sources/Resources/Docs/PrivacyPolicy.html
# 期望输出: 无匹配
```

#### 8.4.1 GDPR / CCPA 合规检查清单

##### GDPR（欧盟通用数据保护条例）合规

| 检查项 | 实现方式 |
|-------|---------|
| **知情权** | 隐私政策中明确说明：收集哪些数据、为何收集、存储在哪里 |
| **访问权** | 提供用户查看个人数据的功能（设置页面"查看我的数据"按钮）|
| **更正权** | 允许用户修改/更正个人数据 |
| **删除权（被遗忘权）** | 提供账号删除或数据清除功能（设置页面"删除所有数据"按钮）|
| **数据可携带权** | 提供用户数据导出功能（JSON/CSV），设置页面"导出数据"按钮 |

##### CCPA（加州消费者隐私法）合规

| 检查项 | 实现方式 |
|-------|---------|
| **知情权** | 隐私政策中说明收集的个人信息类别和用途 |
| **删除权** | 提供删除个人数据的途径 |
| **选择退出权** | 提供"不出售我的个人信息"选项 |

##### 用户数据删除功能实现

```swift
class DataDeletionManager {
    static let shared = DataDeletionManager()

    func deleteAllUserData() {
        // 1. 清除 UserDefaults
        let defaults = UserDefaults.standard
        defaults.dictionaryRepresentation().keys.forEach { defaults.removeObject(forKey: $0) }

        // 2. 清除 App Group UserDefaults（如有 Widget/Extension）
        if let groupDefaults = UserDefaults(suiteName: "group.com.ggsheng.{AppName}") {
            groupDefaults.dictionaryRepresentation().keys.forEach { groupDefaults.removeObject(forKey: $0) }
        }

        // 3. 删除本地数据库
        deleteLocalDatabase()

        // 4. 清除 Keychain 数据
        clearKeychain()
    }

    func exportUserData() -> URL? {
        let exportData: [String: Any] = [
            "exportDate": ISO8601DateFormatter().string(from: Date()),
            "userData": gatherAllUserData()
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted) else {
            return nil
        }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("user_data_export_\(Date().timeIntervalSince1970).json")
        try? jsonData.write(to: url)
        return url
    }
}
```

---

### 8.4.2 App 内嵌显示 Privacy Policy / Terms of Service（必读 — 2026-06-02 经验沉淀）

> 🚨 **【强制】Privacy Policy 和 Terms of Service 必须在 App 内嵌显示，不允许只放外链**
>
> - 模拟器无网环境、飞机模式、用户弱网 → **外链全部失效**
> - Apple App Store 审核 5.1.1 条款要求隐私政策**在 App 内可访问**（不依赖外网）
> - 仅用 `Link(destination: URL(string: "https://..."))` = **绝对禁止**

#### ⚠️ 关键陷阱：`Link` 外链 = 提交审核雷区

- iOS Simulator 默认无网络环境 → 点击 Link → 浏览器打不开 → 用户看到“页面打不开”
- 飞机模式、弱网环境 → 同样失败
- Apple 审核员可能在离线环境测试，看到“无法访问隐私政策” → 5.1.1 拒绝
- 真实案例（VitaPocket 2026-06-02）：发布前发现 About 页面 Legal 链接打不开，佛罗多老爷提出后才修复

#### ✅ 正确做法：HTML 资源进 Bundle + WKWebView 本地加载

**Step 1: HTML 资源放进项目**

```
ios-{AppName}/
├── Sources/
│   └── Resources/
│       └── Docs/                  # 新建
│           ├── PrivacyPolicy.html
│           └── TermsOfService.html
```

**Step 2: project.yml 注册 folder 资源（必须用 `type: folder`）**

```yaml
targets:
  {AppName}:
    sources:
      - path: Sources
    resources:
      - path: Sources/Resources/Assets.xcassets
      - path: Sources/Resources/Docs        # ← 新增
        type: folder                        # ← 关键：保留原始目录结构
```

**Step 3: SwiftUI WebView 包装 + LegalDocumentView**

```swift
import SwiftUI
import WebKit

struct LocalWebView: UIViewRepresentable {
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.bounces = true
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = url else { return }
        if webView.url != url {
            // 第二个参数必须指定允许访问的目录，WKWebView 安全要求
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
}

struct LegalDocumentView: View {
    enum Document {
        case privacyPolicy, termsOfService
        var fileName: String {
            switch self {
            case .privacyPolicy: return "PrivacyPolicy"
            case .termsOfService: return "TermsOfService"
            }
        }
        var title: String { /* ... */ }
    }
    
    let document: Document
    
    var body: some View {
        LocalWebView(url: bundleURL())
            .navigationTitle(document.title)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func bundleURL() -> URL? {
        if let url = Bundle.main.url(forResource: document.fileName, withExtension: "html") {
            return url
        }
        return nil
    }
}
```

**Step 4: SettingsView / AboutView 用 NavigationLink 跳转（不是 Link）**

```swift
// ❌ 错误：外链，模拟器/弱网环境打不开
Link(destination: URL(string: "https://example.com/privacy")!) {
    Label("Privacy Policy", systemImage: "hand.raised")
}

// ✅ 正确：内嵌，離线可用，App Store 审核合规
NavigationLink {
    LegalDocumentView(document: .privacyPolicy)
} label: {
    Label("Privacy Policy", systemImage: "hand.raised")
}
```

#### 验证清单（必查项）

```bash
# 1. HTML 文件在 bundle 中
APP_PATH=~/Library/Developer/Xcode/DerivedData/.../{AppName}.app
ls "$APP_PATH" | grep -i html
# 期望：PrivacyPolicy.html  TermsOfService.html

# 2. 模拟器启动后，导航到 Settings → About → Privacy Policy
# 3. 截图确认 HTML 渲染正常（标题、正文、样式都正常）
# 4. 开启飞行模式重测 → 仍可访问 → 说明是本地 bundle 资源
```

#### 与 GitHub Pages URL 的关系（不冲突）

| 用途 | 方式 | 必须性 | 依据 |
|------|------|--------|------|
| **App Store Connect 隐私政策 URL 字段** | 外链（GitHub Pages） | 必填 | HR-35 |
| **App 内显示的隐私政策 / 服务条款** | **内嵌（Bundle + WKWebView）** | **必填** | 本节（HR-45） |

> 两者**必须同时实现**：App Store Connect 上传时需要 URL（外部审核员会点击），App 内跳转时需要本地内嵌（用户离线和审核场景）。

#### HTML 文档内必须使用专用邮箱（v7 新增）

**内嵌的 Privacy Policy HTML 末尾联系邮箱必须是 `privacy@techidaily.com`**

**内嵌的 Terms of Service HTML 末尾联系邮箱必须是 `legal@techidaily.com`**

---

### 8.4.3 GitHub Pages 部署实战经验（必读 — 2026-06-03 经验沉淀）

> **【强制】Privacy Policy / Terms of Service URL 在 App Store Connect 上填入前必须实际 `curl -I` 验证返回 200。坑有 3 个，不分项目均会遇到**

VitaMindGo 2026-06-03 为准备 App Store 提交检查 Privacy Policy URL，发现以下 3 个连环坑，耗时 90 分钟才全部理清。

#### 坑 1：GitHub Pages 在 repo rename 时被自动关闭

**现象**：
- 仓库从 `ios-VitaMind` rename 为 `ios-VitaMindGo`
- 旧 repo URL `github.com/lauer3912/ios-VitaMind` 自动 301 redirect 到新 URL ✅
- 但 GitHub Pages 配置 **不迁移** —— 新 repo `pages.enabled = false` ❌
- 实际：所有 `<lauer3912>.github.io/ios-VitaMind*` URL 全部 404

**诊断**：
```bash
curl -sI https://api.github.com/repos/lauer3912/ios-VitaMindGo/pages
# 返回 status=404 (Pages 根本没启用)
```

**修复**：
```bash
GH_TOKEN=... 
curl -X POST -H "Authorization: token $GH_TOKEN" \
  https://api.github.com/repos/lauer3912/ios-VitaMindGo/pages \
  -d '{"source":{"branch":"main","path":"/docs"},"build_type":"legacy"}'
# 返回 status=built 后才能用
```

#### 坑 2：GitHub Pages "Project Pages" mode path 映射不直观

**现象**：
- source = `main /docs` 配置
- 仓库内文件 `docs/PrivacyPolicy.html`
- 期望 URL: `https://lauer3912.github.io/ios-VitaMindGo/docs/PrivacyPolicy.html` ❌ 404
- 实际 URL: `https://lauer3912.github.io/ios-VitaMindGo/PrivacyPolicy.html` ✅ 200

**原因**："Project Pages" mode 总是把 `docs/` (或 source 配置的目录) **作为根** 供出来，不保留 source path。

**修复**：
- 重新检查所有 Legal Policy / ToS URL，删除误加的 `/docs/` 前缀
- 在 naming-check.sh 中加自检
- Listing.md 改用 `https://lauer3912.github.io/ios-VitaMindGo/PrivacyPolicy.html`（不是 `/docs/PrivacyPolicy.html`）

#### 坑 3：CDN 传播延迟（build 后不能立刻测）

**现象**：
- Build status 变为 `built`（API 返回）
- 但 `curl https://lauer3912.github.io/.../PrivacyPolicy.html` 仍返回 404
- 需等 30-180 秒 CDN deploy

**修复**：
```bash
# Poll until 200
for i in 1 2 3 4 5 6 7 8 9 10; do
  sleep 10
  STATUS=$(curl -sI "$URL" | head -1)
  echo "  attempt $i: $STATUS"
  if echo "$STATUS" | grep -q "200"; then break; fi
done
```

#### 链式错误检测清单（App Store 提交前必跑）

```bash
#!/bin/bash
# SC-61: GitHub Pages 部署链路检查
set -e

REPO="ios-VitaMindGo"  # 换为你的 repo
BRANCH="main"
DOCS_PATH="docs"

echo "=== 1) GitHub Pages 启用状态 ==="
curl -sI -H "Authorization: token $GH_TOKEN" \
  "https://api.github.com/repos/lauer3912/$REPO/pages" | head -1

echo "=== 2) 最新 build 状态 ==="
curl -s -H "Authorization: token $GH_TOKEN" \
  "https://api.github.com/repos/lauer3912/$REPO/pages/builds/latest" \
  | python3 -c "import json, sys; d = json.load(sys.stdin); print(f'status={d.get(\"status\")}, commit={d.get(\"commit\",\"\")[:7]}, duration={d.get(\"duration\")}s')"

echo "=== 3) URL 可达 (选 3 个关键 URL) ==="
for u in "https://lauer3912.github.io/$REPO/PrivacyPolicy.html" \
         "https://lauer3912.github.io/$REPO/TermsOfService.html" \
         "https://lauer3912.github.io/$REPO/"; do
  STATUS=$(curl -sI "$u" | head -1)
  echo "  $u  → $STATUS"
done

echo "=== 4) 旧 URL 状态 (VitaMindGo 2026-06-04 手动删后期望 404) ==="
# 删后: status 404
# 未删: status 301 (rename redirect)
# 两者任一即合规
OLD_REPO="ios-VitaMind"
curl -sI "https://lauer3912.github.io/$OLD_REPO/" | head -2
```

#### HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-79** | **禁止 App Store Connect URL 填入前不验证 200** - 4 个 URL (Privacy / Terms / Developer Website / Support) 必测 `curl -I` 返回 200，提交后审核员点击 404 会被拒 | §8.4.3 |
| **HR-80** | **禁止 GitHub Pages URL 误用 source path 前缀** - "Project Pages" mode (source=main/docs) 将 docs/ 作为 repo URL 根，URL 中不要带 `/docs/` 前缀 | §8.4.3 坑 2 |
| **HR-81** | **禁止 repo rename 后不检查 GitHub Pages 状态** - rename 不自动迁移 Pages 配置，必须 POST `/pages` 重新启用 | §8.4.3 坑 1 |
| **SC-61** | **GitHub Pages 部署链路检查** - 跑 §8.4.3 链式错误检测脚本：① Pages enabled ② latest build status=built ③ 4 个 URL 全部 200 ④ 旧 URL 301 | §8.4.3 |

#### 其他坑（vitaPocket / VitaMindGo 实战总结）

| 坑 | 原因 | 检测方法 |
|----|------|----------|
| `nslookup techidaily.com` 失败 ≠ 域名不存在 | 公网 DNS 解析受限 (macOS 100.100.100.100) | 用 `curl https://...` 实际访问测试 (不走 DNS) |
| Bundle ID 改动 = 重新发布 | App Store Connect 不允许改已上架 App 的 Bundle ID | HR-77 禁改 |
| 旧 repo rename 后**不会**自动删除 | GitHub repo rename 仅是 301 redirect，原 repo 仍可访问 (含 commit / branches / Pages config redirect) | 需手动 delete (lauer3912 计划 2026-06-04 手动删) |



> 详见 §8.4.0 联系邮箱规范。App 运行时用户点击「Contact Us」或邮件链接跳转 iOS Mail 时，发件人是隐私/法律专用邮箱，可直接进入专业处理流程。

---

### 8.5 AI 技术应用要求

#### AI 功能分类与解决方案

| AI 功能类型 | 示例场景 | 解决方案 |
|------------|---------|---------|
| **设备端 ML（推荐）** | 本地情绪识别、语音转文字、本地推荐 | 使用 CoreML/MLCompute，**无需额外审核** |
| **第三方 AI API** | OpenAI GPT、Claude、MiniMax 等云端 AI | 隐私政策必须明确说明 |
| **AI 生成内容** | AI 生成图片/文字/语音 | 必须有内容审核机制 |

#### 多 AI 提供商支持（推荐实现）

> ✅ **推荐**：App 支持用户自定义选择 AI 服务提供商，提高灵活性

**常见 AI 提供商参考（2026 年 5 月 28 日最新排名）：**

| 排名 | 供应商 (Provider) | 核心代表模型 (Model ID) | 核心优势与定位 |
| :--- | :--- | :--- | :--- |
| 1 | **Anthropic** | claude-opus-4.8 / claude-sonnet-4.6 | 复杂任务推理最强，代码漏报率极低 |
| 2 | **OpenAI** | gpt-5.5 / gpt-5.4 | 综合全能，桌面自动化操作能力顶尖 |
| 3 | **Google** | gemini-3.5-flash / gemini-3.1-pro | 极致性价比与速度，超长上下文窗口 |
| 4 | **Meta** | llama-4-maverick / ultra | 开源生态霸主，企业私有化部署首选 |
| 5 | **NVIDIA** | nemotron-3-super-120b | 性能黑马，开源且支持本地高性能部署 |
| 6 | **Moonshot AI** | kimi-k2.5 | 长文本处理王者，极高的性价比 |
| 7 | **MiniMax** | minimax-m2.7 / m2.5 | Agent 任务性价比极高，海外调用量领先 |
| 8 | **Alibaba** | qwen3.6-plus / qwen3.5 | 编程与通用能力均衡，开源界标杆 |
| 9 | **Zhipu AI** | glm-5 | 双语能力强，针对 Agent 场景深度优化 |
| 10 | **StepFun** | step-3.5-flash | 极低延迟与成本，近期调用量爆发式增长 |

> ⚠️ **Agent 必须从上述列表中选择 AI 提供商**，确保至少支持 10 家厂商供欧美客户自定义选择。模型 ID 必须使用正确的 canonical 格式（如 `gpt-5.5`、`claude-opus-4.8`、`minimax-m2.7`），禁止自行编造。**每次提案前需重确认列表是否有更新。**

**建议实现架构：**
```swift
// 抽象 AI 服务接口
protocol AIServiceProtocol {
    var providerType: AIProviderType { get }
    var selectedModel: String { get }
    func sendMessage(_ text: String, history: [ChatMessage]) async throws -> String
}

// 通用 AI 服务（路由到不同提供商）
final class AIService: ObservableObject {
    static let shared = AIService()
    
    @Published var currentProvider: AIProviderType = .minimax
    @Published var selectedModel: String
    @Published var apiKey: String = ""
    
    func sendMessage(_ text: String, history: [ChatMessage] = []) async throws -> String {
        // 根据 currentProvider 路由到对应实现
    }
}
```

**配置流程（用户操作）：**
1. App 内置 Settings/偏好设置页面
2. 用户选择 AI Provider（提供商）
3. 用户选择 Model（模型）
4. 用户输入 API Key（安全存储在 UserDefaults）
5. 提供「测试连接」功能验证配置

**隐私政策要求：**

如果 App 使用云端 AI（OpenAI/Claude/MiniMax 等），隐私政策必须包含：

```html
<h2>AI Services</h2>
<p>We use third-party AI services to power [feature name].
These services may include: [list of providers used].
Your messages are processed by the selected AI provider according to their privacy policies.
We do not store your data on external AI servers longer than necessary to provide the service.</p>
```

> ⚠️ **必须将 [feature name] 和 [list of providers used] 替换为实际使用的内容**

---

### 8.6 特殊功能要求（如适用）

> 🚨 **HR-09: 特殊功能必须完整实现**

| 特殊功能 | 必须实现要求 | 审核重点 |
|---------|------------|---------|
| **本地消息通知** | 必须实现完整的本地通知功能 | 通知权限描述必须准确说明用途 |
| **相机/相册访问** | 必须实现 Photo Library 访问权限正确请求 | 权限描述必须准确说明用途 |
| **位置服务** | 必须实现位置权限正确请求 | 权限描述必须准确说明用途 |
| **健康数据** | 使用 HealthKit 必须实现完整的读写功能 | 必须有明确的隐私政策说明 |
| **Apple Watch 同步** | 必须实现 WatchConnectivity 完整同步功能 | 必须验证数据同步正常 |

#### 功能完整性检查

> ⚠️ **Agent 必须在每次代码变更后验证以下内容**：
> 1. 所有声明的功能都实现了完整代码（不能是空壳）
> 2. 所有权限请求都有正确的用途描述
> 3. 所有回调/代理都正确实现
> 4. 所有特殊功能都经过至少 3 次测试验证

---

### 8.7 内购（In-App Purchase）实现要求（如适用）

> ✅ **SC-10: 内购产品 ID 配置检查**
> ⚠️ **如果 App 包含内购功能，必须实现完整的 StoreKit 功能**

#### 必须实现的组件

| 组件 | 说明 | 必须实现 |
|------|------|---------|
| **IAP 产品配置** | 在 App Store Connect 创建内购产品 | ✅ |
| **StoreKit 初始化** | `SKPaymentQueue.default().restoreCompletedTransactions()` | ✅ |
| **购买请求** | `SKPaymentQueue.default().add(payment)` | ✅ |
| **交易监听** | `SKPaymentTransactionObserver` 协议实现 | ✅ |
| **恢复购买** | 实现 `restorePurchases()` 方法 | ✅ |

#### 代码实现模板

```swift
import StoreKit

class IAPManager: NSObject, SKPaymentTransactionObserver {
    static let shared = IAPManager()

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    func purchase(productId: String) {
        let productRequest = SKProductsRequest(productIdentifiers: [productId])
        productRequest.delegate = self
        productRequest.start()
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                self.finishTransaction(transaction)
            case .restored:
                self.finishTransaction(transaction)
            case .failed:
                self.finishTransaction(transaction)
            default:
                break
            }
        }
    }

    private func finishTransaction(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
```

#### 订阅产品配置模板

```markdown
# {AppName} IAP 产品配置清单

## 自动续期订阅（Auto-Renewable Subscription）
> **推荐**：订阅制 App 应始终配置免费试用

### 订阅产品列表
| 参考名称 | 产品 ID | 价格等级 | 显示名称 | 描述 | 时长 |
|---------|--------|---------|---------|------|------|
| Premium Monthly | com.ggsheng.{AppName}.premium_monthly | Tier 6 | Premium Monthly | Unlock all premium features | 1 Month |
| Premium Yearly | com.ggsheng.{AppName}.premium_yearly | Tier 60 | Premium Yearly | Best value: unlock all features | 1 Year |

### Introductory Offers（试用）
| 产品 ID | 优惠类型 | 时长 |
|--------|---------|------|
| {AppName}.premium_yearly | Free Trial | 7 Days |
| {AppName}.premium_monthly | Free Trial | 3 Days |
```

---

### 8.8 推送通知（Push Notifications）实现要求

#### 必须实现的组件

| 组件 | 说明 | 必须实现 |
|------|------|---------|
| **请求权限** | `UNUserNotificationCenter.current().requestAuthorization` | ✅ |
| **获取 Device Token** | `application(_:didRegisterForRemoteNotificationsWithDeviceToken:)` | ✅ |
| **处理通知** | `UNUserNotificationCenterDelegate` | ✅ |

---

### 8.9 后台模式（Background Modes）实现要求

#### Info.plist 配置

```xml
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER).refresh</string>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER).processing</string>
</array>
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>location</string>
    <string>fetch</string>
    <string>processing</string>
</array>
```

> ⚠️ **【强制】当 `UIBackgroundModes` 包含 `processing` 时，必须同时添加 `BGTaskSchedulerPermittedIdentifiers`**，否则上传 App Store 时会报错：
> `Missing Info.plist value. The Info.plist key 'BGTaskSchedulerPermittedIdentifiers' must contain a list of identifiers`

---

### 8.10 Keychain 安全存储要求

| 场景 | 正确做法 |
|------|---------|
| 存储 API Token | 使用 `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` |
| 存储密码 | 使用 KeychainAccess 库或原生 Security framework |
| 登录 Session | 使用 `kSecAttrAccessibleAfterFirstUnlock` |

---

### 8.11 英文本地化指南（English-Only）

> 🚨 **HR-03: 禁止中文、日文、韩文、泰文、越南文 等非英文 UI**
> ⚠️ **本项目只做英文版本，不提供其他语言。所有 App 文本、权限描述、隐私政策、App Store 元数据必须使用英文。**
---

### 8.12 数据持久化策略（Data Persistence）

> ⚠️ **所有持久化配置必须符合本节规定**

---

### 8.12.1 AI 服务配置（AI Services Configuration）

> 📌 **HR-38 ~ HR-42：所有 AI 配置必须遵循本节规定**

---

#### 8.12.1 默认预配置 AI 服务（MiniMax 中国区）

开发者预配置的默认 AI 服务，供 iOS App 开箱即用：

```json
{
  "minimax-cn": {
    "baseUrl": "https://api.minimaxi.com/v1",
    "apiKey": "<developer-pre-configured-key>",
    "api": "openai-completions",
    "models": [
      { "id": "MiniMax-M3", "name": "MiniMax M3" },
      { "id": "MiniMax-M2.7", "name": "MiniMax M2.7" },
      { "id": "MiniMax-M2.7-highspeed", "name": "MiniMax M2.7 Highspeed" },
      { "id": "MiniMax-M2.5", "name": "MiniMax M2.5" },
      { "id": "MiniMax-M2.5-highspeed", "name": "MiniMax M2.5 Highspeed" }
    ]
  }
}
```

- 特别说明：developer-pre-configured-key
- 默认值：sk-cp-JrsXMfjYj9mexu5NAr9Eevedk7IBFoCZFi4azaPEColz-bU0LH0NPA-Z-gxMlM505CKP1Cq-zaAP0OF2bQ0k6y44J1TP0XNodYCxY9oiQAmeGb0RPIivl6A


**⚠️ 重要：API 请求时模型名格式与存储格式不同**
- 代码中存储格式：`minimax/MiniMax-M3`（provider/model，符合 HR-41）
- **API 请求时格式**：裸模型名（**不含 provider 前缀**）
  - **所有厂商**的 API 都需要 strip 掉 provider/ 前缀
  - MiniMax: `minimax/MiniMax-M3` → `MiniMax-M3`
  - OpenAI: `openai/gpt-5.5` → `gpt-5.5`
  - Anthropic: `anthropic/claude-opus-4-6` → `claude-opus-4-6`
  - Google: `google/gemini-3.1-pro-preview` → `gemini-3.1-pro-preview`
  - DeepSeek/xAI/Moonshot/Qwen/Z.AI/StepFun: 同理 strip 前缀
  - MiniMax 全球: `https://api.minimax.io/v1`
  - MiniMax 中国区: `https://api.minimaxi.com/v1`
- **错误后果**：发送 `minimax/MiniMax-M3` 会导致 ATS 错误或 400/404

**请求时 strip 前缀（Swift 示例）：**
```swift
// Generic strip for all providers (works for all厂商)
let modelName = selectedModel.contains("/") 
    ? String(selectedModel.split(separator: "/", omittingEmptySubsequences: false).last ?? "")
    : selectedModel
```

**iOS 代码实现要点：**

| 配置项 | 值 |
|--------|-----|
| Provider ID | `minimax` |
| baseUrl | `https://api.minimaxi.com/v1` |
| Default Model | `MiniMax-M3` |
| API Type | OpenAI-Compatible（POST `/chat/completions`） |
| Auth Header | `Authorization: Bearer <apiKey>` |

**AIService 默认值（Swift）：**
```swift
@Published var currentProvider: AIProviderType = .minimax
@Published var selectedModel: String = "MiniMax-M2.7"
@Published var apiKey: String = "<pre-configured>"
@Published var isConfigured: Bool = true
```

---

#### 8.12.2 欧美市场默认 AI 模型（无预配置 Key 时）

当 App **未预配置** API Key 时，默认使用欧美市场最流行模型：

| 排名 | Provider ID | 默认模型 | 适用场景 |
|:---:|:---|:---|:---|
| 1 | `anthropic` | `anthropic/claude-opus-4-6` | iOS 健康类 App首选 |
| 2 | `openai` | `openai/gpt-5.5` | 综合全能 |
| 3 | `google` | `google/gemini-3.1-pro-preview` | 性价比 |
| 4 | `deepseek` | `deepseek/deepseek-v4-flash` | 开源 |
| 5 | `xai` | `xai/grok-4.3` | 快速响应 |

---

#### 8.12.3 支持的全部 AI 厂商（≥10 家）

系统默认 1 家中国国内厂商（开发者预配置的默认 AI 服务，供 iOS App 开箱即用）：
| # | Provider ID | 厂商名称 | baseUrl | OpenAI 兼容 |
|:---:|:---|:---|:---|:---:|
| 1 | `minimax-cn` | MiniMax-CN | `https://api.minimaxi.com/v1`（中国区，预配置） | ✅ |

除了默认的中国厂商，必须支持以下 10 家厂商供用户自定义选择：

| # | Provider ID | 厂商名称 | baseUrl | OpenAI 兼容 |
|:---:|:---|:---|:---|:---:|
| 1 | `minimax-global` | MiniMax-Global | `https://api.minimax.io/v1`（全球） | ✅ |
| 2 | `openai` | OpenAI | `https://api.openai.com/v1/chat/completions` | — |
| 3 | `anthropic` | Anthropic | `https://api.anthropic.com/v1/messages` | ❌ |
| 4 | `google` | Google | `https://generativelanguage.googleapis.com/v1beta/models` | ❌ |
| 5 | `deepseek` | DeepSeek | `https://api.deepseek.com/v1/chat/completions` | ✅ |
| 6 | `xai` | xAI | `https://api.x.ai/v1/chat/completions` | ✅ |
| 7 | `moonshot` | Moonshot AI | `https://api.moonshot.cn/v1/chat/completions` | ✅ |
| 8 | `qwen` | Qwen | `https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions` | ✅ |
| 9 | `zai` | Z.AI | `https://open.bigmodel.cn/api/paas/v4/chat/completions` | ✅ |
| 10 | `stepfun` | StepFun | `https://api.stepfun.com/v1/chat/completions` | ✅ |

---

#### 8.12.4 模型 ID 格式规范

**✅ 正确格式（OpenClaw canonical）：**
```
provider/model
例如：minimax/MiniMax-M3、anthropic/claude-opus-4-6、openai/gpt-5.5
```

**❌ 错误格式（禁止使用）：**
```
MiniMax-M2.7、claude-opus-4.8、gpt-5.5（缺少 provider/ 前缀）
```

**必须参照：** `docs.openclaw.ai/providers` 实时验证模型 ID

---

#### 8.12.5 Settings 界面要求（HR-40/HR-44）

**默认预配置 AI 对用户透明：**
- Settings 界面**只显示** "AI Service: Ready" 状态
- **禁止**展示 Provider 名称、模型名称、API Key
- 用户**无法查看或编辑**预配置的 MiniMax 模型/API Key

**10 家自定义厂商（含 MiniMax-Global）供用户自定义（HR-44）：**
- Settings > Custom AI Providers 列出其他 10 家厂商
- 用户点击后进入配置页面，输入：
  - **Base URL**（必须）
  - **API Key**（必须）
  - **Model 选择**（Picker，从 provider.supportedModels 选取）
- 配置后提供 "Test Connection" 按钮验证

**10 家厂商 Base URL 配置：**

| # | Provider ID | Base URL |
|:---:|:---|:---|
| 1 | `minimax` | `https://api.minimax.io/v1`（全球） |
| 2 | `openai` | `https://api.openai.com/v1/chat/completions` |
| 3 | `anthropic` | `https://api.anthropic.com/v1/messages` |
| 4 | `google` | `https://generativelanguage.googleapis.com/v1beta/models` |
| 5 | `deepseek` | `https://api.deepseek.com/v1/chat/completions` |
| 6 | `xai` | `https://api.x.ai/v1/chat/completions` |
| 7 | `moonshot` | `https://api.moonshot.cn/v1/chat/completions` |
| 8 | `qwen` | `https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions` |
| 9 | `zai` | `https://open.bigmodel.cn/api/paas/v4/chat/completions` |
| 10 | `stepfun` | `https://api.stepfun.com/v1/chat/completions` |

---

#### 8.12.6 API Key 状态显示与持久化

当默认模型的 API Key 未配置时，Settings 界面**必须**满足：

1. API Key 为空时，显示 **橙色醒目文字**（如 "Not Set — tap to configure"）
2. 提供清晰的引导，告知用户输入哪个 Provider 的 Key
3. 未配置 Key 时，AI 对话功能应显示明确提示不可用
4. 保存配置后持久化到 `UserDefaults` 或 Keychain

---

#### 8.12.8 配置持久化

所有 AI 配置必须通过 `AIService.configure(provider:model:apiKey:)` 保存到 `UserDefaults`：

```swift
// AIService.swift
func configure(provider: AIProviderType, model: String, apiKey: String) {
    self.currentProvider = provider
    self.selectedModel = model
    self.apiKey = apiKey
    self.isConfigured = !apiKey.isEmpty
    saveConfiguration()
}
```

---


---

### 8.13 Light + Dark 主题实现（必读 — 2026-06-02 经验沉淀）

> **【强制】iOS App 必须同时提供 Light 和 Dark 两种主题（HR-19 / SC-12）**
>
> 两种主题不是"颜色相反的黑白"——是**两种独立的视觉系统**。Light 主题用「卡片 + 描边 + 微阴影」分层，Dark 主题用「深色面 + 深阴影」分层。同一套 token 必须两种模式都好看。

#### 8.13.1 颜色 Token 系统

**必须按用途而非按颜色命名 token**。同一 token 在 Light 和 Dark 模式下指向不同 hex 值。

**两段式 init：**

```swift
// Sources/Core/Theme/DynamicColor.swift
extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        }
    }
    convenience init(lightHex: String, darkHex: String) {
        self.init(light: UIColor(hex: lightHex), dark: UIColor(hex: darkHex))
    }
}

extension Color {
    init(lightHex: String, darkHex: String) {
        self.init(UIColor(lightHex: lightHex, darkHex: darkHex))
    }
}
```

**配色分三类**（VitaPocket 2026-06-02 实战沉淀，可按品牌替换具体 hex）：

| 类别 | Token | Light | Dark | 何时相同 |
|------|------|------|------|---------|
| **品牌色** | primary / secondary / accent | 6B4EFF / 00D9A0 / FFD700 | 同左 | 品牌身份，**永远不变** |
| **Chrome 动态色** | background / surface / surfaceLight / textPrimary / textSecondary / textTertiary / separator / border | 浅色背景 / 纯白卡 / 浅紫 / 深紫文字 / 紫灰 | 深紫底 / 深紫卡 / 中紫 / 白色文字 / 浅紫 | 跟随主题 |
| **状态色** | success / warning / error | 固定 | 固定 | 语义不能变 |
| **卡牌稀有度** | cardRare / cardEpic / cardLegendary / cardCommon / cardUncommon | 固定 | 固定 | 卡牌艺术永远深色 |

**通用 Light 模式具体值**（VitaPocket 2026-06-02 验证可读）：

| Token | Light | Dark | 备注 |
|------|------|------|------|
| background | F5F2FB (暖浅紫) | 0D0B1E (深紫) | 不是纯白——是暖色调 |
| surface | FFFFFF | 1A1730 | 纯白卡 + 深紫卡 |
| surfaceLight | EFEAF8 | 252040 | 内部组件底 |
| separator / border | E5E0F0 | 2A2540 | 1px 细线 |
| textPrimary | 1A0F2E | FFFFFF | 主文字 |
| textSecondary | 4A4458 | FFFFFF/0.7 | 副文字 |
| textTertiary | 7A7290 | FFFFFF/0.5 | 占位 |

#### 8.13.2 字体 Token 修正

`statNumber` 等数据型数字**不要用 `.monospaced` 字体**——在 Light 模式下显得突兀、像控制台输出。改用 `.rounded` 设计，与整体设计语言统一：

```swift
// ❌ 错误
static let statNumber = SwiftUI.Font.system(size: 32, weight: .bold, design: .monospaced)

// ✅ 正确
static let statNumber = SwiftUI.Font.system(size: 32, weight: .bold, design: .rounded)
```

#### 8.13.3 阴影系统（Light 模式关键）

**Light 模式阴影不能用纯黑**——会显得生硬像"贴上去的便签"。改用主题色（深紫）的低透明度版本：

```swift
// ❌ 错误：纯黑阴影在 Light 模式生硬
Shadow(color: Color.black, radius: 14, x: 0, y: 6)

// ✅ 正确：主题色低透明度阴影
Shadow(color: Color(hex: "1A0F2E").opacity(0.08), radius: 10, x: 0, y: 4)
```

**保留两个级别**：
- `card` (10pt) — 大型卡片
- `cardTight` (4pt) — 小元素 / chip

**禁止把阴影当成"glow"使用**——使用主题色实色 + 8% 透明度。

#### 8.13.4 Navigation Bar 颜色陷阱 ⚠️

**绝对禁止**在 Tab 视图上添加：
```swift
.toolbarColorScheme(.dark, for: .navigationBar)
```

这个 API **强制 nav bar 不管系统主题都用 dark scheme 调色**——结果就是 Light 模式下标题文字变成白字（不可读）。必须移除，让 nav bar 自动跟随系统 Light/Dark 主题。

> **【强制】所有 Tab 视图的 navigation bar 必须跟随系统主题自适应**，禁止使用 `.toolbarColorScheme(.dark)`。违者按 HR-19 违规处理。

#### 8.13.5 横向滚动 + 视觉提示

当内容横向滚动（如 Pocket 的 Mission cards）时，**必须添加右侧 fade gradient 提示用户可滚动**：

```swift
ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 12) { /* cards */ }
        .padding(.horizontal)
}
.overlay(alignment: .trailing) {
    LinearGradient(
        colors: [VitaTheme.Colors.background.opacity(0), VitaTheme.Colors.background],
        startPoint: .leading,
        endPoint: .trailing
    )
    .frame(width: 40)
    .allowsHitTesting(false)
}
```

#### 8.13.6 空状态 UI 设计

**所有空集合 / 零数据 section 必须有友好空状态**——只有"0 collected"这类纯文字提示是不够的。需要：

```swift
if collection.isEmpty {
    VStack(spacing: 12) {
        Image(systemName: "heart.text.square")
            .font(.system(size: 40))
            .foregroundColor(VitaTheme.Colors.textTertiary)
        Text("No health data yet")
            .font(VitaTheme.Fonts.body)
            .foregroundColor(VitaTheme.Colors.textPrimary)
        Text("Connect Health in Settings → Privacy to start collecting cards")
            .font(VitaTheme.Fonts.caption)
            .foregroundColor(VitaTheme.Colors.textSecondary)
            .multilineTextAlignment(.center)
    }
    .padding(.vertical, 32)
    .background(
        RoundedRectangle(cornerRadius: VitaTheme.Radius.lg)
            .fill(VitaTheme.Colors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: VitaTheme.Radius.lg)
                    .stroke(VitaTheme.Colors.border, lineWidth: 1)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            )
    )
}
```

**关键点**：
- 大图标 (40pt+)
- 明确主标题
- **可操作的引导**（告诉用户去哪里设置）
- 虚线 border 表示"待填充"
- 圆角 + padding 跟正常卡片一致

#### 8.13.7 浮动 Tab Bar 遮挡问题

iOS 18+ TabView 默认使用浮动 Tab Bar（不占用布局空间）。如果用 `.ignoresSafeArea(edges: .bottom)` 在 TabView 上，**所有 Tab 内的 ScrollView 都必须手动留出 Tab Bar 高度**：

```swift
ScrollView {
    LazyVStack { /* content */ }
    // 关键：底部留白，避开浮动 Tab Bar
    Color.clear.frame(height: 80)
}
.padding(.bottom, 24)
```

**禁止**用 `.safeAreaInset(edge: .bottom)`——它会跟 `ignoresSafeArea(.bottom)` 冲突而失效。必须用 Color.clear 占位。

#### 8.13.8 Achievements 多行 Grid 优化

当 achievements 超过 4 个时，单行 List 会被 Tab Bar 遮挡。改用 2 列 grid + 紧凑卡片：

```swift
LazyVGrid(columns: [GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)], spacing: 12) {
    ForEach(achievements) { achievement in
        CompactAchievementCard(achievement: achievement)
    }
}
```

紧凑卡片 = 36×36 icon + 标题 + +XP 奖励（一行布局）。

#### 8.13.9 Settings Section 间距

iOS 18 List 默认 section 间距过大。Light 模式下尤其明显。强制使用 compact 间距：

```swift
List { /* sections */ }
.listSectionSpacing(.compact)
```

Section 内部 row 不应该用 `.listRowBackground(Color(.systemBackground))`——会破坏 List 的统一背景。直接让 List 自适应主题。

#### 8.13.10 HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-48** | **禁止在 Tab 视图上使用 `.toolbarColorScheme(.dark)`** — 让 navigation bar 跟随系统 Light/Dark 模式自适应 | §8.13.4 |
| **HR-49** | **禁止使用纯黑色阴影** — Light 模式阴影必须用主题色（深紫/深蓝等）的低透明度（≤15%）版本，保留细腻精致感 | §8.13.3 |
| **HR-50** | **禁止空集合无视觉引导** — 所有空数据 section 必须包含大图标 + 主标题 + 可操作引导文字 + 虚线 border placeholder | §8.13.6 |
| **SC-34** | **Light 模式标题栏文字可读性** — 启动 Light 模式进入每个 Tab，截图肉眼验证 navigation bar 标题字色为深色且清晰 | §8.13.4 |
| **SC-35** | **Light 模式阴影精致度** — Light 模式截图肉眼检查所有卡片无生硬黑色阴影 | §8.13.3 |
| **SC-36** | **Light 模式横向滚动提示** — 横向滚动 section 必须有右侧 fade gradient 提示 | §8.13.5 |
| **SC-37** | **Tab Bar 不遮挡内容** — Light + Dark 模式各 Tab 滚动到底部均不被浮动 Tab Bar 遮挡 | §8.13.7 |

---


---

### 8.14 Multi-Provider AI Service 经验（必读 — 2026-06-02 经验沉淀）

> **【强制】所有 AI provider 集成必须遵循以下架构 + 错误处理规范**
>
> 实际项目（如 VitaPocket）集成了 10 家 AI provider，本节沉淀的真实 bug 都是发布前最后一刻才被发现的。

#### 8.14.1 Provider baseURL 必须用 `currentProvider.baseURL`

**❌ 错误写法** — 硬编码 provider 类型的 baseURL：

```swift
case .minimaxCn, .minimaxGlobal:
    return try await makeJSONRequest(
        endpoint: AIProviderType.minimaxCn.baseURL + "/chat/completions",  // 总是中国区!
        ...
    )
```

**问题**：当用户选择 `minimax-Global` provider 时，请求仍然被路由到中国区 (`api.minimaxi.com/v1`)，所有 API 调用都因 auth 失败。

**✅ 正确写法** — 用当前 provider 的 baseURL：

```swift
case .minimaxCn, .minimaxGlobal:
    return try await makeJSONRequest(
        endpoint: currentProvider.baseURL + "/chat/completions",  // 跟随选择
        ...
    )
```

**所有 send*Message 函数都必须用 `currentProvider.baseURL`**，**不要**硬编码任何 `AIProviderType.xxx.baseURL`。

#### 8.14.2 HTTP 错误码必须分类

**❌ 错误写法** — 所有非 200 都抛同一个错误：

```swift
guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    throw AIError.invalidResponse  // 用户看到 "invalid response" 而非 "API Key invalid"
}
```

**✅ 正确写法** — 镜像 `makeJSONRequest` helper 的分类：

```swift
guard let httpResponse = response as? HTTPURLResponse else {
    throw AIError.invalidResponse
}
if httpResponse.statusCode == 401 {
    throw AIError.unauthorized       // "API Key is invalid or expired"
}
if httpResponse.statusCode == 429 {
    throw AIError.rateLimited        // "Too many requests. Please try again later."
}
if httpResponse.statusCode != 200 {
    let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
    throw AIError.serverError(statusCode: httpResponse.statusCode, message: errorBody)
}
```

**所有 send*Message 函数**都应该用相同的错误分类，让用户看到精准错误信息而不是"无效响应"。

#### 8.14.3 守护 in-depth 原则

按钮 `disabled` + guard 双重检查：

```swift
Button("Test & Save") {
    testAndSave()
}
.disabled(baseURL.isEmpty || apiKey.isEmpty)

private func testAndSave() {
    // 同一条件的二次检查 (defend in depth)
    guard !baseURL.isEmpty && !apiKey.isEmpty else { return }
    // ...
}
```

**错误**：`guard !baseURL.isEmpty || !apiKey.isEmpty` 用错 `||`，意思是"任一为空就 return" — 即任何一项为空都会跳过。但按钮已经 disable 防止这种情况，所以功能上不会出错，但**逻辑意图错误**会让未来重构埋雷。

#### 8.14.4 @Published 状态必须有消费者

**错误** — 状态设置了但没有任何 view 读取：

```swift
@Published var currentXPAnimation: Int = 0
@Published var isLoading: Bool = false
@Published var isHealthKitAuthorized: Bool = false

func completeHabit(...) {
    // ...设置 currentXPAnimation = 50
}

func requestHealthKitAuthorization() async {
    // ...设置 isHealthKitAuthorized = true
}
```

**问题**：这些 `@Published` 状态有 setter 但**没有任何 view 消费**：
- `currentXPAnimation` 设置后清零，用户**永远看不到 XP 增长反馈**
- `isHealthKitAuthorized` 控制 HealthKit 授权，但 UI 没有任何按钮触发 `requestHealthKitAuthorization`

**检测方法**：用 grep 搜索每个 `@Published` 变量名，验证至少一个 view 引用。

#### 8.14.5 HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-51** | **禁止在多 provider send 函数中硬编码 `AIProviderType.xxx.baseURL`** — 必须用 `currentProvider.baseURL` 跟随用户当前选择 | §8.14.1 |
| **HR-52** | **禁止把所有非 200 HTTP 状态码都映射为同一个 `invalidResponse` 错误** — 401 → `unauthorized`，429 → `rateLimited`，其他 → `serverError` | §8.14.2 |
| **HR-53** | **禁止设置 `@Published` 状态后不消费** — 每个状态必须有对应的 UI 消费者或删除 | §8.14.4 |
| **SC-38** | **多 provider 测试** — 至少测试两个不同 provider（如 minimax-CN + OpenAI）的 baseURL 切换 + 错误处理路径 | §8.14.1-8.14.2 |
| **SC-39** | **死状态扫描** — `git diff` 前后跑 `grep -rn 'isLoading\|isHealthKitAuthorized\|currentXPAnimation' Sources/`，确认每个 @Published 至少在 1 个 view 出现 | §8.14.4 |

---

### 8.15 HealthKit + Mock Data 集成经验（必读 — 2026-06-02 经验沉淀）

> **【强制】HealthKit / CoreHealth / 类似系统服务必须保证首屏有可见数据**
>
> 真实 bug：App 在 Settings → About 写"Track your health"但 HealthKit 完全没接入，对应数据列表永远是空，App Store 审核会被打回。

#### 8.15.1 Mock + 真实数据双轨

```swift
// MARK: - Initialization
init() {
    loadPersistedData()
    setupDefaultDataIfNeeded()
    // 关键：首屏立即看到数据，避免"Track your health"承诺的落差
    if healthCards.isEmpty {
        setupMockHealthCards()
    }
}

func requestHealthKitAuthorization() async {
    do {
        try await healthKit.requestAuthorization()
        isHealthKitAuthorized = true
        await refreshHealthCardsFromHealthKit()  // 真实数据替换 mock
    } catch {
        isHealthKitAuthorized = false
        setupMockHealthCards()  // 用户拒绝授权 → 仍有 mock 数据
    }
}
```

**两条路径**：
1. 用户同意 HealthKit → `refreshHealthCardsFromHealthKit()` 替换 mock 为真实数据
2. 用户拒绝 HealthKit → 保留 mock 数据，App 仍然可展示"健康"概念

#### 8.15.2 接入点必须可达

**错误** — 代码中 `func requestHealthKitAuthorization()` 存在但**没人调**：

```swift
func requestHealthKitAuthorization() async {
    do {
        try await healthKit.requestAuthorization()
        ...
    } catch { ... }
}
// ← 但全项目 grep 不到任何调用方
```

**症状**：App 永远停在"等待 HealthKit 授权"状态，从未触发。

**修复** — 在 Settings 页面添加显式触发入口：

```swift
Section {
    HStack {
        Image(systemName: isHealthKitAuthorized ? "heart.text.square.fill" : "heart.text.square")
        Text("HealthKit")
        Spacer()
        if isHealthKitAuthorized {
            Text("Connected").foregroundColor(.success)
        } else {
            Button("Connect") { Task { await requestHealthKitAuthorization() } }
        }
    }
    Button { Task { await refreshHealthCardsFromHealthKit() } } label: {
        Label("Refresh Health Cards", systemImage: "arrow.clockwise")
    }
} header: { Text("HealthKit") }
```

#### 8.15.3 HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-54** | **禁止 HealthKit / CoreLocation / 类似系统服务"有函数没调用"** — 每个公开方法必须在 Settings/Onboarding 至少有 1 个调用点 | §8.15.2 |
| **HR-55** | **禁止首屏空状态无 fallback** — 系统数据服务（HealthKit/位置/相机）未授权时必须有 mock 数据兜底 | §8.15.1 |
| **SC-40** | **核心服务接入测试** — 启动 App 检查每个核心服务（Health/Location/Camera）首屏有数据展示，无空状态 | §8.15.1 |
| **SC-41** | **手动触发测试** — 验证每个系统服务都有 Settings 入口让用户主动触发（Connect/Refresh 按钮） | §8.15.2 |

---

### 8.16 本地通知（Local Notifications）实现经验（必读 — 2026-06-03 经验沉淀）

>
>
> **【强制】任何带"每日提醒 / 提醒打卡 / 倒计时"等文案的功能，实质都是本地通知，必须遵循本节**
>
> 本地通知（`UNUserNotificationCenter`）不需要 `aps-environment` entitlement、不需要服务器，是 App Store 审核最友好的通知实现方式。本节沉淀 4 个关键 bug。

#### 8.16.1 `UNUserNotificationCenterDelegate.willPresent` 是前台显示 banner 必需

**错误** — 实现了 `UNUserNotificationCenter` 调度但 banner 在前台**不显示**：

```swift
// 看起来对，但前台静默
let request = UNNotificationRequest(identifier: "x", content: content, trigger: trigger)
UNUserNotificationCenter.current().add(request)
```

**正确** — 必须设 delegate + 在 `willPresent` 返回 banner：

```swift
// 启动时
UNUserNotificationCenter.current().delegate = NotificationDelegate.shared

// 必须有独立 delegate 类
private final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound, .badge])
    }
}
```

> ⚠️ **【强制】不加这段 → 用户在前台时收到通知"无任何反应"，会以为功能坏了**

#### 8.16.2 `@AppStorage` 必须 import SwiftUI

**错误** — 文件里只 import Foundation：

```swift
import Foundation
import UserNotifications  // 用到 UNUserNotificationCenter
// 缺 import SwiftUI
@AppStorage("vita_notifications_enabled") var isEnabled: Bool = true
// Build 报错: unknown attribute 'AppStorage'
```

**正确** — 任何用了 `@AppStorage` 的文件**必须** import SwiftUI。

#### 8.16.3 通知权限请求必须在 App 启动后异步触发（不要 init 同步调）

**错误** — 在 `App.init()` 里同步调用 `requestAuthorization()`，会与 `@StateObject` 初始化竞态，导致 `gameState` 引用为 nil。

**正确** — 在 `.task` 修饰符里调用：

```swift
var body: some Scene {
    WindowGroup {
        ContentView()
            .environmentObject(gameState)
            .task {
                await gameState.bootstrapNotifications()
            }
    }
}
```

#### 8.16.4 通知数据流结构

```
App 启动 (.task)
    └─→ GameState.bootstrapNotifications()
            ├─→ NotificationManager.requestAuthorization()
            └─→ NotificationManager.rescheduleAll(habitCount:)

习惯数变化 / 抽卡完成
    └─→ GameState.pullDailyCard() / completeHabit()
            └─→ rescheduleAll(habitCount:)  (cancel + re-add，幂等)
```

#### 8.16.5 触发器选择

| 场景 | Trigger | 备注 |
|---|---|---|
| 每天固定时间（如 9 AM 提醒） | `UNCalendarNotificationTrigger(dateMatching: components, repeats: true)` | 重复 daily |
| 几秒后立即测试 | `UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)` | 一次性 |
| 倒计时 N 秒 | `UNTimeIntervalNotificationTrigger(timeInterval: N, repeats: false)` | 一次性 |
| 某个日期 | `UNCalendarNotificationTrigger(dateMatching: components, repeats: false)` | 一次性 |

#### 8.16.6 HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-56** | **禁止前台不实现 `willPresent` delegate** — 前台通知 banner 必须显式返回 `[.banner, .sound]`，否则用户感知不到 | §8.16.1 |
| **HR-57** | **禁止 App.init() 同步请求通知权限** — 必须放在 `.task` 修饰符里异步调用，避免 @StateObject 竞态 | §8.16.3 |
| **HR-58** | **禁止远程推送假装本地通知** — 如果用本地通知就别用 `aps-environment`，反之亦然；混用会导致 App Store 审核打回"未实现声明的推送能力" | §8.16 |
| **SC-42** | **本地通知端到端测试** — 启动 App → 允许通知 → 验证 Settings 状态从 "Permission not yet asked" 变为 "On — 3 daily reminders" | §8.16.1 |
| **SC-43** | **前台 banner 可见性** — 启动 App 到任何 tab，点"Send Test Notification"按钮，1 秒后**当前屏幕顶部必须出现 banner** | §8.16.1 |
| **SC-44** | **Trigger 调度验证** — 跑 `UNUserNotificationCenter.pendingNotificationRequests()` 确认 3 个 daily reminder 都已注册 | §8.16.5 |

---

### 8.17 App Store 截图自动化（XCUITest + Release config）经验（必读 — 2026-06-03 经验沉淀）

> 🚀 **快速参考**: 跳读可看 [`iPad-Screenshot-Recipe.md`](../iPad-Screenshot-Recipe.md) — 5 步可复制模板 + 5 症状诊断表 + 完整 UI Test 代码。详细原理在下方。
>
> **【强制】App Store 提交前所有截图必须用与 archive 同 configuration 的 build 截取，保证 UI 渲染与审核员实际打开的 App 100% 一致**

#### 8.17.1 三条硬性铁律

| 铁律 | 原因 |
|---|---|
| **截图必须用 `xcodebuild test -configuration Release`** | Debug 与 Release 编译优化、断言剥离不同，可能产生 UI 差异 |
| **UI test 必须能切换每个 tab 截屏** | App Store 至少要 3 张/设备 (推荐 5) |
| **截图前必须 dismiss 系统通知权限弹窗** | 否则弹窗遮挡 UI |

#### 8.17.2 iPad page-style TabView 的截屏技巧

**错误** — 用 `swipeLeft()` 切换 tab：

```swift
// iPad 上 .tabViewStyle(.automatic) 是 page-style
// swipeLeft 不可靠 + 经常被 Pocket tab 内的 Daily Pull 卡片拦截触发抽卡
for _ in 0..<i {
    app.swipeLeft()
}
```

**正确** — 用 launch env var 注入初始 selectedTab：

```swift
// ContentView.swift
@State private var selectedTab: Int = {
    let raw = ProcessInfo.processInfo.environment["VITA_INITIAL_TAB"] ?? "0"
    return Int(raw) ?? 0
}()

// UI Test
app.launchEnvironment = ["VITA_INITIAL_TAB": String(tab.index)]
app.launch()
```

**好处**：每个 tab 跑一次独立 App 启动，无需 swipe、无副作用。

#### 8.17.3 系统通知权限弹窗处理

**关键发现** — `app.alerts` 抓不到 iOS 系统通知权限弹窗（只能抓 app 内的 alert），必须用 `addUIInterruptionMonitor`：

```swift
// ⚠️ 必须在 setUp() 注册，不是 test method 里
override func setUp() {
    super.setUp()
    continueAfterFailure = false
    addUIInterruptionMonitor(withDescription: "Notification Permission") { (alert) -> Bool in
        if alert.buttons["Allow"].exists {
            alert.buttons["Allow"].tap()
            return true
        }
        return false
    }
}
```

**触发 monitor 需要 user gesture** — 但 `app.tap()` 会 hit app UI（Daily Pull 按钮或 NavigationLink row）。**用角落 tap** 避开：

```swift
let window = app.windows.firstMatch
let topLeft = window.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.01))
topLeft.tap()
```

#### 8.17.4 截图后必须 Byte-stable 验证

```bash
# 重截前先看 hash，对比
md5 -q AppStore/Screenshots/iPhone17ProMax_1320x2868/vp_tab1_pocket.png
```

Debug vs Release build 在没有 `#if DEBUG` 的代码下应该产生 byte-identical PNGs（系统级 metadata 可能差异，UI 内容应一致）。

#### 8.17.5 HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-59** | **禁止用 Debug build 截 App Store 截图** — 截图必须用 `xcodebuild test -configuration Release`，保证 UI 与最终 archive 一致 | §8.17.1 |
| **HR-60** | **禁止 iPad screenshot test 用 swipe 切 tab** — iPad .tabViewStyle(.automatic) 是 page-style，swipe 不可靠且会被 in-tab gesture 拦截。必须用 launch env 注入初始 tab | §8.17.2 |
| **SC-45** | **截图 Configuration 一致性** — 截 App Store 截图时验证 build Info.plist 与 archive 的 Info.plist 一致 (Bundle ID / Display Name / Version) | §8.17.1 |
| **SC-46** | **iPad 截屏独立性** — iPad screenshot test 跑 N 次 (N=tab 数) 独立 App 启动，每次通过 launch env 选 tab，避免 swipe 副作用 | §8.17.2 |

---

### 8.18 App Store 提交前 Mock 数据清理（必读 — 2026-06-03 经验沉淀）

>
>
> **【强制】任何 mock / 假数据 / 假 AI 回复都必须在 App Store 提交前清理干净**
>
> 真实风险：App Store 审核员会标记"显示虚构数据"为 1.4 Misleading Claims，拒绝理由是 "We noticed that your app displays fabricated data"。本节列出 2 类典型 mock。

#### 8.18.1 两类典型 Mock

| 类型 | 例子 | 风险 |
|---|---|---|
| **健康数据 mock** | `setupMockHealthCards()` — 首启时种入 5420 步 / 72 BPM 等假数据 | 审核员打开看到假数据 → 1.4 Misleading |
| **AI 回复 fallback mock** | `generateMockResponse()` — AI API 失败时返回 emoji 装的假 AI 回复 | 审核员测试 AI 失败场景 → 1.4 Misleading |

#### 8.18.2 健康数据 mock 清理模板

```swift
// ❌ 错误：删了 mock 但没准备空状态 UI
init() {
    if healthCards.isEmpty {
        setupMockHealthCards()  // ← 删掉这一行
    }
}

// ✅ 正确：删 mock + 用现有空状态 UI 兜底
init() {
    // HomeView 已有 "No health data yet" 占位卡片
    // 用户未授权 HealthKit 时看到引导而非假数据
}

// 请求 HealthKit 失败时也不种 mock
func requestHealthKitAuthorization() async {
    do {
        try await healthKit.requestAuthorization()
        await refreshHealthCardsFromHealthKit()
    } catch {
        isHealthKitAuthorized = false
        // 不要调用 setupMockHealthCards()
    }
}
```

#### 8.18.3 AI 回复 mock 清理模板

```swift
// ❌ 错误：用 emoji 装的假 AI 糊弄用户
catch {
    return "Great question! 💪 Walking 10,000 steps..."  // 假 AI
}

// ✅ 正确：诚实告诉用户 AI 不可用
catch {
    return "AI service is temporarily unavailable. Please try again in a moment."
}
```

#### 8.18.4 保留的"非 Mock"首启引导数据

| 数据 | 是 Mock 吗？ | 保留？ |
|---|---|---|
| **5 个默认习惯** (Morning Walk / Drink Water / Meditate / etc) | ❌ 是**首启引导**，不是数据 | ✅ 保留 |
| **6 个默认成就** (全部 locked) | ❌ 是首启引导 | ✅ 保留 |
| **Lv.1 Novice 0/150 XP** | ❌ 是真实初始状态 | ✅ 保留 |
| **健康数据 (steps/HR/sleep/water)** | ⚠️ **是数据**，需要真实来源 | ❌ 不能 mock |
| **AI 回复文本** | ⚠️ 是服务输出 | ❌ 不能 mock fallback |

#### 8.18.5 HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-61** | **禁止首启用 mock 健康数据** — 步数/心率/睡眠等用户真实数据不能用 fake 数字（5420 步之类）凑首屏 | §8.18.1 |
| **HR-62** | **禁止用 emoji 装的假 AI 回复** — AI 服务失败时必须返回明确的"unavailable"消息，不能假装是 AI 输出来糊弄用户 | §8.18.3 |
| **SC-47** | **Mock 数据全仓搜索** — App Store 提交前 grep 全工程 `Mock\|mock\|fake\|stub\|placeholder` 确认无遗漏 | §8.18.1 |
| **SC-48** | **首启真机验证** — 卸载 App → 重装 → 截首屏 → 截图 vision 确认无任何假数字（步数、心率、卡牌数值等） | §8.18.1 |

---

## Stage 9：提交审核

### 9.0 提交流程 Top-5 关键环节（必读）

> **【强制】App Store 提交前必跑 5 个环节，不分项目、不分版本。任何一个不过不能提交。**

本节是 Stage 9 总谱。9.1 起的详细检查清单是“做哪些事”，本节是“为什么这 5 个环节是关键、跳过哪个会翻车、5 环怎么串成流水线”。提交前 1 天最终走一遍。

#### 5 关键环节一览

| # | 环节 | 跳出代价 | 0 校验 | 1 检测命令 / 检查点 | SOP 铀点 |
|---|------|----------|--------|---------------------|----------|
| **1** | **Mock 数据清理** | 1.4 Misleading Claims（审核员打开看到 5420 步等假数据，直接拒）| 提交前 | `grep -rn "Mock\|mock\|fake\|stub" Sources/` 输出必须为空 | §8.18 + HR-61/62 + SC-47/48 |
| **2** | **截图与 build 配置一致** | 2.1 App Completeness（截图是 Debug build、提交是 Release build，UI 渲染差异被拒） | 提交前 1 天 | `xcodebuild test -configuration Release -only-testing:<AppName>UITests/<ScreenshotTestClass>` | §8.17 + HR-59/60 + SC-45/46 |
| **3** | **本地通知前台 banner 必现** | 1.4 Misleading（用户感知不到功能 = 未实现声明的能力）| 通知功能完成后即验 | 启动 App → 点 Settings → Send Test Notification → 顶部 banner 必现 | §8.16 + HR-56 + SC-43 |
| **4** | **权限描述 + 隐私政策 URL 真实可达** | 1.4 + 5.1.1 反复打回 | Stage 4 / Stage 7.5 | `curl -I https://<username>.github.io/<AppName>/docs/privacy.html` 返回 200 | §8.4 + HR-22/35/45/47 + SC-29/32/33 |
| **5** | **XCUITest 性能 + simulator 重置** | 假阴性 / 假阳性漏测到审核 | 整个 dev 周期 + 提交前 1 天 | `xcrun simctl erase <device> && xcodebuild test -only-testing:<AppName>UITests` | §8.20 + HR-65/66 + SC-51 |

#### 5 环流水线（提交前 24 小时走一遍）

```
1. Mock 清理 ──────► 贯穿 dev 周期；提交前 grep 兏底
       │
2. 截图 Release ───► Stage 6 末尾 / 提交前 1 天重截
       │
3. 通知 banner 验证 ─► 通知功能开发完即验
       │
4. 权限描述 + 隐私 URL ─► Stage 4 / Stage 7.5
       │
5. XCUITest 单跑 + 重置 ─► 整个 dev 周期；提交前 1 天最终跑
       │
       ▼
   App Store 提交 (Stage 9.3 - 9.4)
```

#### 为什么是这 5 个（按被拒频次排）

- **环节 1 (Mock)**：1.4 Misleading Claims 是 App Store 上架最常见拒因之一，明确含"展示虚构数据"子条款
- **环节 2 (截图 Release)**：2.1 App Completeness 是高频拒因；许多项目都踩过"截图/代码不匹配"坑
- **环节 3 (通知 banner)**：本地通知是 App Store 审核友好路径，但如果 `willPresent` 不实现则静默吞掉 → 1.4 Misleading
- **环节 4 (权限 + 隐私 URL)**：反复打回原因，HR-45 专门调过 `Link` 外链 vs `NavigationLink` 肉嵌这个坑
- **环节 5 (XCUITest 性能)**：不是被拒原因，但**让其他 4 环验证不可靠**——假阴性会让你误以为其他环节都过

#### HR + SC 新增

| 规则ID | 规则 | 依据 |
|--------|------|------|
| **HR-73** | **禁止跳过 Top-5 关键环节提交 App** — 5 环中任一未过，提交后被拒代价远大于提交前多走 1 天检查 | §9.0 |
| **HR-74** | **禁止 5 环用项目专用命令绑死** — 检测命令必须用 `<AppName>` / `<BundleID>` 占位符，新项目接手能直接复用 | §9.0 |
| **SC-56** | **提交前 5 环验证** — 5 个检测命令必须全部 pass：① `grep -rn "Mock\|mock"` 输出空 ② Release 截图 Info.plist 与 archive 一致 ③ 通知 banner 视觉可见 ④ `curl -I` 隐私 URL 返回 200 ⑤ `xcodebuild test -only-testing` 完成且 0 失败 | §9.0 |
| **SC-57** | **项目引用 git URL 完整性** — `grep "VitaPocket\|ios-VitaMind" docs/SOP-iOS-Local-Development.md` 出现的每一处，100 米字符内必须出现 `github.com/...` 链接 | Appendix G |
| **SC-58** | **项目命名三层一致性自检** — 跑 `scripts/naming-check.sh` 5 项输出匹配项目记录的三层映射表 | §1.2.3 |
| **SC-59** | **Bundle ID 不可变验证** — 上架后项目 `git log --all -- project.yml` 不应出现 `PRODUCT_BUNDLE_IDENTIFIER` 变更 (除非同一个项目下在调为不同 app) | §1.2.3 |

---

### 9.1 提交前最终检查 + Capabilities 复查

🤖 **AI Agent 输出检查清单**：
- Capabilities 配置完整性复查
- 隐私政策有效性检查
- 截图尺寸合规性检查
- 功能数量验证（≥60）
- 测试覆盖检查

### 9.2 人类逐项确认

👨 **Human 填写清单核查**

| 检查项 | 状态 |
|--------|------|
| 图标已生成 19 个尺寸 | ☐ |
| 截图尺寸符合 Apple 规范 | ☐ |
| 隐私政策和服务条款已部署到 GitHub Pages | ☐ |
| 内购产品已在 App Store Connect 创建 | ☐ |
| TestFlight 测试通过 | ☐ |

### 9.3 在 App Store Connect 新建 App

👨 **Human 操作**：
1. 点击"新建 App"
2. 从下拉列表中选择 Bundle ID
3. 填写所有必填字段

### 9.4 点击提交审核

👨 **Human 操作**：在 App Store Connect 点击提交审核

### 9.5 关注审核状态

👨 **Human 操作**：提交后状态变为"等待审核"，首次审核通常7-14个工作日

---

## Stage 10：审核被拒处理流程

### 常见被拒原因及应对

| 拒绝类型 | 常见原因 | 应对措施 |
|---------|---------|---------|
| **App 崩溃/功能异常** | 代码 bug、未处理异常 | Agent 修复代码 → 重新 Archive → 重新提交 |
| **功能过于简单** | 功能数量 < 60 个 | 增加功能至 ≥60 个 → 更新 FeatureList.md → 重新提交 |
| **截图与实际 UI 不符** | 截图经过度美化或非真实界面 | 使用模拟器重新截图 → 更新 App Store Connect |
| **隐私政策缺失** | 未提供隐私政策 URL 或内容不完整 | Agent 生成 PrivacyPolicy.html → 部署到 GitHub Pages → 更新 URL |
| **权限描述缺失/不当** | Info.plist 权限描述为空或不清晰 | 补充英文权限描述 → 重新 Archive → 重新提交 |
| **内购未正确实现** | 假购买流程、Product ID 不匹配 | 实现真实 StoreKit 2 流程 → 检查 Product ID → 重新提交 |
| **未提供测试账号** | 需要登录的 App 未提供测试账号 | 在审核信息中提供测试账号和 Demo 数据 |

---

## 附录：完整文件模板

### A. project.yml 完整模板

见 §3.1

### B. Info.plist 完整模板

见 §4.1

### C. Entitlements 完整模板

见 §4.2 / §4.4

### D. AppIcon Contents.json

见 §4.6

### E. ScreenshotTests.swift

见 §6.2

---

## 🔗 相关文档链接

### Skills 引用
- **App Store Connect API**：`skills/app-store-connect/SKILL.md`
- **Xcode 构建分析**：`skills/xcode-build-analyzer/SKILL.md`
- **iOS 图标生成**：`skills/ios-app-icon-generator/SKILL.md`
- **AppIcon 设计规范**：`skills/ggsheng-app-icon-design/SKILL.md`

### 跨项目可复用速查卡
- **iPad 截图速查卡**：[`iPad-Screenshot-Recipe.md`](../iPad-Screenshot-Recipe.md) — 5 步可复制 UI Test 模板 + 5 症状诊断表 + iPad 截图规格表 · 与 §8.17 配套

---

---

> ⚠️ **本文档版本：3.0.0**
> ⚠️ **最后更新：2026-06-03**
> ⚠️ **所有规则和要求以本文档最新版本为准**


---

## Appendix F: VitaPocket Game-Inspired Design System

> ⚠️ **本附录是 [VitaPocket](https://github.com/lauer3912/ios-VitaMind) 项目的具体 Design System 示例，**不是** SOP 通用规范。新项目请按各自品类/品牌需求独立设计，不要直接套用本附录的具体 hex 颜色 / 柝牌稀有度 / Tab 名。
>
> 本附录存在的价值：作为 "中重度游戏化健康类 App 怎么把设计落地" 的一个完整实例，供 SOP §1.4 / §8.13 等通用章节作交叉引用。
>
> **记录日期**: 2026-05-31
> **版本**: v6 (Game-Inspired Redesign)
> **项目仓库**: https://github.com/lauer3912/ios-VitaMind

### F.1 设计理念

Pokémon TCG Pocket 的核心魅力融合到健康类 App：
- **3D 动效 + 物理反馈** → 让打卡变成"抽卡"体验
- **收集成就感** → 健康数据变成"收集图鉴"
- **进化系统** → 连续打卡 = 卡牌升级/进化
- **稀有度系统** → 闪卡(Shiny) = 30天连续打卡奖励

### F.2 项目重命名

| 旧名称 | 新名称 | 说明 |
|--------|--------|------|
| VitaMind | **VitaPocket** | "Pocket" = 口袋 + 卡牌收藏 |
| Bundle ID: com.ggsheng.VitaMind | **com.ggsheng.VitaPocket** | |
| 健康追踪 | **卡牌收集+健康** | 游戏化体验 |

### F.3 项目结构

```
Sources/
├── App/
│   ├── VitaPocketApp.swift      # @main 入口
│   ├── GameState.swift           # 全局状态 (@Observable)
│   └── ContentView.swift         # 主 Tab 导航
├── Core/
│   ├── CardEngine/
│   │   └── GameCardView.swift    # 卡牌UI组件 + 动画
│   └── Theme/
│       └── VitaTheme.swift       # Design Tokens
├── Features/
│   ├── Home/                    # 首页 (XP条 + 今日任务 + 卡组)
│   ├── Habits/                   # 习惯打卡 (卡牌战斗)
│   ├── Coach/                    # AI教练 (对话界面)
│   └── Collection/              # 图鉴 (收集 + 成就)
├── Models/
│   └── CardModels.swift          # HealthCard, HabitCard, Achievement
└── Services/
    └── (HealthKit, MiniMax等)
```

### F.4 卡牌系统

#### 稀有度 (Rarity)
| 等级 | 星星 | 颜色 | 示例 |
|------|------|------|------|
| Common | ⭐ | Teal (#4ECDC4) | 饮水卡 |
| Uncommon | ⭐⭐ | Purple (#6B4EFF) | 冥想卡 |
| Rare | ⭐⭐⭐ | Red (#FF6B6B) | 心率/睡眠卡 |
| Epic | ⭐⭐⭐⭐ | Purple (#9B59B6) | 步数卡 |
| Legendary | ⭐⭐⭐⭐⭐ | Gold (#FFD700) | 成就卡 |

#### 卡牌动画
```
card_flip:    0.6s ease-in-out  (卡牌翻转查看)
card_shine:   particle burst   (获得稀有卡闪光)
card_shake:   spring physics   (打卡震动反馈)
card_glow:    1.5s pulse       (稀有卡发光)
xp_gain:      +数字飘字        (经验值飞升)
evolution:   1.2s flash+scale (进化动画)
pull_card:    gacha-style      (抽卡动画)
```

#### 健康数据 → 卡牌映射
| 健康指标 | 卡牌名称 | 稀有度 | 单位 |
|----------|----------|--------|------|
| Heart Rate | Heart Rate | ⭐⭐⭐ | BPM |
| Steps | Steps | ⭐⭐⭐⭐ | steps |
| Sleep | Sleep | ⭐⭐⭐ | hours |
| Water | Hydration | ⭐ | glasses |
| Meditation | Meditation | ⭐⭐ | session |

### F.5 核心功能清单

#### Tab 1: Pocket (首页)
- [x] XP 等级进度条
- [x] 今日任务卡组 (滚动)
- [x] 健康数据卡牌网格
- [x] 抽卡入口按钮

#### Tab 2: Habits (习惯)
- [x] 习惯列表 (卡牌形式)
- [x] 打卡按钮 (触发卡牌动画)
- [x] 连续打卡计数器
- [x] 打卡时奖励 XP

#### Tab 3: Coach (AI教练)
- [x] AI教练头像卡片
- [x] 对话界面 (气泡+卡片混合)
- [x] 健康建议卡片
- [x] 快速操作按钮

#### Tab 4: Collection (图鉴)
- [x] 图鉴网格 (已收集/未解锁)
- [x] 筛选器 (All/Collected/Health/Habits/Shiny)
- [x] 统计面板 (总卡数/闪卡数/等级)
- [x] 成就系统

### F.6 Design Tokens

```swift
enum VitaTheme {
    enum Colors {
        static let primary = Color(hex: "6B4EFF")    // Royal Purple
        static let secondary = Color(hex: "00D9A")   // Teal
        static let accent = Color(hex: "FFD700")      // Gold
        static let background = Color(hex: "0D0B1E")  // Deep Navy
        static let surface = Color(hex: "1A1730")     // Card Background
    }
    
    enum Fonts {
        static let displayBold = .system(size:28, weight:.bold, design:.rounded)
        static let statNumber = .system(size:32, weight:.bold, design:.monospaced)
    }
    
    enum Radius {
        static let card: CGFloat = 16
        static let lg: CGFloat = 16
    }
}
```

### F.7 状态管理 (GameState)

```swift
@MainActor
final class GameState: ObservableObject {
    @Published var userLevel: UserLevel       // 等级 + XP
    @Published var healthCards: [HealthCard]  // 健康卡组
    @Published var habitCards: [HabitCard]     // 习惯卡组
    @Published var achievements: [Achievement] // 成就
    @Published var lastPulledCard: HealthCard? // 抽卡动画
    @Published var showCardAnimation: Bool = false // 动画触发器
}
```

### F.8 SOP 更新记录

| 日期 | 更新内容 |
|------|----------|
| 2026-06-03 | v11: 新增 §8.19 模拟器辅助工具 (5 子节) + §8.20 XCUITest 性能策略 (4 子节) + §8.21 Agent 工作流与 SOP 自我进化 (5 子节) + HR-63~71 + SC-49~54；沉淀 9 大新经验：cliclick 坐标换算公式、ffmpeg 两步法 GIF 工具链、recordVideo 必须 SIGINT、xcodebuild test 整跑卡死诊断、simulator 状态污染重置、早 8 点汇报铁律、立即汇报铁律、当日沉淀铁律、workspace 文件组织原则 |
| 2026-06-03 | v10: 新增 §8.16 本地通知 (5 子节) + §8.17 截图自动化 (5 子节) + §8.18 Mock 数据清理 (5 子节) + HR-56/57/58/59/60/61/62 + SC-42/43/44/45/46/47/48；沉淀 9 大新经验：UNUserNotificationCenterDelegate.willPresent 必要性、@AppStorage import SwiftUI 陷阱、App.init() 通知权限竞态、iPad page-style 切 tab 不可靠、interruption monitor 必须在 setUp 注册、角落 tap 触发 monitor、Release config 截图一致性、首启空状态 UI 兜底、emoji 假 AI 风险 |
| 2026-06-02 | v9: 新增 §8.14 Multi-Provider AI Service + §8.15 HealthKit 集成；HR-51/52/53/54/55 + SC-38/39/40/41；沉淀 7 大新经验：baseURL 必须 dynamic、HTTP 错误码分类、guard 双重检查、@Published 必须有消费者、HealthKit Mock fallback、健康服务必须可达、首屏不能为空 |
| 2026-06-02 | v8: 新增 §8.13 Light/Dark 主题实现 + HR-48/49/50 + SC-34/35/36/37；沉淀 VitaPocket 双主题调色板、阴影系统、navigation bar 陷阱、横向滚动提示、空状态设计、Tab Bar 遮挡修复 6 大经验 |
| 2026-05-31 | v6: 增加 VitaPocket 游戏化设计系统 (Appendix F) |
| 2026-05-30 | v5: 移除 GitHub Actions CI/CD 相关内容 |
| 2026-05-28 | v4: 初始版本 |


---

## Appendix G: SOP 引用的项目 git 仓库清单

> **【强制】任何项目名在 SOP 中出现时，必须在同一行 / 同一 blockquote / 同一 table 单元格内附上其 git 仓库地址。HR-75**

本附录是 SOP 中所有"作为实战举例 / 附录参考 / 真实案例"提到的项目的统一索引。每个项目附：
- 仓库 URL（点击直达）
- 出现位置（哪一章 / 哪一节 / 哪一表行）
- 角色（实战出处 / 设计示例 / 案例参考）

### G.1 当前引用项目列表

| # | 项目 | git 仓库 | 仓库角色 | 在 SOP 中的位置 |
|---|------|----------|----------|------------------|
| 1 | **VitaPocket** (Display: VitaMindGo) | [github.com/lauer3912/ios-VitaMindGo](https://github.com/lauer3912/ios-VitaMindGo) | 通用 SOP 沉淀的最重要实战项目 | • F.8 历史（多次出现）<br>• HR-72 / SC-55 规则中作为"反例"<br>• §8.13 / §8.14 / §8.15 / §8.16 / §8.17 / §8.18 实战举例 (≤3 处)<br>• Appendix F: Game-Inspired Design System (整附录) |
| 2 | ~~**ios-VitaMind**~~ (旧仓库) | ~~[github.com/lauer3912/ios-VitaMind](https://github.com/lauer3912/ios-VitaMind)~~ **已删 (2026-06-04 lauer3912 手动)** | VitaPocket 2026-06-03 rename 前的仓库 | 历史上仅出现在 rename 期间 (迁移后无引用) |

### G.2 引用规则维护流程

- **新增项目引用时**：在 G.1 表格新增一行，写清 git URL + 出现位置 + 角色
- **删减项目引用时**：在 G.1 删对应行 + 在主文 `grep` 删除该名字
- **git URL 失效时**：SC-57 触发，Agent 必须先修复 URL 链接才能继续

### G.3 新增项目引用 checklist (HR-75 配套)

- [ ] 在 SOP 主文提及项目名
- [ ] 同一行 / 同一 blockquote / 同一 table 单元格附 `[<项目名>](https://github.com/<owner>/<repo>)` 形式
- [ ] 在 G.1 表格新增一行
- [ ] 跑 `grep -c "VitaPocket" docs/SOP-iOS-Local-Development.md` ≤ SC-55 阈值 (20)
- [ ] 跑 `grep "github.com/..." docs/SOP-iOS-Local-Development.md | wc -l` ≥ 1 (至少有一处 URL)

### G.4 已删除的过时项目引用

- **ios-VitaMind** — 2026-06-04 lauer3912 手动删除
  - 原因: 2026-06-03 rename 为 ios-VitaMindGo 后，这个空壳仓库仅作 redirect 占位
  - 删后影响: 旧 URL 从 301 redirect 变 404；SOP §8.4.3 检测项 4 接受 301 或 404 两者任一
  - 保留记录原因: 证明 HR-75 引用项目的仓库 URL 需随仓库状态变化同步维护 (GitHub redirect 状态下 URL 仍可用，删后则失效)

---

## Appendix H: 2026-07-01 Project Bootstrap Patterns 实战补丁

> **补漏来源**: 对照 `VitaMind (Display: VitaMindGo)` + `ReverseWorld (Display: ReverseWorldGo)` + `StretchFlow (Display: StretchGoGo)` + `Stellumbra (Display: Stellumbra)` 4 个项目后发现 SOP §0-§10 共漏 8 项实战模式。本补丁是 Stellumbra scaffold 阶段撞出暴露的。
>
> **HK-实战触发**: 07-01 14:40 CST 佛老爷指令 "估计 SOP 文档有些内容丢失了, 先读 VitaMindGo 和 ReverseWorldGo 源代码及目录结构, 找到共同点更新 SOP 文档"。

### H.1 Info.plist 模板化 — 永远用 Xcode 变量,绝不硬编码

**规则**: Info.plist 字段**永远**用 Xcode 变量占位符,**绝不**硬编码版本号 / 标识符 / 名称。新项目 scaffold 时一次性写对。

| 字段 | ❌ 错(硬编码) | ✅ 对(Xcode 变量) |
|------|--------|--------|
| `CFBundleShortVersionString` | `<string>3.1.0</string>` | `<string>$(MARKETING_VERSION)</string>` |
| `CFBundleVersion` | `<string>14</string>` | `<string>$(CURRENT_PROJECT_VERSION)</string>` |
| `CFBundleIdentifier` | `<string>com.ggsheng.MyApp</string>` | `<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>` |
| `CFBundleName` | `<string>myapp</string>` | `<string>$(PRODUCT_NAME)</string>` |
| `CFBundleExecutable` | `<string>myapp</string>` | `<string>$(EXECUTABLE_NAME)</string>` |
| `CFBundlePackageType` | `<string>APPL</string>` | `<string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>` |
| `CFBundleDevelopmentRegion` | `<string>en</string>` | `<string>$(DEVELOPMENT_LANGUAGE)</string>` |

**反例 — Stellumbra Info.plist (07-01)**:
```xml
<key>CFBundleShortVersionString</key>
<string>3.0.0</string>           <!-- ❌ 硬编码 -->
<key>CFBundleVersion</key>
<string>1</string>             <!-- ❌ 硬编码 -->
```

修法: `Sources/Resources/Info.plist` 改 `<string>$(MARKETING_VERSION)</string>` + `<string>$(CURRENT_PROJECT_VERSION)</string>`。

**结过 Xcode build verify**: 三件套同步 (project.yml + Info.plist + xcodegen) 才能保证一致性。

### H.2 CFBundleDisplayName "Go" 后缀约定

**观察**: 4 个项目 3 个用 codename + "Go" 后缀模式:

| 目录 codename | Display name | 来源 |
|-------------|-------|------|
| VitaMind | VitaMindGo | § project.yml `name: VitaMindGo` |
| ReverseWorld | ReverseWorldGo | § project.yml `name: ReverseWorld` + Info.plist DisplayName=`ReverseWorldGo` |
| StretchFlow (历史遗留) | StretchGoGo | § 项目历史改名 |
| **Stellumbra** | **Stellumbra** ❌ 不符一致模式 | scaffold 未对齐 |

**新项目规则** (HR-75 同类): 除非品牌特殊 (Stellumbra 是拉丁文词根不需后缀),按 `codename + "Go"` 命名 `CFBundleDisplayName`。

**例外**: 个别项目可能叫 "vault"/"app"/"plus" 等, 但默认走 "Go" 后缀以保证品牌一致性。

### H.3 PrivacyInfo.xcprivacy — Apple 强制要求 (2024+)

**Apple 政策**: 2024 年起所有 App Store 提交**必须**包含 `PrivacyInfo.xcprivacy` privacy manifest, 记录:

| 字段 | 用途 |
|------|------|
| `NSPrivacyTracking` (bool) | 是否追踪用户 (App Tracking Transparency 受影响) |
| `NSPrivacyTrackingDomains` ([String]) | 追踪域列表 |
| `NSPrivacyCollectedDataTypes` ([Dict]) | 收集的数据类型 + 用途 + 是否脱敏 |
| `NSPrivacyAccessedAPITypes` ([Dict]) | 调用的 Required Reason API (UserDefaults, FileTimestamp, DiskSpace, SystemBootTime 等) |

**实战位置** (`ReverseWorld`):
```
ios/ReverseWorld/PrivacyInfo.xcprivacy
```

**project.yml 必须包含**:
```yaml
sources:
  - path: ios/ReverseWorld   # 或 path: ReverseWorld
    includes:
      - "**/PrivacyInfo.xcprivacy"
```

**target status**:
- VitaMind: ❓ 待定 (本附录未核对)
- ReverseWorld: ✅
- StretchGoGo: ❓ 待定
- **Stellumbra: ❌ 缺** (07-01 待修)

### H.4 Localizable.xcstrings — 多语言 (可选但推荐)

**ReverseWorld 实战** (07-01): `ios/ReverseWorld/Localizable.xcstrings` 已支持多语言 strings 集中管理。

**新项目规则**:
- 仅英文市场: 仍建议加 (未来 i18n 不用改架构)
- 多语言市场: 必加 (zh-CN + en-US 起步)

**Stellumbra 状态**: ❌ 缺, 但 scaffold 06-30 阶段非阻塞。

### H.5 App Groups entitlement — Watch + Widget 数据共享

**VitaMind 实战** (project.yml):
```yaml
entitlements:
  path: Sources/VitaPocket.entitlements
  properties:
    com.apple.security.application-groups:
      - group.com.ggsheng.VitaMind
```

**Info.plist 不需要直接配**,系统从 entitlements 读。

**强制适用场景**:
- Apple Watch Companion App (主 App + Watch App 共享 SwiftData)
- Widget Extension (主 App + Widget 共享 UserDefaults)
- Background Task 数据传递

**Stellumbra 状态**: ❓ Stellumbra 主线不是 Watch, HealthKit entitlement 已加。Family Controls entitlement 已留(可能未来 Watch 用), 暂无需 App Groups。

### H.6 AppStore/Screenshots 多尺寸命名约定

**VitaMind 实战** (`AppStore/Screenshots/`):
```
iPadPro13inchM4_2048x2732/   # 设备名_像素尺寸
iPhone17ProMax_1320x2868/    # 注意: iPhone 17 Pro Max
AppleWatchUltra3_396x484/    # Watch 截图单独类目
paywall_1290x2796/           # IAP 支付截图单独类目
legacy-5-31/                  # 历史版本截图 (不删,留 ASO 对照)
legacy-5-31-ipad/
```

**ReverseWorld 实战** (`AppStore/Screenshots/`):
```
iPadPro13/                    # 简写 (设备名)
iPhone67/                     # 简写 (像素高度)
iPhone_69_1320x2868/         # 详写 (型号 + 像素)
InAppPurchase/                # IAP 截图 (VitaMind 名 `paywall_*` 不一致)
```

**统一规则 (建议)**:
| 类型 | 命名模式 | 例子 |
|------|---------|------|
| 主设备 | `{DeviceName}_{WxH}/` | `iPhone17ProMax_1320x2868/` |
| iPad | `{DeviceName}/` (简写) | `iPadPro13/` |
| Watch | `{WatchName}_{WxH}/` | `AppleWatchUltra3_396x484/` |
| Paywall | `paywall_{WxH}/` | `paywall_1290x2796/` |
| Legacy | `legacy-{ver}/`(保留) | `legacy-5-31/` |

**Stellumbra 状态**: `AppStore/Screenshots/` 目录**还没建** (07-01 §0.5 review 时发现 §0.5 替换表**漏掉** Screenshots 必须预建)。

### H.7 AppStore/Docs 必备文件清单

| 文件 | 用途 | VitaMind | ReverseWorld | Stellumbra |
|------|------|----------|--------------|------------|
| `FeatureList.md` | ≥10 核心 + ≥60 全部 (ASC 必报字段) | ✅ | ✅ | ✅ (`ProjectProposal.md` 含) |
| `PrivacyPolicy.html` | 本地副本 (可上传到 GitHub Pages) | ✅ | ✅ | ❌ **缺** |
| `TermsOfService.html` | EULA 本地副本 | ✅ | ❌ (建议加) | ❌ **缺** |
| `ExecutionLog.md` | Stage 执行记录 (audit trail) | ✅ | ❌ | ❌ **缺** (建议加) |
| `ASC-Setup-Cheatsheet-v{ver}.md` | ASC 后台配置指南 | ✅ | ❌ (建议加) | ❌ **缺** |
| `Submission-Checklist.md` | 提交前 checklist | ✅ | ❌ | ❌ **缺** |
| `ProjectProposal.md` | 项目立项 (内审用) | ✅ | ❌ | ✅ |
| `Listing.md` | ASC 元数据填写指南 | ✅ | ✅ | ✅ |

**新项目 SOP 强制 (HR-75 同级)**:
1. `FeatureList.md` — 必, ASC 必报 ≥60 功能
2. `PrivacyPolicy.html` — 必, ASC 必填字段 (`privacyPolicyUrl` 字段)
3. `TermsOfService.html` — 必, ASC 必填字段 (`EULA` 字段)
4. `Submission-Checklist.md` — 必, 提审前自检

### H.8 Bundle ID Prefix 选名建议 (扩展 §0.4)

**佛老爷已用前缀**:

| 前缀 | 现有 App | Bundle ID 示例 |
|------|----------|---------------|
| `com.ggsheng.*` | StretchGoGo (6763179117), ReverseWorldGo (6784627660), VitaMindGo (6774840392) | `com.ggsheng.StretchGoGo` |
| `com.YOURNAME.*` (占位) | Stellumbra scaffold (07-01 待替换) | (未定) |

**约束** (per SOP §0.4 + #40):
- 避免 `com.example.*` (Apple 拒)
- 避免与已上架 App 重复
- 选一个可永久代表个人/团队的前缀
- ASC 不可逆 — 下架才能换

**建议候选**:
- `com.techidaily.*` — 与 `support@techidaily.com` 邮箱域名一致 (#42 拍板 contact email)
- `com.lauer3912.*` — 与 GitHub 用户名一致 (`lauer3912.github.io` Pages)

**Stellumbra 待佛老爷拍板** (07-01 14:50 CST 仍在等).

---

## Appendix I: 2026-07-01 Changelog (增量)

v12 (2026-07-01 14:50 CST):
- 本次 v12 增 Appendix H (Project Bootstrap Patterns 实战补丁) 共 8 子节
- **沉淀 8 个新发现** (HR-82 ~ HR-89):
  - HR-82 Info.plist 永远用 Xcode 变量占位符 (不硬编码版本号 / 标识符 / 名称) — Stellumbra scaffold 反例直接暴露
  - HR-83 CFBundleDisplayName "Go" 后缀约定 (除品牌特殊)
  - HR-84 PrivacyInfo.xcprivacy 2024+ Apple 强制要求 (项目必须含)
  - HR-85 Localizable.xcstrings 多语言 strings 集中管理
  - HR-86 App Groups entitlement (Watch + Widget 数据共享必备)
  - HR-87 AppStore/Screenshots 多尺寸命名约定 (`{Device}_{WxH}` + `paywall_*` + `legacy-*`)
  - HR-88 AppStore/Docs 6 项必备文件 (FeatureList + PrivacyPolicy + TermsOfService + Submission-Checklist + ... )
  - HR-89 Bundle ID Prefix 选名建议 (现有前缀 + 候选)
- 实用: HR-82 反例触发 — Stellumbra scaffold Info.plist 硬编码 `CFBundleShortVersionString="3.0.0"` 而非变量, 修正走 git commit
- 实用: HR-83 "Go" 后缀约定 — Stellumbra DisplayName="Stellumbra" 不符合 3/4 项目既有惯例 (品牌特殊可豁免, 但应在 ProjectProposal 中声明)

