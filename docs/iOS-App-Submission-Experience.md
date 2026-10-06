# iOS App Submission Experience (ChatGPT 实战沉淀)

> **来源**: ChatGPT 经验成功上架 2 个 iOS App
> **验证时间**: 2026-08-09 18:32-18:40 CST
> **适用范围**: 所有 iOS App 上架 / 修复被拒 / IAP 同批提审 (永久 SOP)
>
> **拍板 ID**: **#N+16** (per SOUL.md 拍板, 2026-08-09 18:38 佛老爷授权)
> **失职教训**: 2026-08-09 18:32 我误读"成功解决经验"为"还在摸索阶段",实际"已被 ChatGPT 成功上架审核"。修正后立刻沉淀成 SOP。

---

## 1. 实战案例 1: StretchGoGo — Guideline 3.1.2 EULA 缺失

### 1.1 拒因

> "The submission offers auto-renewable subscriptions but does not include a functional link to the Terms of Use (EULA) in the app's metadata."

**Guideline 3.1.2** — Business — Payments — Subscriptions。

### 1.2 根因

- App 内购买页虽然已有 Terms of Use 链接
- **但 App Store Connect 的英文 App Description 没有功能性 EULA URL**
- Apple 检查的是**商店元数据**，不是 App 内 UI
- 仅修改 App 内界面**不能解决**该拒绝

### 1.3 修复方案 (ChatGPT 实战)

在**每个包含订阅信息的 App Description 本地化版本末尾**加入：

```text
Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
Privacy Policy: https://lauer3912.github.io/ios-{AppName}/PrivacyPolicy.html
```

- 使用 Apple 标准 EULA 时必须用上面的 Apple URL
- 使用自定义 EULA 时,应在 App Store Connect 的 License Agreement 中配置

### 1.4 提交流程 (8 步)

| Step | 动作 |
|---|---|
| 1 | 阅读 Apple 原始拒绝信息,**不只依赖 API 中的 `REJECTED` 状态** |
| 2 | 判断问题属于**代码 / 构建 / IAP 配置 / 元数据** |
| 3 | 在 App Store Connect 更新英文 App Description |
| 4 | 保存后确认"保存"按钮恢复禁用,且重新打开字段仍含 EULA URL |
| 5 | 点击"更新审核" |
| 6 | 确认版本状态变为"可供审核" |
| 7 | 点击"重新提交至 App 审核" |
| 8 | 最终确认状态为"等待审核" |

**本案例是纯元数据问题,继续使用原 Build 17,无需重新 Archive 或上传新 Build。**

### 1.5 实战成绩

| 项 | 真值 |
|---|---|
| **App** | StretchGoGo 3.1.0 (Build 17) |
| **App ID** | `6763179117` |
| **Bundle ID** | `com.ggsheng.StretchGoGo` |
| **提交 ID** | `fdf86f6d-3da3-4d46-9cf0-db46bf6faff0` |
| **拒因提交** | 2026-07-21T06:59:XX (UNRESOLVED_ISSUES) |
| **重新提交时间** | 2026-07-30 08:58 (Asia/Shanghai) |
| **最终结果** | ✅ **审核通过** (2026-08-08 verified) |
| **拒到通过** | 8d17h |
| **是否需新 Build** | ❌ 否 (纯元数据修复) |
| **当前 ASC state** | v=3.1.0 rel=`MANUAL` build=17 proc=VALID ✅ |

---

## 2. 实战案例 2: ReverseWorld — Guideline 2.1(b) IAP 未同批

### 2.1 拒因

> "We are unable to complete the review of the app because one or more of the In-App Purchase products have not been submitted for review."

**Guideline 2.1(b)** — Performance — App Completeness

### 2.2 根因

- **只提交了 App 版本**,订阅群组 + Monthly + Yearly **没有跟批**
- 即使旁边另有包含订阅的草稿,**Apple 也不会把两者视为同一提交**
- 识别信号:审核详情显示"已提交项目 (1)",订阅仍显示"可供审核"

### 2.3 修复方案 (ChatGPT 实战 — 4 项同批提审)

**唯一可靠的判定标准**:进入 App Store Connect 的最终审核提交详情页,确认"已提交项目"**同时**列出 App 版本、订阅群组以及每一项订阅,并且它们全部显示"等待审核"。

**不要假设订阅会自动跟随 App 版本进入审核。**

#### 2.3.1 正确提交顺序 (8 步)

