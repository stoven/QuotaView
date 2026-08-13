# QuotaView 潮汐窗品牌 Logo 规格

> 文档编号：`QV-BRAND-TIDE-WINDOW-005`
>
> 目标版本：QuotaView `0.3.5 (Build 6)`
>
> 规格状态：`Accepted`
>
> 交付状态：`Verifying`
>
> 接受与实施授权：产品所有者已确认无红点 B 方向，并于 2026-08-13
> 明确要求替换主面板左上角旧彩色 Logo；同日进一步明确要求替换 Widget
> 左上角旧单色 Logo。

## 1. 目标与范围

主面板 Header 的 `24 × 24 pt` 品牌图标改为无红点“潮汐窗”：白色陶瓷
外壳、深色圆形窗口、蓝色潮汐填充与一条克制的青色水线。它应与 Build 6
动态菜单栏图标形成同一品牌隐喻，同时在深浅玻璃背景上保持小尺寸识别度。

本规格覆盖主面板 Header 与 Widget 左上角品牌标识。设置页正式 App Icon、
macOS AppIcon、重置页 Header 和菜单栏动态百分比行为均不在本次范围内。

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

### `BRAND-WIDGET-05` — Widget 小尺寸适配

Small 与 Medium Widget 左上角旧单色六边形替换为无红点潮汐窗。使用专为
`12 × 12 pt` 设计的彩色矢量资源，不把主面板 `24 pt` 图形直接位图缩放；
保留陶瓷白外壳、深色圆窗、蓝色潮面、青色水线与顶部凹口。

### `BRAND-WIDGET-06` — Widget 布局与验证不变量

Logo 固定为 `12 × 12 pt`，继续从辅助功能树隐藏。不得改变 QuotaView 标题、
连接状态点、Widget `16 pt` 内容边距、Small / Medium 布局、业务数据或深浅
外观语义。深浅资源必须保持同一品牌构图；Asset Catalog、自动化测试与
Universal Personal Team 构建必须通过，实际桌面小组件观感等待产品所有者验收。

## 3. 追踪

| Requirement ID | 生产源码 | 自动化 | 产品验收 |
|---|---|---|---|
| `BRAND-HEADER-01` | `QuotaViewFigmaMenu.swift` | 编译与代码审查 | 等待 |
| `BRAND-HEADER-02` | `QuotaViewFigmaMenu.swift` | 几何常量审查 | 等待 |
| `BRAND-HEADER-03` | `QuotaViewFigmaMenu.swift` | 深浅语义色审查 + 构建 | 等待 |
| `BRAND-HEADER-04` | `QuotaViewFigmaMenu.swift` | `swift test`、Universal 构建 | 等待 |
| `BRAND-WIDGET-05` | `QuotaViewWidget.swift`、Widget Logo SVG | Asset Catalog 编译 + 代码审查通过 | 等待 |
| `BRAND-WIDGET-06` | `QuotaViewWidget.swift`、Widget Logo SVG | 74 项 `swift test`、Personal Team Universal 构建通过 | 等待 |

## 4. 当前验证证据

- Header 已改用 SwiftUI 原生矢量潮汐窗，不再读取旧彩色位图；`24 × 24 pt`
  占位、`7.5 pt` 连续圆角、Header 高度与内边距保持不变；
- `swift test` 共 74 项通过、0 失败，其中包含 Header Logo 几何常量测试；
- `./scripts/build-app.sh` 的 Personal Team Universal Release 构建通过，App、
  Widget 与 Helper 均为 `x86_64 arm64`，App 与 Widget 均由
  `Apple Development: Steven He (8U28H2PZU6)` / Team `7KP9UX9AA3` 签名；
  本地产物为 `dist/QuotaView.app`；
- Impeccable UI 检查器无发现。真实玻璃背景中的小尺寸观感仍等待产品所有者
  运行验收；本轮没有 Developer ID 签名、公证、Release 或 appcast 准入。
- Small 与 Medium Widget 已改用专用 `12 × 12 pt` 无红点潮汐窗 SVG；标题、
  状态点、`16 pt` 内容边距、数据布局与辅助功能语义保持不变；
- `assetutil` 已确认深浅两套资源均以 RGB/ARGB、`12 × 12 pt @1x`、
  `24 × 24 px @2x` 编入 Widget `Assets.car`，并保留矢量表示；桌面小组件中的
  实际清晰度、光学居中与品牌一致性仍等待产品所有者验收。
