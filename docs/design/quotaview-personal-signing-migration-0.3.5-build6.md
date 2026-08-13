# QuotaView Build 6 个人签名身份迁移规格

> 文档编号：`QV-ARCH-PERSONAL-SIGNING-006`
> 文档类型：SDD 架构与构建规格
> 规格状态：`Accepted`
> 交付状态：`Verifying`
> 接受日期：2026-08-13
> 目标版本：QuotaView `0.3.5 (Build 6)`

## 1. 问题与授权

Build 6 的本地 ad-hoc 包没有 Team ID。macOS `SystemPolicyAppData` 因此拒绝
Widget Extension 读取团队前缀 App Group 中的快照，即使主 App 已成功写入，
Widget 仍显示数据不可用。

产品所有者于 2026-08-13 明确放弃将旧团队 `BUUH229D5Q` 作为后续本地开发
签名身份，并授权使用自己的 Personal Team `7KP9UX9AA3` 重新签名、迁移相关
标识并构建 Build 6。

## 2. Requirement

### SIGN-MIGRATION-01：本地签名身份

- Build 6 App、Widget 与 Helper 使用同一 Apple Development 身份；
- 最终签名 Team ID 必须为 `7KP9UX9AA3`；
- ad-hoc 包不得作为 Widget 共享数据验收证据。

### SIGN-MIGRATION-02：唯一 Bundle 与 App Group

- 主 App Bundle ID：`com.stoven.quotaview`；
- Widget Bundle ID：`com.stoven.quotaview.widget`；
- App Group：`7KP9UX9AA3.com.stoven.quotaview.shared`；
- App 与 Widget 的最终 entitlement 必须包含完全相同的 App Group；
- 默认 Widget Contract、Info.plist、xcconfig、entitlements、测试和构建门禁
  必须同步，不得保留混合身份。

### SIGN-MIGRATION-03：发布历史与更新隔离

- 已发布 `0.3.5 Build 5`、tag、Release、资产、公开 appcast 与旧团队签名事实
  保持不变；
- Build 6 个人签名包只是本地验证产物，不执行公证、tag、Release 或 appcast；
- 旧 Sparkle Feed 的 Team/Bundle 信任条件不迁移到 Personal Team，个人签名
  Build 6 必须保持更新器不可用，避免安装旧身份资产。

### SIGN-MIGRATION-04：迁移与降级

- 新身份使用新的 App Group 容器，不迁移旧共享快照；
- 主 App 首次成功刷新后写入新容器，Widget 再读取该快照；
- 桌面上旧 Bundle ID 的 Widget 实例需要移除并重新添加；
- 证书创建或签名失败时停止于构建阶段，不得回退为 ad-hoc 并声称已修复。

### SIGN-MIGRATION-05：验收

- `security find-identity` 能识别 Apple Development 身份；
- App、Widget、Helper 的签名有效且 App/Widget Team ID 为 `7KP9UX9AA3`；
- App、Widget 均为 `0.3.5 (6)` 且包含 `arm64 x86_64`；
- App Group entitlement 一致，Widget 实际读取新容器时无
  `SystemPolicyAppData deny file-read-data`；
- 自动化测试与 `git diff --check` 通过；
- Widget 的最终数据、视觉与交互由产品所有者验收。

## 3. 非目标

- 不改变 Widget 数据、布局、隐私或时间线语义；
- 不迁移旧 App Group 文件；
- 不撤回或覆盖任何已发布版本；
- 不授权 Developer ID、公证、GitHub Release 或公开 appcast；
- 不把 Personal Team 包描述为可公开分发的稳定版本。

## 4. 当前验证记录

2026-08-13 已完成：

- Xcode 为 Personal Team 创建 `Apple Development: Steven He
  (8U28H2PZU6)` 证书；
- 自动签名 Debug 构建与脚本生成的 Universal Release 构建均通过；
- App、Widget 与 Helper 的 Team ID 均为 `7KP9UX9AA3`，Hardened Runtime
  和深度签名验证通过；
- App / Widget Bundle ID、`0.3.5 (6)` 版本与 App Group entitlement 一致；
- Release App 成功写入新共享容器，系统记录该访问为 `APPROVED`；
- `swift test` 共 74 项通过、0 失败，临时 Debug 数据搜索与
  `git diff --check` 通过；
- 本地 ZIP 为 `dist/QuotaView-v0.3.5-build.6.zip`，SHA-256
  `3955623af06f8aa68ed953716bf3e828b1ff7199a885eb3a3f68bd3c0e356b49`；
- 产品所有者移除旧 Bundle ID Widget 并重新添加新 Widget 后，于
  2026-08-13 确认验收成功；实机 Widget 正常显示剩余额度、方案、重置
  倒计时、Credits 余额及今日/累计 Tokens，不再显示“额度数据不可用”；
- 未执行 Developer ID、公证、Staple、tag、Release 或 appcast。

`SIGN-MIGRATION-01` 至 `SIGN-MIGRATION-05` 的本地构建、共享数据与产品验收
均已通过。由于 Build 6 仍是未公证、未发布的个人签名产物，交付状态继续为
`Verifying`，不得写为 `Released`。