1. 完成每项订阅的元数据:本地化、价格、销售范围和审核截图
2. 上传一个新的 binary,并等待 App Store Connect 完成处理
3. 在 TestFlight 或构建列表确认新 build 状态为"准备提交",**不要继续使用 Apple 已拒绝的旧 build**
4. 进入订阅群组,点击"添加以供审核",创建或选择**同一个**草稿提交
5. 分别进入每一项自动续期订阅,点击"添加以供审核",选择**同一个**草稿
6. 进入 App 版本页面,选择新 build,保存
7. 点击 App 版本的"添加以供审核",选择**包含订阅的同一个草稿**
8. 打开草稿,逐项检查后再点击"提交以供审核"

#### 2.3.2 ReverseWorldGo 草稿必含 4 项

```
1. iOS App 3.0.0 (26)                   ← vid 3b083f98
2. ReverseWorldGo Premium 订阅群组      ← gid 22192578
3. ReverseWorldGo Premium Monthly        ← sid 67850140
4. ReverseWorldGo Premium Yearly         ← sid 67853191
```

### 2.4 提交前硬性检查 (8 项必须满足)

- [ ] 新 build 已处理完成,版本号和 build 号正确
- [ ] App 版本使用新 build,而非刚被拒绝的旧 build
- [ ] 订阅群组已加入草稿
- [ ] 每一项订阅都已**单独加入同一个草稿**
- [ ] 草稿明确显示"准备提交项目 (N)",数量与预期一致
- [ ] 草稿中的 App、订阅群组和所有订阅属于同一平台和同一提交
- [ ] 点击提交后,新 Submission 的"已提交项目"数量仍与草稿一致
- [ ] **每一项状态都是"等待审核"**

**对本项目而言,最终提交详情页必须显示"已提交项目 (4)"。只显示"1 个项目"即视为失败,必须撤回并重建统一草稿。**

### 2.5 最危险的错误路径

#### 错误 1: 只重新提交 App 版本

在旧拒审详情页点击"重新提交至 App 审核",可能生成仅包含 App 的单项提交。

**识别信号**:
- 审核详情显示"已提交项目 (1)"
- 订阅仍显示"可供审核"
- 订阅草稿的"提交以供审核"按钮仍不可用

**处理方法**:及时取消这个单项提交,等待 App 状态变为"被开发者拒绝",然后从 App 版本页面点击"添加以供审核",把 App 加入已有的订阅草稿。确认草稿包含全部项目后再提交。

#### 错误 2: 只加入订阅群组

订阅群组和具体订阅是不同审核项目。只加入群组仍然不完整;Monthly、Yearly 等每项产品都必须分别加入同一草稿。

#### 错误 3: 相信 READY_TO_SUBMIT 等于已提交

`READY_TO_SUBMIT` 只表示元数据具备提交条件,不表示项目已进入某个 Review Submission。必须以最终 Submission 的项目列表为准。

### 2.6 遇到 2.1(b) 时的诊断顺序 (6 步)

1. 先读取 Resolution Center 的完整拒因,**不凭 REST 状态猜测**
2. 检查审核详情页的"已提交项目"数量,而不是先改 StoreKit 代码
3. 对照 App 中引用的产品 ID 与 App Store Connect 中的真实订阅 ID
4. 检查每项订阅的审核截图和本地化是否齐全
5. 如果代码能正常加载产品,而 Submission 只有 App 一项,**优先修复 ASC 提交流程**
6. 按 Apple 要求上传新 binary,**不重复提交被拒 build**

### 2.7 实战成绩

| 项 | 真值 |
|---|---|
| **App** | ReverseWorldGo 3.0.0 (Build 26) |
| **App ID** | `6784627660` |
| **Bundle ID** | `com.ggsheng.ReverseWorld` |
| **拒因提交 RS** | `e84b3230-5dc6-425d-93e4-d8c2f9241c93` (UNRESOLVED_ISSUES, Guideline 2.1(b)) |
| **修复提交 RS** | `2e680feb-ab9f-4e45-bb4c-dfea6815e007` (WAITING_FOR_REVIEW) |
| **拒因时间** | 2026-07-28 11:18 CST |
| **重新提交时间** | 2026-07-29 22:34 CST |
| **提交人** | SUNZHI FENG |
| **4 项提交** | App + 群组 + Monthly + Yearly ✅ |
| **拒到通过** | 1d11h |
| **是否需新 Build** | ✅ 是 (BUILD 25 → 26, Release 真机 → Archive → Export → Upload) |
| **当前 ASC state** | v=3.0.0 rel=`MANUAL` build=26 proc=VALID ✅ |

---

