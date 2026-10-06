# App Store 订阅与 App 同批提审 SOP

> 适用场景：App 首次提交自动续期订阅，或因 Guideline 2.1(b)「In-App Purchase products have not been submitted for review」被拒后重新提交。
>
> 实战来源：ReverseWorldGo 3.0.0 (25) 被拒，改用 3.0.0 (26) 并将 App、订阅群组、月订阅、年订阅组成同一个四项目提交后解决。

## 核心结论

订阅显示“准备提交”或“可供审核”、审核截图显示 COMPLETE、StoreKit 产品 ID 正确，都不代表订阅已经提交给审核团队。

唯一可靠的判定标准是：进入 App Store Connect 的最终审核提交详情页，确认“已提交项目”同时列出 App 版本、订阅群组以及每一项订阅，并且它们全部显示“等待审核”。

不要假设订阅会自动跟随 App 版本进入审核。

## 正确提交顺序

1. 完成每项订阅的元数据：本地化、价格、销售范围和审核截图。
2. 上传一个新的 binary，并等待 App Store Connect 完成处理。
3. 在 TestFlight 或构建列表确认新 build 状态为“准备提交”，不要继续使用 Apple 已拒绝的旧 build。
4. 进入订阅群组，点击“添加以供审核”，创建或选择同一个草稿提交。
5. 分别进入每一项自动续期订阅，点击“添加以供审核”，选择同一个草稿。
6. 进入 App 版本页面，选择新 build，保存。
7. 点击 App 版本的“添加以供审核”，选择包含订阅的同一个草稿。
8. 打开草稿，逐项检查后再点击“提交以供审核”。

ReverseWorldGo 的正确草稿必须包含以下四项：

- iOS App 3.0.0 (26)
- ReverseWorldGo Premium 订阅群组
- ReverseWorldGo Premium Monthly
- ReverseWorldGo Premium Yearly

## 提交前硬性检查

以下条件必须全部满足：

- [ ] 新 build 已处理完成，版本号和 build 号正确。
- [ ] App 版本使用新 build，而非刚被拒绝的旧 build。
- [ ] 订阅群组已加入草稿。
- [ ] 每一项订阅都已单独加入同一个草稿。
- [ ] 草稿明确显示“准备提交项目 (N)”，数量与预期一致。
- [ ] 草稿中的 App、订阅群组和所有订阅属于同一平台和同一提交。
- [ ] 点击提交后，新 Submission 的“已提交项目”数量仍与草稿一致。
- [ ] 每一项状态都是“等待审核”。
- [ ] 保存新 Submission ID 和详情页链接到拒审记录。

对本项目而言，最终提交详情页必须显示“已提交项目 (4)”。只显示“1 个项目”即视为失败，必须撤回并重建统一草稿。

## 最危险的错误路径

### 只重新提交 App 版本

在旧拒审详情页点击“重新提交至 App 审核”，可能生成仅包含 App 的单项提交。即使旁边另有包含订阅的草稿，Apple 也不会把两者视为同一提交。

识别信号：

- 审核详情显示“已提交项目 (1)”；
- 订阅仍显示“可供审核”；
- 订阅草稿的“提交以供审核”按钮仍不可用。

处理方法：及时取消这个单项提交，等待 App 状态变为“被开发者拒绝”，然后从 App 版本页面点击“添加以供审核”，把 App 加入已有的订阅草稿。确认草稿包含全部项目后再提交。

### 只加入订阅群组

订阅群组和具体订阅是不同审核项目。只加入群组仍然不完整；Monthly、Yearly 等每项产品都必须分别加入同一草稿。

### 相信 READY_TO_SUBMIT 等于已提交

`READY_TO_SUBMIT` 只表示元数据具备提交条件，不表示项目已进入某个 Review Submission。必须以最终 Submission 的项目列表为准。

## 遇到 2.1(b) 时的诊断顺序

1. 先读取 Resolution Center 的完整拒因，不凭 REST 状态猜测。
2. 检查审核详情页的“已提交项目”数量，而不是先改 StoreKit 代码。
3. 对照 App 中引用的产品 ID 与 App Store Connect 中的真实订阅 ID。
4. 检查每项订阅的审核截图和本地化是否齐全。
5. 如果代码能正常加载产品，而 Submission 只有 App 一项，优先修复 ASC 提交流程。
6. 按 Apple 要求上传新 binary，不重复提交被拒 build。

## 归档与上传注意事项

- 每次重提递增 `CURRENT_PROJECT_VERSION`。
- Release 使用 Automatic Signing 时，不要同时硬编码 `Apple Distribution` 身份，否则可能出现自动签名与手动签名冲突。
- 先执行 Release 真机目标构建，再 Archive、Export、Upload。
- 上传成功不等于可选择；必须等待 ASC 处理完成后再绑定到 App 版本。

## 证据留存

每次处理至少记录：

- Apple 完整拒因、Guideline、审核设备和被审核 build；
- 原 Submission ID；
- 新 build 号；
- 新 Submission ID；
- 最终提交项目数量和项目名称；
- 提交时间与最终状态；
- 如有误提交，记录取消原因，避免后续误把单项提交当成正确提交。

本次原始证据见外部拒审档案：`apple-app-reject-records/ReverseWorldGo/2026-07-29/App Store Connect.md`。

