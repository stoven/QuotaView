# QuotaView 潮汐窗 Header Logo 规格

> 文档编号：`QV-BRAND-TIDE-WINDOW-005`
>
> 目标版本：QuotaView `0.3.5 (Build 6)`
>
> 规格状态：`Accepted`
>
> 交付状态：`Verifying`
>
> 接受与实施授权：产品所有者已确认无红点 B 方向，并于 2026-08-13
> 明确要求替换主面板左上角旧彩色 Logo。

## 1. 目标与范围

主面板 Header 的 `24 × 24 pt` 品牌图标改为无红点“潮汐窗”：白色陶瓷
外壳、深色圆形窗口、蓝色潮汐填充与一条克制的青色水线。它应与 Build 6
动态菜单栏图标形成同一品牌隐喻，同时在深浅玻璃背景上保持小尺寸识别度。

本规格只覆盖主面板 Header。设置页正式 App Icon、macOS AppIcon、Widget、
重置页 Header 和菜单栏动态百分比行为均不在本次范围内。

## 2. Requirement

### `BRAND-HEADER-01` — 视觉语言

使用已经确认的无红点潮汐窗，不得保留旧粉蓝渐变六边形，也不得增加状态
圆点、文字、光晕或第二层玻璃。蓝色潮面与青色水线是唯一品牌色，其余保持
陶瓷白与深海军蓝。

### `BRAND-HEADER-02` — 几何与布局

图标占位固定为 `24 × 24 pt`，外轮廓使用既有 `7.5 pt` 连续圆角，继续位于
`48 pt` Header 的 `12 pt` 内边距中。不得改变 QuotaView 标题、退出按钮、
Header 高度、分隔线或面板整体尺寸。

### `BRAND-HEADER-03` — 渲染质量

Logo 使用 SwiftUI 原生矢量路径绘制，不依赖在 24 pt 下缩放的大位图。深色
圆窗、潮面和水线必须裁切在圆窗内部；外壳边缘允许一条低对比描边与既有
柔和阴影，以同时适配深色、浅色和跟随系统外观。

### `BRAND-HEADER-04` — 语义与验证

Logo 继续从辅助功能树隐藏，不改变 Header 的可访问名称或交互。自动化测试
与 Universal Release 无签名构建必须通过；真实玻璃背景中的小尺寸清晰度、
光学居中和品牌一致性由产品所有者运行后验收。未确认前交付状态保持
`Verifying`，不得记录为发布或 appcast 准入。

## 3. 追踪

| Requirement ID | 生产源码 | 自动化 | 产品验收 |
|---|---|---|---|
| `BRAND-HEADER-01` | `QuotaViewFigmaMenu.swift` | 编译与代码审查 | 等待 |
| `BRAND-HEADER-02` | `QuotaViewFigmaMenu.swift` | 几何常量审查 | 等待 |
| `BRAND-HEADER-03` | `QuotaViewFigmaMenu.swift` | 深浅语义色审查 + 构建 | 等待 |
| `BRAND-HEADER-04` | `QuotaViewFigmaMenu.swift` | `swift test`、Universal 构建 | 等待 |

## 4. 当前验证证据

- Header 已改用 SwiftUI 原生矢量潮汐窗，不再读取旧彩色位图；`24 × 24 pt`
  占位、`7.5 pt` 连续圆角、Header 高度与内边距保持不变；
- `swift test` 共 74 项通过、0 失败，其中包含 Header Logo 几何常量测试；
- `./scripts/build-app.sh` 的 Universal Release 无签名构建通过，App、Widget、
  Hook、Core 与 Sparkle 均为 `x86_64 arm64`；本地产物为
  `dist/QuotaView.app`；
- Impeccable UI 检查器无发现。真实玻璃背景中的小尺寸观感仍等待产品所有者
  运行验收；本轮没有 Developer ID 签名、公证、Release 或 appcast 准入。