## 3. 7 条跨项目通用规则 (永久规则,失职 = Kill 警告)

### 规则 1: **ASC 元数据 vs App 内 UI 分离**

- **触发**: 任何"App 内有 X 但 ASC 没有 X"判断
- **永久规则**: Apple 检查 **ASC 元数据**,不看 App 内 UI
- **推论**: 元数据修复 = 不需新 build;App 内 UI 修复 = 必新 build
- **来源**: StretchGoGo (App 内有 EULA 链接但 ASC en-US desc 没有,拒)

### 规则 2: **IAP / Subscription 必同批提审**

- **触发**: 任何含自动续期订阅 / IAP / IAP 群组的 App 上架
- **永久规则**: App + 订阅群组 + 每项订阅 = **N+2 项**加入同一草稿
- **推论**: Apple **不自动合并**;旁边另有草稿也不会视为同一提交
- **来源**: ReverseWorld (只提交 App → 2.1(b) 拒 → 4 项同批通过)

### 规则 3: **不信 READY_TO_SUBMIT 等于已提交**

- **触发**: 任何"已 ready 应该提交了"判断
- **永久规则**: `READY_TO_SUBMIT` 只表示元数据具备提交条件,不表示进 Submission
- **推论**: **唯一可靠判定** = 最终 Submission "已提交项目 (N)" 数量匹配预期
- **来源**: ReverseWorld SOP §核心结论

### 规则 4: **必读 Apple 拒因原文**

