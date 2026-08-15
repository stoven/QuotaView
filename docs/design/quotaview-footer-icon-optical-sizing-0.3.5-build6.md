# QuotaView Footer 图标光学校准规格

> 文档编号：`QV-DESIGN-FOOTER-ICONS-008`
>
> 目标版本：QuotaView `0.3.5 (Build 6)`
>
> 规格状态：`Accepted`
>
> 交付状态：`Verifying`
>
> 接受与实施授权：产品所有者于 2026-08-14 提供生产截图，明确要求 Footer
> 圆形按钮中的所有图形与中间 ChatGPT Logo 一样大。

## 1. 问题与范围

概览页与额度重置详情页 Footer 共用同步、打开 ChatGPT 和设置三枚 `24 pt`
圆形按钮。当前按钮外框一致，但同步与设置图形的可见包围盒明显小于中间
ChatGPT Logo，导致同组按钮视觉重量不一致。

本规格只校准这组三枚 Footer 按钮的内部图形。Header 退出按钮、重置页返回
按钮、按钮外框、间距、Footer 高度、操作行为和业务数据均不在本次范围内。

## 2. Requirement

### `FOOTER-ICON-01` — 统一视觉基准

中间 ChatGPT Logo 作为当前组内基准，内部图形的最大可见尺寸保持约
`14 pt`。同步与设置图形使用等比例缩放达到相同的光学尺寸；不得拉伸图形，
也不得为了数学方形而改变原始宽高比。

### `FOOTER-ICON-02` — 布局不变量

三枚按钮继续使用 `24 × 24 pt` 圆形外框、既有 `9 pt` 组内间距、Footer
内边距与高度。只调整 SVG 内部图形，不缩放圆形底座、描边或内阴影。

### `FOOTER-ICON-03` — 页面与外观一致性

概览页与额度重置详情页继续复用同一组资源。深色和浅色 SVG 使用相同几何
变换与光学中心，颜色、描边、背景透明度和矢量保留设置保持既有语义。

### `FOOTER-ICON-04` — 交互与辅助功能不变量

同步、打开 ChatGPT 与设置的 action、Disabled、Hover、Pressed、Reduce
Motion、Tooltip、VoiceOver 标签和焦点行为均不得改变。

### `FOOTER-ICON-05` — 验证边界

深浅 SVG 必须通过 XML 与 Asset Catalog 编译检查；自动化测试和 Personal
Team Universal Release 构建必须通过。Codex 不主动截图，最终光学一致性由
产品所有者运行生产 App 后验收；未确认前交付状态保持 `Verifying`。

## 3. 追踪

| Requirement ID | 生产源码 | 自动化 | 产品验收 |
|---|---|---|---|
| `FOOTER-ICON-01` | Sync / Settings 深浅 SVG | 可见包围盒与等比例变换审查通过 | 等待 |
| `FOOTER-ICON-02` | Footer SVG、既有 SwiftUI 布局 | 外框与间距代码审查通过 | 等待 |
| `FOOTER-ICON-03` | 四个深浅 SVG | XML / Asset Catalog 编译通过 | 等待 |
| `FOOTER-ICON-04` | `QuotaViewFigmaMenu.swift`、`QuotaViewFigmaResetMenu.swift` | SwiftUI 源码无行为改动；Impeccable 无发现 | 等待 |
| `FOOTER-ICON-05` | Build 6 App | Personal Team Universal 构建通过；完整测试复跑阻塞 | 等待 |

## 4. 当前验证证据

- 同步图形以 `1.73171×` 等比缩放并重新光学居中，最大可见尺寸由约
  `8.08 pt` 增至 `14 pt`；设置图形以 `1.42769×` 等比缩放，最大可见尺寸
  由约 `9.81 pt` 增至 `14 pt`；ChatGPT Logo 和三枚 `24 pt` 圆形底座未改；
- 深色与浅色资源使用完全相同的几何变换；四个 SVG 均通过 `xmllint`，
  Impeccable 检查器无发现；
- Personal Team Universal Release 构建通过，`assetutil` 确认四套资源均以
  `24 × 24 px @1x`、`48 × 48 px @2x` 和保留矢量表示编入 `Assets.car`；
  App、Widget 与 Helper 保持 `x86_64 arm64`；
- 完整 `swift test` 复跑未完成：测试执行停滞在既有
  `testDemoResetUsesSimulationBoundary`，该用例单独执行同样停滞；普通
  `testHeaderLogoKeepsAcceptedCompactGeometry` 单独通过。本轮没有修改该
  业务测试或相关生产逻辑；
- 签名构建产物为 `dist/QuotaView.app`。最终深浅外观、概览页与重置详情页
  的光学一致性等待产品所有者验收；未执行 Developer ID、公证、Release 或
  appcast 准入。