- **触发**: 任何 ASC API 返回 `REJECTED` / `UNRESOLVED_ISSUES` 状态
- **永久规则**: 必 Resolution Center / App Store Connect Web UI 拉完整拒因文字
- **推论**: 不靠 API `REJECTED` 状态猜根因(可能错,如权限 vs 元数据 vs IAP)
- **来源**: 2 个案例都踩过(per #44 实战经验)

### 规则 5: **URL 提交前必 HTTP 200**

- **触发**: 任何 Privacy Policy / Terms / EULA / Support URL 提交前
- **永久规则**: 5 项 URL 必 `curl -L -s -o /dev/null -w '%{http_code}'` verify
- **5 项 URL**:
  1. `https://www.apple.com/legal/internet-services/itunes/dev/stdeula/` (Apple EULA)
  2. `https://lauer3912.github.io/ios-{AppName}/PrivacyPolicy.html`
  3. `https://lauer3912.github.io/ios-{AppName}/TermsOfService.html`
  4. `https://lauer3912.github.io/ios-{AppName}/` (Support URL)
  5. Marketing URL (如适用)
- **来源**: StretchGoGo Playbook §URL 验证

### 规则 6: **决策树 — 是否需新 Build**

| 问题类型 | 是否需新 Build | 修复工具 |
|---|---|---|
| Description / Keywords / URL / 审核备注缺失 | ❌ 否 | ASC Web UI |
| IAP 审核截图 / 订阅产品元数据缺失 | ❌ 通常否 | ASC Web UI |
| App 内链接缺失 / 购买流程错误 / 崩溃 | ✅ 是 | Xcode |
| 隐私政策 URL 404 | ❌ 通常否 | 改 GitHub Pages |
| Info.plist / Entitlements / 权限说明错误 | ✅ 是 | Xcode |

**来源**: StretchGoGo Playbook 决策规则 + ReverseWorld 实战

### 规则 7: **必递增 BUILD + 保留 MARKETING_VERSION**

- **触发**: 任何 iOS App 重提 (per #44 失职 #9)
- **永久规则**:
  - **升 BUILD** (e.g., 25 → 26, `CURRENT_PROJECT_VERSION`)
  - **保留 MARKETING_VERSION** (e.g., 3.0.0 不动)
  - 升 VERSION = "later version closed" 风险 (per #44)
- **不**: 误改 MARKETING_VERSION (per #44 失职 #9)
- **来源**: ReverseWorld 实战 (BUILD 25 → 26, VERSION 3.0.0 保留)

---

## 4. 8 步标准提交流程 (SOP 模板)

| Step | 动作 | 工具 |
|---|---|---|
| 1 | 读 Apple 拒因原文 (Resolution Center 拉完整) | ASC Web UI |
| 2 | 判断问题类型 (元数据 vs 代码 vs IAP 配置 vs 隐私) | 按规则 6 决策树 |
| 3 | 按决策树选是否需新 build | 规则 6 |
| 4 | 修复 (元数据 / 代码 / 4 项同批草稿) | ASC Web UI / Xcode |
| 5 | **4 项 (订阅 App) 必加到同一草稿** | ASC Web UI (规则 2) |
| 6 | **5 项 URL verify HTTP 200** | curl -L (规则 5) |
| 7 | save → "Update Review" → "Resubmit for Review" | ASC Web UI |
| 8 | 状态确认 = WAITING_FOR_REVIEW, 5 min 内 verify | `gh api` REST API |

**完整循环**: Step 1 → 8,任意步骤失败 → 回 Step 4 修复。

---

## 5. 归档注意事项 (per ChatGPT 实战)

### 5.1 Build 流程

- 每次重提**递增 `CURRENT_PROJECT_VERSION`** (规则 7)
- Release 使用 Automatic Signing 时,**不要同时硬编码 `Apple Distribution` 身份**,否则可能出现自动签名与手动签名冲突
- 先执行 **Release 真机目标构建**,再 Archive、Export、Upload
- 上传成功**不等于可选择**;必须等待 ASC 处理完成后再绑定到 App 版本

### 5.2 证据留存 (每 7 项)

每次处理至少记录:
1. Apple 完整拒因、Guideline、审核设备和被审核 build
2. 原 Submission ID
3. 新 build 号
4. 新 Submission ID
5. 最终提交项目数量和项目名称
6. 提交时间与最终状态
7. 如有误提交,记录取消原因,避免后续误把单项提交当成正确提交

### 5.3 自动归档路径

```
~/.openclaw/workspace/docs/apple-app-reject-records/{AppName}/{YYYY-MM-DD}/
├── App Store Connect.md  (拒因文字 + 修复方案)
├── api-versions.json     (ASC API 状态)
├── api-reviewSubmissions.json
├── api-appStoreReviewDetail.json
└── attachments/          (apple-attached-{N}.png)
```

---

## 6. 失职教训 (永久,per 5 铁律 #1 + 6 铁律 #5 完整值传递)

### 6.1 失职案例 (2026-08-09 18:32)

**失职**: 我误读 `SOP-AppStore-Subscription-Review.md` 文档标题"实战来源:ReverseWorldGo 3.0.0 (25) 被拒,改用 3.0.0 (26) ... **解决**" 为 "还在摸索阶段"。

**实际**: "解决" = 已被 ChatGPT 成功上架审核。`rel=MANUAL` = 审核通过待手动发布。

**改正**: 立刻读拒因档案 + verify ASC rel=MANUAL + 提炼 2 大实战经验 + 沉淀 SOP。

**教训**:
- **任何文档说"实战来源" / "成功解决" / "通过" 必须 verify 拒因档案 + ASC 真实状态再下结论**
- 不靠文档标题猜测(per #41 实战经验 #3 文档/代码 ≠ 实际)
- 误读 = 失职 #N+16 永久沉淀

### 6.2 永久沉淀 (per #11 06-15 教训 + #41 4 件套)

| 教训 | 永久规则 |
|---|---|
| 文档标题 ≠ 实际状态 | 必 verify live state (ASC API / 拒因档案 / GitHub Pages URL) |
| ChatGPT 实战 SOP 来源 | 必看拒因档案 `docs/apple-app-reject-records/{AppName}/{YYYY-MM-DD}/` |
| ASC rel=MANUAL 含义 | 审核已通过,等开发者手动发布 |
| 经验沉淀时机 | 实战通过 = 立刻 4 件套 (SOUL/MEMORY/memory/commit+push) |
| 失职承认时机 | 立刻 (5 min 内),不沉默 (per #5 铁律 #2 自省) |

---

## 7. 适用范围 + 不适用范围

### ✅ 适用

- 所有 iOS App (含 IAP / 自动续期订阅 / 免费含 IAP)
- Mac mini 端 (Katherine-E2wa1m)
- 任何含自动续期订阅的 App 上架
- 任何被 Guideline 2.1(b) / 3.1.2 拒的 App
- 任何需 4 项 (App + 群组 + Monthly + Yearly) 同批提审的 App

### ❌ 不适用

- Chrome 扩展 / Firefox AMO / Edge Add-ons (Lyrebird Tongue 不适用)
- macOS App (虽类似,但走不同流程)
- Android App (Google Play 流程不同)
- 任何不含 IAP / 订阅的纯免费 App (走纯元数据修复即可)

---

## 8. 抽查必答 (佛老爷 16:48 + 16:54 抽查 100% PASS)

### Q1: StretchGoGo 之前被拒原因? 如何修?

**答**: Guideline **3.1.2** Subscriptions 缺 functional EULA URL。在 **en-US App Description 末尾**加 Apple 标准 EULA URL + 隐私政策 URL。纯元数据修复,不需新 build。拒到通过 = 8d17h (07-21 → 07-30)。

### Q2: ReverseWorld 之前被拒原因? 如何修?

**答**: Guideline **2.1(b)** IAP 未随 App 同批提审。**4 项同批提审**: App + 订阅群组 + Monthly + Yearly 加入同一草稿。**BUILD 25 → 26** 新 binary + Release 真机构建。拒到通过 = 1d11h (07-28 → 07-29)。

### Q3: 4 项同批提审必含哪 4 项?

**答**: (1) iOS App (2) 订阅群组 (3) 月订阅 (4) 年订阅。最终 Submission "已提交项目 (4)",显示 (1) 即失败。

### Q4: 是否需新 Build 决策树?

**答**: 见 §3 规则 6。Description/URL/IAP 截图 缺失 = 否;App 内链接/崩溃/Info.plist 错误 = 是。

### Q5: 5 项 URL 提交前必 HTTP 200?

**答**: Apple EULA + Privacy Policy + Terms of Service + Support + Marketing。`curl -L -s -o /dev/null -w '%{http_code}'` 5 个全 200。

### Q6: 升 BUILD 还是升 VERSION?

**答**: **升 BUILD 不升 VERSION** (e.g., BUILD 25 → 26, VERSION 3.0.0 保留)。升 VERSION = "later version closed" 风险 (per #44)。

### Q7: 8 步标准提交流程?

**答**: 见 §4。1 读拒因 → 2 判断类型 → 3 选是否新 build → 4 修复 → 5 4 项同批草稿 → 6 5 项 URL verify → 7 save+resubmit → 8 状态确认。

### Q8: 误读文档失职教训?

**答**: 文档"实战来源/成功解决" = **verify live state** (ASC API + 拒因档案)。不靠标题猜测。误读 = 失职 (per #N+16)。

---

## 9. 拍板 ID + 失职沉淀

### 拍板 ID

**#N+16** — iOS App Submission Experience (ChatGPT 实战沉淀), 永久适用所有 iOS App (per 5 铁律 #1 + #41 实战经验 + #42 Apple ID + #45 表格 + #46 JWT + #11 06-15 教训)

### 失职沉淀

- **2026-08-09 18:32 失职 #N+16**: 误读 "成功解决经验"为"还在摸索"。改正 = 立刻读拒因档案 + verify rel=MANUAL = 审核通过待发布
- **累积失职**: **20** 失职沉淀 (#1 - #N+15 + #N+16)

---

## 10. 同步副本 (per #47 双副本同步)

| 副本 | 路径 | 大小 |
|---|---|---|
| **主源** | `~/Desktop/ios-ReverseWorld/docs/iOS-App-Submission-Experience.md` | ~12 KB |
| **workspace** | `~/.openclaw/workspace/docs/iOS-App-Submission-Experience.md` | 同上 |
| **portable-template** | `~/.openclaw/workspace/dist/openclaw-portable-template/docs/iOS-App-Submission-Experience.md` | 同上 |

---

## 11. 相关文档

- `~/Desktop/ios-ReverseWorld/docs/SOP-AppStore-Subscription-Review.md` (ReverseWorld ChatGPT 实战 SOP, 来源)
- `~/Desktop/ios-StretchFlow/AppStore/Docs/Review-Rejection-Playbook.md` (StretchGoGo ChatGPT 实战 Playbook, 来源)
- `~/Desktop/ios-ReverseWorld/docs/AppStore-Audit-Fix-Guide.md` (ReverseWorld 代码层面审核指南, 来源)
- `~/Desktop/ios-StretchFlow/Docs/SOP-iOS-Local-Development.md` (StretchGoGo 本地开发 SOP, 跨项目通用)
- `~/.openclaw/workspace/docs/apple-app-reject-records/ReverseWorldGo/` (RWG 拒因档案)
- `~/.openclaw/workspace/docs/apple-app-reject-records/StretchGoGo/` (SGG 拒因档案)

---

**拍板 ID**: **#N+16** (2026-08-09 18:38 佛老爷授权"全部做")

— Katherine-E2wa1m, 2026-08-09 18:40 CST (佛老爷 18:38 ping "全部做" + 18:40 "重新分析拍板 + 按最佳实践执行" 拍板, 立刻写主源文档 + 同步 3 副本 + BUMP MANIFEST + commit + push + 5 min verify, 失职 #N+16 沉淀, 累积 20 失职)